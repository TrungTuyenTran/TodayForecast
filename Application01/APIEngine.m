//
//  APIEngine.m
//  Application01
//
//  Created by Tran Trung Tuyen on 11/3/16.
//  Copyright (c) 2016 Tran Trung Tuyen. All rights reserved.
//

#import "APIEngine.h"
#import "AFNetworking.h"
#import "APIEngine.h"
#import "AFHTTPSessionManager.h"
#import "AFURLResponseSerialization.h"
#import "AFURLRequestSerialization.h"
#import "WeatherInfo.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@implementation APIEngine

-(void)GetWeatherByLocation:(NSString *)latitude
                           :(NSString *)longitude
                 completion:(void(^)(BOOL))completion{
    [self GetRequestFromURL:[NSString stringWithFormat:@"http://api.wunderground.com/api/624f213ef29e2b36/conditions/forecast/alert/q/%@,%@.json",latitude,longitude] completion:^(NSDictionary* result){
        if(result != nil){
            self.resultWeather = [[WeatherInfo alloc] init];
            self.resultWeather.urlImage =[[result objectForKey:@"current_observation"] valueForKey:@"icon_url"];
            self.resultWeather.temperature = [NSString stringWithFormat:@"%@°C",[[result objectForKey:@"current_observation"] valueForKey:@"temp_c"]];
            self.resultWeather.humidity = [NSString stringWithFormat:@"%@",[[result objectForKey:@"current_observation"] valueForKey:@"relative_humidity"]];
            self.resultWeather.pressure = [NSString stringWithFormat:@"%@ hPa",[[result objectForKey:@"current_observation"] valueForKey:@"pressure_mb"]];
            self.resultWeather.mintemp = [NSString stringWithFormat:@"%@°C",[[result objectForKey:@"current_observation"] valueForKey:@"dewpoint_c"]];
            self.resultWeather.maxtemp = [NSString stringWithFormat:@"%@°C",[[result objectForKey:@"current_observation"] valueForKey:@"heat_index_c"]];
            self.resultWeather.latitude = latitude;
            self.resultWeather.longitude = longitude;
            completion(YES);
        }
        else{
            UIAlertView* arlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Failed to get data from server"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [arlert show];
            completion(YES);
        }
    }];
}

- (NSURLSessionDataTask*)GetRequestFromURL:(NSString*)_url completion:(void(^)(NSDictionary*))completion
{
    self.responseSerializer =[AFJSONResponseSerializer serializer];
    NSURLSessionDataTask *task = [[NSURLSessionDataTask alloc] init];
    task = [self GET:_url
          parameters:nil
          success:^(NSURLSessionDataTask *task, id responseObject) {
                                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                    if (httpResponse.statusCode == 200) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            NSLog(@"Get \"%@\" url success", _url);
                                            completion(responseObject);
                                        });
                                    } else {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            completion(nil);
                                        });
                                    }
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        completion(nil);
                                    });
                                }];
    return task;
}

-(WeatherInfo*) getWeatherResult{
    return self.resultWeather;
}

-(void)getAddressFromLatLon:(double)Latitude withLongitude:(double)Longitude completion:(void (^)(BOOL))_completion
{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:Latitude longitude:Longitude];
    
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
          self.location = [placemarks objectAtIndex:0];
         _completion(YES);
     }];
}
     
@end
