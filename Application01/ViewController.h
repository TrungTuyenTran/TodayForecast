//
//  ViewController.h
//  Application01
//
//  Created by Tran Trung Tuyen on 11/2/16.
//  Copyright (c) 2016 Tran Trung Tuyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "OtherWeatherTableViewCell.h"
#import "APIEngine.h"


@interface ViewController : UIViewController<CLLocationManagerDelegate , UITableViewDelegate , UITableViewDataSource>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) IBOutlet OtherWeatherTableViewCell *customCell;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentLocation;
@property (strong, nonatomic) IBOutlet UIImageView *imgCurrentWeather;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentTemp;
@property (weak, nonatomic) IBOutlet UITableView *tableOtherWeatherIndex;

-(void)GetCurrentLocation;
- (IBAction)RefreshWeather:(id)sender;

@end

