//
//  ViewController.m
//  CustomCalendar
//
//  Created by Susmita Horrow on 31/01/16.
//  Copyright © 2016 Ashutosh. All rights reserved.
//

#import "ViewController.h"
#import "CalendarView.h"

@interface ViewController ()

@property (nonatomic, strong) CalendarView *calendarView;
@property (weak, nonatomic) IBOutlet UIButton *checkinButton;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.calendarView = [CalendarView calendarView];
	[self.view addSubview:self.calendarView];
	self.calendarView.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
	[self.calendarView configureForMonth:13];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)handleCheckout:(id)sender {
	self.checkinButton.tintColor = [UIColor blueColor];
	self.checkoutButton.tintColor = [UIColor redColor];
	[self.calendarView setDateSelectionMode:SelectEnd];
}

- (IBAction)handleCheckin:(id)sender {
	self.checkinButton.tintColor = [UIColor redColor];
	self.checkoutButton.tintColor = [UIColor blueColor];
	[self.calendarView setDateSelectionMode:SelectStart];
}

@end
