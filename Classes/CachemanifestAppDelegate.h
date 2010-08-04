#import <UIKit/UIKit.h>

@class CachemanifestViewController;

@interface CachemanifestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CachemanifestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CachemanifestViewController *viewController;

-(void)updateCache;

@end

