#import <UIKit/UIKit.h>

@interface CachemanifestViewController : UIViewController <UIWebViewDelegate> {
	UIWebView *webView;
	UIActivityIndicatorView *activityView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;

@end

