//
//  DNDSecondViewController.m
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/5/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//

#import "DNDUberViewController.h"
#import "DNDParseDownloadController.h"

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
    
    self.downloader = [[DNDParseDownloadController alloc] init];
    
    //Get user's current location and revrese that shit.
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Failed to Get Your Location"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
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
            NSString *street = [placemark.addressDictionary objectForKey:@"Street"];
            NSString *state = [placemark.addressDictionary objectForKey:@"State"];
            NSString *city = [placemark.addressDictionary objectForKey:@"City"];
            NSString *zipCode = [placemark.addressDictionary objectForKey:@"ZIP"];
            _currentLocationLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",street,city,state,zipCode];
            [self.downloader getUberInformationWith:_homeLocationLabel.text:[NSString stringWithFormat:@"%f",[self.locationManager location].coordinate.longitude]:[NSString stringWithFormat:@"%f",[self.locationManager location].coordinate.latitude] :^(NSString *u_time, NSString *u_price, NSError *err) {
                if (!err) {
                    _priceLabel.text = u_price;
                    _waitLabel.text = u_time;
                }else{
                    NSLog(@"%@",[error userInfo]);
                }
            }];
            
            [self.locationManager stopUpdatingLocation];
        }
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
