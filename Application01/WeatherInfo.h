//
//  WeatherInfo.h
//  
//
//  Created by Tran Trung Tuyen on 11/4/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeatherInfo : NSManagedObject

@property (nonatomic, retain) NSString * humidity;
@property (nonatomic, retain) NSString * temperature;
@property (nonatomic, retain) NSString * urlImage;
@property (nonatomic, retain) NSString * maxtemp;
@property (nonatomic, retain) NSString * mintemp;
@property (nonatomic, retain) NSString * pressure;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;

@end
