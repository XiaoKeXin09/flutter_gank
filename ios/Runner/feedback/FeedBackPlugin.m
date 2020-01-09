//
// Created by Caijinglong on 2019-03-04.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <Flutter/Flutter.h>
#import "FeedBackPlugin.h"


@implementation FeedBackPlugin {
    YWFeedbackKit *feedbackKit;

}
NSObject <FlutterPluginRegistry> *registry;

- (void)initFeedBackWithFlutterViewController:(FlutterViewController *)flutterViewController {
    NSString *appKey = @"25802840";
    NSString *appSecret = @"9c5e748648850a2116c0fc1b5da2bcee";
    feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:appKey appSecret:appSecret];

    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"com.lijnshanmx/FlutterNativePlugin" binaryMessenger:flutterViewController];
    [channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
        if ([call.method isEqualToString:@"openFeedbackActivity"]) {
            [feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(BCFeedbackViewController *viewController, NSError *error) {
                if (error) {
                    NSLog(@"error = %@", error);
                }

                // copy from https://github.com/aliyun/alicloud-ios-demo/blob/274b4a69751314521ee8f1ed24e7022927a1971d/feedback_ios_demo/YWFeedbackDemo/YWLoginController.m#L60-L65
                if (viewController != nil) {
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
                    [flutterViewController presentViewController:nav animated:YES completion:nil];

                    [viewController setCloseBlock:^(UIViewController *aParentController) {
                        [aParentController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    result(@YES);
                } else {
                    result(@NO);
                }
            }];
        }
    }];
}

@end
