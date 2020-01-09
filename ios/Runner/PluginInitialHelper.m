//
// Created by Caijinglong on 2019-03-04.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import "PluginInitialHelper.h"
#import "FeedBackPlugin.h"

@implementation PluginInitialHelper {

}
- (instancetype)initWithFlutterCtl:(FlutterViewController *)ctl {
    self = [super init];
    if (self) {
        self.ctl = (FlutterViewController *) ctl;
    }

    return self;
}

- (void)initPlugins {
    FeedBackPlugin *plugin = [FeedBackPlugin new];
    [plugin initFeedBackWithFlutterViewController:self.ctl];
}

@end
