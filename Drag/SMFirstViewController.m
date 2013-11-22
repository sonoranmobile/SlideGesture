//
//  SMFirstViewController.m
//  Drag
//
//  Created by Michael Morris on 11/19/13.
//  Copyright (c) 2013 Michael Morris. All rights reserved.
//

#import "SMFirstViewController.h"
#import "SMSlideGestureRecognizer.h"

@import MapKit;

@interface SMFirstViewController ()
@property (weak, nonatomic) IBOutlet UILabel *firstViewLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation SMFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	SMSlideGestureRecognizer* recog =[[SMSlideGestureRecognizer alloc] initWithTarget:self
																			   action:@selector(accessoryButtonTouched:)];
	[self.view addGestureRecognizer:recog];
	
	recog =[[SMSlideGestureRecognizer alloc] initWithTarget:self
													 action:@selector(accessoryButtonTouched:)];
	[self.button addGestureRecognizer:recog];
}

-(void)accessoryButtonTouched:(SMSlideGestureRecognizer*)sender {
	if(sender.state == UIGestureRecognizerStateEnded) {
			NSInteger buttonIndex = sender.selectedButtonIndex;
			NSLog(@"accessoryButtonTouched  button %d", buttonIndex);
		NSString* buttonLabel = [sender buttonLabelForIndex:buttonIndex];
		NSString* message = [NSString stringWithFormat:@"Accessory button with label %@ was touched", buttonLabel];
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Accessory Button Touched"
														message:message
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
	}
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)mainViewButton:(id)sender {
	NSLog(@"mainViewButton");
}

- (IBAction)tap:(id)sender {
	NSLog(@"tap");
}
@end
