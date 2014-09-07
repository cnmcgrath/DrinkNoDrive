//
//  DNDSecondViewController.m
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/5/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//

#import "DNDUberViewController.h"

#import "UIColor+DNDColor.h"


@interface DNDUberViewController ()<NSURLConnectionDelegate>
{
    NSString*homeLatitude;
    NSString*homeLongitude;
}

@property (nonatomic, strong)CLLocationManager *locationManager;

@end

@implementation DNDUberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor appBackground];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    homeLatitude = @"";
    homeLongitude = @"";
    
    
    //Get user's home location
    [[PFUser query] getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        _homeLocationLabel.text = object[@"HomeAddress"];
    }];
    
    //Get user's current location and revrese that shit.
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    CLGeocoder *locationGeocoded = [[CLGeocoder alloc] init];
    [locationGeocoded reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        if (!placemark){
            NSLog(@"%@",error);
        }else{
//            NSLog(@"%@",placemark.addressDictionary);
            NSString *street = [placemark.addressDictionary objectForKey:@"Street"];
            NSString *state = [placemark.addressDictionary objectForKey:@"State"];
            NSString *city = [placemark.addressDictionary objectForKey:@"City"];
            NSString *zipCode = [placemark.addressDictionary objectForKey:@"ZIP"];
            
            _currentLocationLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",street,city,state,zipCode];
            [self getUberInformation];
            [self.locationManager stopUpdatingLocation];
        }
    }];
    
}

- (void)getUberInformation{
    NSString*currentLatitude = [NSString stringWithFormat:@"%f",[self.locationManager location].coordinate.latitude];
    NSString*currentLongititude = [NSString stringWithFormat:@"%f",[self.locationManager location].coordinate.longitude];


    //Get time estimate
    NSString *timeURLString = [NSString stringWithFormat:@"https://api.uber.com/v1/estimates/time?start_latitude=%@&start_longitude=%@&server_token=V204K_Ay61XAWnJ98iDNMGVAZDg2fIM553e0qBeD",currentLatitude,currentLongititude];
    NSURL *timeURL = [NSURL URLWithString:timeURLString];
    NSURLRequest *request =[NSURLRequest requestWithURL:timeURL];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                               if ([json objectForKey:@"times"] == nil) {
                                   _waitLabel.text = @"uberX N/A";
                               }else{
                                   NSString *time = [NSString stringWithFormat:@"%@",[json objectForKey:@"times"]];
                                   _waitLabel.text = [NSString stringWithFormat:@"%d minute(s)",[time intValue]/60];
                               }
                           }];
    
    //GeoCode address and get price
    
    CLGeocoder *homeGeoCode = [[CLGeocoder alloc] init];
    [homeGeoCode geocodeAddressString:_homeLocationLabel.text completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        homeLatitude = [NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude];
        homeLongitude = [NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude];
        
        NSString *urlString = [NSString stringWithFormat:@"https://api.uber.com/v1/estimates/price?server_token=V204K_Ay61XAWnJ98iDNMGVAZDg2fIM553e0qBeD&start_longitude=%@&start_latitude=%@&end_longitude=%@&end_latitude=%@",currentLongititude,currentLatitude,homeLongitude,homeLatitude];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                   NSString *cost = [[[json objectForKey:@"prices"] objectAtIndex:0] objectForKey:@"estimate"];
                                   _priceLabel.text = cost;
                               }];

    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openUberApp:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uber://"]]) {
        // Do something awesome - the app is installed! Launch App.
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"uber://?action=setPickup&pickup=my_location"]];
    }
    else {
        // No Uber app! Open Mobile Website.
    }
}
@end
