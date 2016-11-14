//
//  StaticVariables.h
//  Application01
//
//  Created by Tran Trung Tuyen on 11/7/16.
//  Copyright (c) 2016 Tran Trung Tuyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticVariables : NSObject

@property(strong, nonatomic, readwrite) NSString *CurrentUserLatitude;
@property(strong, nonatomic, readwrite) NSString *CurrentUserLongitude;

+ (StaticVariables*)sharedInstance;

@end
