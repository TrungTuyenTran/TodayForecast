//
//  StaticVariables.m
//  Application01
//
//  Created by Tran Trung Tuyen on 11/7/16.
//  Copyright (c) 2016 Tran Trung Tuyen. All rights reserved.
//

#import "StaticVariables.h"

@implementation StaticVariables

@synthesize CurrentUserLatitude = _CurrentUserLatitude;
@synthesize CurrentUserLongitude = _CurrentUserLongitude;

+ (StaticVariables *)sharedInstance {
    static dispatch_once_t onceToken;
    static StaticVariables *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[StaticVariables alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _CurrentUserLongitude = @"";
        _CurrentUserLongitude = @"";
    }
    return self;
}
@end
