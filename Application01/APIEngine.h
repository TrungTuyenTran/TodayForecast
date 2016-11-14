//
//  APIEngine.h
//  Application01
//
//  Created by Tran Trung Tuyen on 11/3/16.
//  Copyright (c) 2016 Tran Trung Tuyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherInfo.h"
#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>

@interface APIEngine : AFHTTPSessionManager

@property (nonatomic, strong) WeatherInfo* resultWeather;
@property (nonatomic,strong) CLPlacemark* location;

-(void)GetWeatherByLocation:(NSString*)latitude :(NSString*)longitude
                 completion:(void(^)(BOOL))completion;
-(WeatherInfo*) getWeatherResult;
-(NSURLSessionDataTask*)GetRequestFromURL:(NSString *)username
                completion:(void (^)(NSDictionary*))completion;
-(void)getAddressFromLatLon:(double)Latitude withLongitude:(double)Longitude completion:(void (^)(BOOL))_completion
;

@end
