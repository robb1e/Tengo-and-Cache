#import "CachemanifestAppDelegate.h"
#import "CachemanifestViewController.h"
#import "CacheWebCache.h"

@implementation CachemanifestAppDelegate

@synthesize window;
@synthesize viewController;

-(NSString *) webCacheDirectory
{	
	NSString *webCacheDirectory = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/cache"];
	NSLog(@"Creating directory %@", webCacheDirectory);
	[[NSFileManager defaultManager] createDirectoryAtPath:webCacheDirectory attributes:nil];		
	return webCacheDirectory;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
	
	// caching setup
	CacheWebCache *urlCache = [[[CacheWebCache alloc] initWithMemoryCapacity:(1<<20) diskCapacity:(1<<24) diskPath:[self webCacheDirectory]] autorelease];
	[NSURLCache setSharedURLCache:urlCache];
	
	
    [self updateCache];
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	return YES;
}

- (void)updateCache {
	
	BOOL isDirectory = NO;
	NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"www"];
	NSString *destinationPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/index.html"];
	NSLog(@"Looking for cached index file %@", destinationPath);

	if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath isDirectory:&isDirectory]) {
		NSLog(@"No index.html page in Documents, copying from resource bundle");
		NSError *err;
		[[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&err];		
	} else {
		NSLog(@"Cache already upto date");
	}
	
	NSString *domain = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"AppUri"];
	NSString *manifestUri = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ManifestUri"];
	NSLog(@"Retriving the manifest from %@", manifestUri);
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",domain,manifestUri]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	NSString *manifestContent = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"Cache manifest reads:\n%@", manifestContent);

	NSArray *tokens = [manifestContent componentsSeparatedByString: @"\n"];
	NSMutableArray *cleanTokens = [[NSMutableArray alloc] init];
	NSString *manifestToken = @"cache manifest";
	NSString *commentToken = @"#";
	NSString *networkToken = @"network:";
	NSString *cacheToken = @"cache:";
	NSString *fallbackToken = @"fallback:";
	
	for (NSString *token in tokens) {
		NSLog(@"token:%@", token);
		BOOL clean = YES;
		if ([[token lowercaseString] rangeOfString:manifestToken].location != NSNotFound)
			clean = NO;
		if ([[token lowercaseString] rangeOfString:commentToken].location != NSNotFound)
			clean = NO;
		if ([[token lowercaseString] rangeOfString:networkToken].location != NSNotFound)
			clean = NO;
		if ([[token lowercaseString] rangeOfString:cacheToken].location != NSNotFound)
			clean = NO;
		if ([[token lowercaseString] rangeOfString:fallbackToken].location != NSNotFound)
			clean = NO;
			
		if (clean)
			[cleanTokens addObject:[token stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
	}

	NSString *tokenPath = [NSHomeDirectory() stringByAppendingFormat:[NSString stringWithFormat:@"/Documents/%@", @"index.html"]];
	NSString *tokenUri = [NSString stringWithFormat:@"%@", domain];
	NSURL *tokenUrl = [NSURL URLWithString:tokenUri];
	NSLog(@"Downloading %@ to %@", tokenUri, tokenPath);
	NSData *tokenData = [NSData dataWithContentsOfURL:tokenUrl];
	[tokenData writeToFile:tokenPath atomically:YES];
	
	for (NSString *token in cleanTokens){
		NSLog(@"cleaned token:%@", token);
		tokenPath = [NSHomeDirectory() stringByAppendingFormat:[NSString stringWithFormat:@"/Documents/%@", token]];
		tokenUri = [NSString stringWithFormat:@"%@/%@", @"http://localhost:3000", token];
		tokenUrl = [NSURL URLWithString:tokenUri];
		NSLog(@"Downloading %@ to %@", tokenUri, tokenPath);
		tokenData = [NSData dataWithContentsOfURL:tokenUrl];
		
		NSArray *directories = [token componentsSeparatedByString:@"/"];
		NSString *newDirectory = @"";
		for (NSUInteger i = 0; i < [directories count] - 1; i++) {
			NSString *directory = [NSString stringWithFormat:@"%@", [directories objectAtIndex:i]];
			newDirectory = [NSString stringWithFormat:@"%@/%@", newDirectory, directory];
		}
		
		if (newDirectory != @""){
			newDirectory = [NSHomeDirectory() stringByAppendingFormat:[NSString stringWithFormat:@"/Documents/%@", newDirectory]];
			NSLog(@"Creating directory %@", newDirectory);
			[[NSFileManager defaultManager] createDirectoryAtPath:newDirectory attributes:nil];			
		}
		
		[tokenData writeToFile:tokenPath atomically:YES];
	}
	
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
