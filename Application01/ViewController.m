//
//  ViewController.m
//  Application01
//
//  Created by Tran Trung Tuyen on 11/2/16.
//  Copyright (c) 2016 Tran Trung Tuyen. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "StaticVariables.h"

@interface ViewController ()

@end

@implementation ViewController

// Variables
NSString* LatCurrent;
NSString* LongCurrent;
@synthesize customCell = _customCell;
NSString* WeatherIcon[] = {@"Humidity-icon.png",@"pressure-xxl.png",@"low_temperature-512.png",@"max-temperature-icon-png-19.png"};
NSString* WeatherLabel[] = {@"Humidity",@"Pressure",@"Min Temp.",@"Max Temp."};
APIEngine *enginer;

// Event
- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    [self GetCurrentLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location's Weather" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        LatCurrent = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        LongCurrent = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        StaticVariables* globalVariables = [StaticVariables sharedInstance];
        globalVariables.CurrentUserLatitude = LatCurrent;
        globalVariables.CurrentUserLongitude = LongCurrent;
    }
    NSLog(@"Resolving the Address");
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks");
        CLPlacemark *placemark;
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            self.lblCurrentLocation.text = [NSString stringWithFormat:@"%@, %@",
                                 placemark.administrativeArea,
                                 placemark.ISOcountryCode];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    enginer = [[APIEngine alloc] init];
    [self.locationManager stopUpdatingLocation];
    [enginer GetWeatherByLocation:LatCurrent :LongCurrent completion:^(BOOL isDone){
        if(isDone){
            [self SetDataView:[enginer getWeatherResult]];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"OtherWeatherTableViewCell";
    
    OtherWeatherTableViewCell *cell = (OtherWeatherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OtherWeatherTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.Icon.image = [UIImage imageNamed: WeatherIcon[indexPath.row]];
    cell.lblName.text = [NSString stringWithFormat:@"%@",WeatherLabel[indexPath.row]];
    if(enginer != nil){
        switch(indexPath.row){
            case 0:
                cell.lblValue.text = [enginer getWeatherResult].humidity;
                break;
            case 1:
                cell.lblValue.text = [enginer getWeatherResult].pressure;
                break;
            case 2:
                cell.lblValue.text = [enginer getWeatherResult].mintemp;
                break;
            case 3:
                cell.lblValue.text = [enginer getWeatherResult].maxtemp;
                break;
            default:
                cell.lblValue.text = @"";
                break;
        }
    }
    else
    {
        cell.lblValue.text = @"";
    }
    return cell;
}

- (IBAction)RefreshWeather:(id)sender {
    enginer = nil;
    self.locationManager = nil;
    [self GetCurrentLocation];
}

-(void)GetCurrentLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=kCLDistanceFilterNone;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

-(void)SetDataView:(WeatherInfo*) _weatherInfo{
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: _weatherInfo.urlImage]];
    self.imgCurrentWeather.image = [UIImage imageWithData:imageData];
    self.lblCurrentTemp.text = _weatherInfo.temperature;
    [self.tableOtherWeatherIndex reloadData];
}

@end
