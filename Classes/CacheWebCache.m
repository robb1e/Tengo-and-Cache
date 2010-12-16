#import "CacheWebCache.h"


@implementation CacheWebCache

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{

	NSCachedURLResponse *cachedResponse = nil;
	NSURL *url = [request URL];
	if (![url isFileURL]){

		NSString *token = [url relativePath];
		
		NSString *tokenPath = [NSHomeDirectory() stringByAppendingFormat:[NSString stringWithFormat:@"/Documents/cache%@", token]];

		NSArray *directories = [token componentsSeparatedByString:@"/"];
		NSString *newDirectory = @"";
		for (NSUInteger i = 0; i < [directories count] - 1; i++) {
			NSString *directory = [NSString stringWithFormat:@"%@", [directories objectAtIndex:i]];
			newDirectory = [NSString stringWithFormat:@"%@/%@", newDirectory, directory];
		}
		newDirectory = [newDirectory substringFromIndex:1];
		
		if (newDirectory != @""){
			newDirectory = [NSHomeDirectory() stringByAppendingFormat:[NSString stringWithFormat:@"/Documents/cache%@", newDirectory]];
			NSLog(@"Creating directory %@", newDirectory);
			[[NSFileManager defaultManager] createDirectoryAtPath:newDirectory withIntermediateDirectories:YES attributes:nil error:nil];			

		}
		
		NSURLResponse *response = [[NSURLResponse alloc] init];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:tokenPath]){
			NSData *data = [[NSFileManager defaultManager] contentsAtPath:tokenPath];
			cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
			NSLog(@"file exists, replying with %@", cachedResponse);
		} else {
			NSData *tokenData = [NSData dataWithContentsOfURL:url];
			[tokenData writeToFile:tokenPath atomically:YES];
			cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:tokenData];
			NSLog(@"cache response for request %@, writing to %@ and responding with %@", request, tokenPath, cachedResponse);	
		}
		
	}
	
	return cachedResponse;
	
}

@end
