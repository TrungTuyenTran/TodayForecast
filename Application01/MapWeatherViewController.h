//
//  MapWeatherViewController.h
//  Application01
//
//  Created by Tran Trung Tuyen on 11/7/16.
//  Copyright (c) 2016 Tran Trung Tuyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WeatherInfo.h"

@interface MapWeatherViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewResult;
@property (weak, nonatomic) IBOutlet UIView *viewResult;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatusWeather;
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) WeatherInfo* weatherInfo;
@property (nonatomic, strong) UIActivityIndicatorView* loadingSpinner;

@end
