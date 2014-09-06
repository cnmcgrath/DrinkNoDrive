//
//  UIColor+DNDColor.m
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/5/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//

#import "UIColor+DNDColor.h"

@implementation UIColor (DNDColor)

+ (UIColor *) redBackground {
    UIColor *red = [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5f];
    return red;
}

+ (UIColor *) appBackground {
    UIColor *red = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    return red;
}

@end
