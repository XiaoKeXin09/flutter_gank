//
// Created by Caijinglong on 2019-03-04.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface PluginInitialHelper : NSObject
@property(nonatomic, strong) FlutterViewController *ctl;

- (instancetype)initWithFlutterCtl:(FlutterViewController *)ctl;

- (void)initPlugins;

@end
