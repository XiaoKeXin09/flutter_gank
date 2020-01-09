#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "PluginInitialHelper.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  FlutterViewController *flutterViewController = (FlutterViewController*)self.window.rootViewController;
  
  PluginInitialHelper *helper = [[PluginInitialHelper alloc]initWithFlutterCtl:flutterViewController];
  [helper initPlugins];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
