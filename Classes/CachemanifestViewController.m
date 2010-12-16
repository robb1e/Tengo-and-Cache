#import "CachemanifestViewController.h"

@implementation CachemanifestViewController

@synthesize webView, activityView;

- (void)viewDidLoad {
	// Set delete to self so we can tell when the webView has finished loading and show activity
	webView.delegate = self;
	activityView.hidden = NO;
	// Load the HTML file from the documents directory
	NSString *indexPage = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/index.html"];
	NSURL *url = [NSURL fileURLWithPath:indexPage];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[webView loadRequest:request];
    [super viewDidLoad];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[activityView release];
	[webView release];
    [super dealloc];
}

// UIWebViewDelegate methods

- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
	NSLog(@"webView finished loading");
	activityView.hidden = YES;
}

@end
