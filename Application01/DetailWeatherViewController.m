//
//  DetailWeatherViewController.m
//  Application01
//
//  Created by Tran Trung Tuyen on 11/10/16.
//  Copyright (c) 2016 Tran Trung Tuyen. All rights reserved.
//

#import "DetailWeatherViewController.h"
#import "OtherWeatherTableViewCell.h"
#import "APIEngine.h"

@interface DetailWeatherViewController ()


@end

@implementation DetailWeatherViewController

@synthesize weather;

- (void)viewDidLoad {
    [self.tableDetailView registerClass:OtherWeatherTableViewCell.self forCellReuseIdentifier:@"OtherWeatherTableViewCell"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self SetDataView:self.weather];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* WeatherIcon[] = {@"Humidity-icon.png",@"pressure-xxl.png",@"low_temperature-512.png",@"max-temperature-icon-png-19.png"};
    NSString* WeatherLabel[] = {@"Humidity",@"Pressure",@"Min Temp.",@"Max Temp."};
    OtherWeatherTableViewCell* cell = (OtherWeatherTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"OtherWeatherTableViewCell"];
    if (cell != nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OtherWeatherTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.Icon.image = [UIImage imageNamed: WeatherIcon[indexPath.row]];
    cell.lblName.text = [NSString stringWithFormat:@"%@",WeatherLabel[indexPath.row]];
    switch(indexPath.row){
        case 0:
            cell.lblValue.text = self.weather.humidity;
            break;
        case 1:
            cell.lblValue.text = self.weather.pressure;
            break;
        case 2:
            cell.lblValue.text = self.weather.mintemp;
            break;
        case 3:
            cell.lblValue.text = self.weather.maxtemp;
            break;
        default:
            cell.lblValue.text = @"";
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

- (IBAction)BackToPrevScreen:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)SetDataView:(WeatherInfo*) _weatherInfo{
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: _weatherInfo.urlImage]];
    self.imgIconWeather.image = [UIImage imageWithData:imageData];
    self.lblTemperature.text = _weatherInfo.temperature;
    APIEngine* enginer =[[APIEngine alloc] init];
    [enginer getAddressFromLatLon:[self.weather.latitude doubleValue] withLongitude:[self.weather.longitude doubleValue] completion:^(BOOL isSuccess){
        if(isSuccess){
            self.lblAddress.text =[NSString stringWithFormat:@"%@,%@",enginer.location.locality,enginer.location.country];
        }
    }];
    [self.tableDetailView reloadData];
}
@end
