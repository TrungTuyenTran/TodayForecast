//
//  Annotation.h
//  Application01
//
//  Created by Tran Trung Tuyen on 11/10/16.
//  Copyright (c) 2016 Tran Trung Tuyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject<MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSString* title;
    NSString* subtitle;
    
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;

@end
