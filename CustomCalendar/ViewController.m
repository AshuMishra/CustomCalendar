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

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.calendarView = [CalendarView calendarView];
	[self.view addSubview:self.calendarView];
	self.calendarView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
	[self.calendarView configureForMonth:13];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
