//
//  DetailWeatherViewController.h
//  Application01
//
//  Created by Tran Trung Tuyen on 11/10/16.
//  Copyright (c) 2016 Tran Trung Tuyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherInfo.h"

@interface DetailWeatherViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableDetailView;
@property (weak, nonatomic) IBOutlet UIImageView *imgIconWeather;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

@property (strong,nonatomic) WeatherInfo* weather;

- (IBAction)BackToPrevScreen:(id)sender;

@end
