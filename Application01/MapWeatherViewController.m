//
//  MapWeatherViewController.m
//  Application01
//
//  Created by Tran Trung Tuyen on 11/7/16.
//  Copyright (c) 2016 Tran Trung Tuyen. All rights reserved.
//

#import "MapWeatherViewController.h"
#import "SWRevealViewController.h"
#import "StaticVariables.h"
#import "APIEngine.h"
#import "ViewController.h"
#import "Annotation.h"
#import "DetailWeatherViewController.h"

@interface MapWeatherViewController ()<MKMapViewDelegate>

@property (nonatomic, assign) MKCoordinateRegion boundingRegion;

@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D userCoordinate;

@end

@implementation MapWeatherViewController

@synthesize weatherInfo = _weatherInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.locationManager = [[CLLocationManager alloc] init];
    [self SetInitialForMapView];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellAddress" forIndexPath:indexPath];
    
    MKMapItem *mapItem = [self.places objectAtIndex:indexPath.row];
    cell.textLabel.text = mapItem.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MKMapItem *mapItem = [self.places objectAtIndex:indexPath.row];
    NSString *Lat = [NSString stringWithFormat:@"%f",mapItem.placemark.coordinate.latitude];
    NSString *Long = [NSString stringWithFormat:@"%f",mapItem.placemark.coordinate.longitude];
    APIEngine* enginer =[[APIEngine alloc] init];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    [enginer GetWeatherByLocation:Lat :Long completion:^(BOOL isDone){
        if(isDone){
            [self SetWeatherInfoOfItem:[enginer getWeatherResult]];
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = mapItem.placemark.location.coordinate;
            annotation.title = [NSString stringWithFormat:@"%@",mapItem.name];
            annotation.subtitle = [NSString stringWithFormat:@"%@ - %@",self.weatherInfo.mintemp, self.weatherInfo.maxtemp];
            NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.weatherInfo.urlImage]];
            self.imgStatusWeather.image = [UIImage imageWithData:imageData];
            [self.MapView removeAnnotations: self.MapView.annotations];
            [self.MapView addAnnotation:annotation];
            [self.viewResult setHidden:YES];
            [self SetCenterForMapView:Lat :Long];
            [spinner stopAnimating];
        }
    }];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    self.viewResult.alpha = 0;
    [self.viewResult setHidden:NO];
    [UIView animateWithDuration:0.35 animations:^{
        self.viewResult.alpha = 1;
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.viewResult.alpha = 1;
    [UIView animateWithDuration:0.35 animations:^{
        self.viewResult.alpha = 0;
    }];
    [self.viewResult setHidden:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    // If the text changed, reset the tableview if it wasn't empty.
    if (self.places.count != 0) {
        
        // Set the list of places to be empty.
        self.places = @[];
        // Reload the tableview.
        [self.tableViewResult reloadData];
    }
}

- (void)startSearch:(NSString *)searchString {
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    
    // Confine the map search area to the user's current location.
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.userCoordinate.latitude;
    newRegion.center.longitude = self.userCoordinate.longitude;
    
    // Setup the area spanned by the map region:
    // We use the delta values to indicate the desired zoom level of the map,
    //      (smaller delta values corresponding to a higher zoom level).
    //      The numbers used here correspond to a roughly 8 mi
    //      diameter area.
    //
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchString;
    request.region = newRegion;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error) {
        if (error != nil) {
            NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
                                                            message:errorStr
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            self.places = [response mapItems];
            
            // Used for later when setting the map's region in "prepareForSegue".
            self.boundingRegion = response.boundingRegion;
            
            [self.tableViewResult reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    
    if (self.localSearch != nil) {
        self.localSearch = nil;
    }
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.localSearch startWithCompletionHandler:completionHandler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    // Check if location services are available
    if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"%s: location services are not available.", __PRETTY_FUNCTION__);
        
        // Display alert to the user.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location services"
                                                                       message:@"Location services are not enabled on this device. Please enable location services in settings."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}]; // Do nothing action to dismiss the alert.
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    // Request "when in use" location service authorization.
    // If authorization has been denied previously, we can display an alert if the user has denied location services previously.
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"%s: location services authorization was previously denied by the user.", __PRETTY_FUNCTION__);
        
        // Display alert to the user.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location services"
                                                                       message:@"Location services were previously denied by the user. Please enable location services for this app in settings."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}]; // Do nothing action to dismiss the alert.
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    // Start updating locations.
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    // When a location is delivered to the location manager delegate, the search will actually take place. See the -locationManager:didUpdateLocations: method.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    // Remember for later the user's current location.
    CLLocation *userLocation = locations.lastObject;
    self.userCoordinate = userLocation.coordinate;
    
    [manager stopUpdatingLocation]; // We only want one update.
    
    manager.delegate = nil;         // We might be called again here, even though we
    // called "stopUpdatingLocation", so remove us as the delegate to be sure.
    
    // We have a location now, so start the search.
    [self startSearch:self.searchBar.text];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // report any errors returned back from Location Services
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    NSLog(@"Failed to load the map: %@", error);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
    annotationView.pinColor = MKPinAnnotationColorGreen;
    
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.weatherInfo.urlImage]];
    UIImageView *iconWeather = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
    UIButton* advertButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [advertButton addTarget:self action:@selector(calloutTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    annotationView.leftCalloutAccessoryView = iconWeather;
    annotationView.rightCalloutAccessoryView = advertButton;
    annotationView.canShowCallout = YES;
    return annotationView;
}

-(void) SetInitialForMapView{
    CLLocationCoordinate2D location;
    StaticVariables *globalVariables = [StaticVariables sharedInstance];
    if(![globalVariables.CurrentUserLatitude isEqualToString:@""]  && ![globalVariables.CurrentUserLongitude isEqualToString:@""]){
        location = CLLocationCoordinate2DMake([globalVariables.CurrentUserLatitude doubleValue], [globalVariables.CurrentUserLongitude doubleValue]);
    }
    else{
        location = CLLocationCoordinate2DMake(0, 0);
    }
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.005;
    span.longitudeDelta=0.005;
    region.span=span;
    region.center = location;
    [self.MapView setRegion:region animated:TRUE];
    [self.MapView regionThatFits:region];
}

-(void) SetCenterForMapView:(NSString*)Lat :(NSString*)Long{
    CLLocationCoordinate2D location;
    location = CLLocationCoordinate2DMake([Lat doubleValue], [Long doubleValue]);
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.005;
    span.longitudeDelta=0.005;
    region.span=span;
    region.center = location;
    [self.MapView setRegion:region animated:TRUE];
    [self.MapView regionThatFits:region];
}

-(void) SetWeatherInfoOfItem:(WeatherInfo*)weatherInfo{
    //self.weatherInfo = [[WeatherInfo alloc] init];
    self.weatherInfo = weatherInfo;
}

-(void) calloutTapped:(id) sender {
    
    DetailWeatherViewController *detailWeatherView = [[DetailWeatherViewController alloc] initWithNibName:nil bundle:nil];
    detailWeatherView.weather = self.weatherInfo;
    [self.navigationController pushViewController:detailWeatherView animated:YES];  
}

@end
