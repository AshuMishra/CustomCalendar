//
//  ViewController.m
//  CustomCalendar
//
//  Created by Susmita Horrow on 31/01/16.
//  Copyright © 2016 Ashutosh. All rights reserved.
//

#import "ViewController.h"
#import "CalendarView.h"

@interface ViewController ()<CalendarViewProtocol>

@property (nonatomic, strong) CalendarView *calendarView;
@property (weak, nonatomic) IBOutlet UIButton *checkinButton;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
@property (weak, nonatomic) IBOutlet UILabel *checkoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkinLabel;
@property (strong, nonatomic) NSDateFormatter *dateformatter;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.calendarView = [CalendarView calendarView];
	[self.view addSubview:self.calendarView];
	self.calendarView.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 300);
	[self.calendarView configureForMonth: 8];
	self.calendarView.delegate = self;
	self.dateformatter = [[NSDateFormatter alloc]init];
	self.dateformatter.dateFormat = @"dd-MM-yyyy";

	[self handleCheckin:nil];
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

- (void)calendarView:(CalendarView *)calendarView didSelectStartDate:(NSDate *)startDate {
	self.checkinLabel.text = [self.dateformatter stringFromDate:startDate];
}

- (void)calendarView:(CalendarView *)calendarView didSelectEndDate:(NSDate *)endDate {
	self.checkoutLabel.text = [self.dateformatter stringFromDate:endDate];
}

@end
