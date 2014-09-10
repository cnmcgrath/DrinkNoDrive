//
//  DNDParseDownloadController.m
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/5/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//

#import "DNDParseDownloadController.h"

@implementation DNDParseDownloadController

- (void)downloadAllDrinksCompletionBlock:(void (^)(NSArray *drinks, NSError *err))block;
{
    //Check to see if we already downloaded the conference rooms
    PFQuery *query = [PFQuery queryWithClassName:@"DrinkMenu"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            block(objects,error);
        }else{
            NSLog(@"Error %@",error);
        }
    }];
}

- (void)calculateBACOfCurrentUser:(void (^)(float BAC, NSError *err))block
{
    PFQuery *query = [PFQuery queryWithClassName:@"DrinkHistory"];
    [query whereKey:@"Customer" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [[PFUser query] getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            //start calulating BAC
            if ([objects count] != 0) {
                float weight = [object[@"Weight_Pounds"] floatValue];
                float gender = [object[@"gender"] floatValue];
                float newBAC = (((0.6*[objects count])*5.14)/((weight)*(gender)))-(.015 * (1));
                block(newBAC,nil);
            }else{
                block(0.0,nil);
            }
            
        }];
    }];
}

-(void)getUberInformationWith:(NSString*)home :(NSString*)Longititude :(NSString*)Latitude :(void(^)(NSString *uber_time, NSString*uber_price, NSError *err))block
{
    __block NSString *u_time;
    __block NSString *homeLatitude;
    __block NSString *homeLongitude;
    
    //Get time estimate
    NSString *timeURLString = [NSString stringWithFormat:@"https://api.uber.com/v1/estimates/time?start_latitude=%@&start_longitude=%@&server_token=V204K_Ay61XAWnJ98iDNMGVAZDg2fIM553e0qBeD",Latitude,Longititude];
    NSURL *timeURL = [NSURL URLWithString:timeURLString];
    NSURLRequest *request =[NSURLRequest requestWithURL:timeURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if ([json objectForKey:@"times"] == nil) {
            u_time = @"uberX N/A";
        }else{
            NSString *time = [NSString stringWithFormat:@"%@",[json objectForKey:@"times"]];
            u_time = [NSString stringWithFormat:@"%d minute(s)",[time intValue]/60];
        }
    }];
    
    //GeoCode address and get price
    
    CLGeocoder *homeGeoCode = [[CLGeocoder alloc] init];
    [homeGeoCode geocodeAddressString:home completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        homeLatitude = [NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude];
        homeLongitude = [NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude];
        
        NSString *urlString = [NSString stringWithFormat:@"https://api.uber.com/v1/estimates/price?server_token=V204K_Ay61XAWnJ98iDNMGVAZDg2fIM553e0qBeD&start_longitude=%@&start_latitude=%@&end_longitude=%@&end_latitude=%@",Longititude,Latitude,homeLongitude,homeLatitude];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString *cost = [[[json objectForKey:@"prices"] objectAtIndex:0] objectForKey:@"estimate"];
            block(u_time,cost,nil);
        }];
        
    }];
}
@end
