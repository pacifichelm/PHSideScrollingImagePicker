//
//  PHViewController.m
//  Side Scroller
//
//  Created by Patrick B. Gibson on 9/16/13.
//  Copyright (c) 2013 Pacific Helm. All rights reserved.
//

#import "PHViewController.h"

@interface PHViewController ()

@end

@implementation PHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSArray *images = @[[UIImage imageNamed:@"1.jpg"],
                        [UIImage imageNamed:@"2.jpg"],
                        [UIImage imageNamed:@"3.jpg"],
                        [UIImage imageNamed:@"4.jpg"],
                        [UIImage imageNamed:@"5.jpg"]];
    
    [self.imagePicker setImages:images];
}

- (IBAction)selectPressed:(id)sender {
    NSString *pressedText = [NSString stringWithFormat:@"Selected: %@", [self.imagePicker.selectedImageIndexes componentsJoinedByString:@", "]
                             ];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:pressedText
                                                       delegate:nil
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
