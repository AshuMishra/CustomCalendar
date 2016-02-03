//
//  CalendarView.h
//  CustomCalendar
//
//  Created by Susmita Horrow on 31/01/16.
//  Copyright © 2016 Ashutosh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DateSelectionMode)  {
	SelectStart = 0, SelectEnd
};

@protocol CalendarViewProtocol;

@interface CalendarView : UIView

@property (nonatomic, weak) NSObject<CalendarViewProtocol> *delegate;

+ (CalendarView *)calendarView;
- (void)configureForMonth:(NSInteger)numberOfMonth;
- (NSDate *)startDate;
- (NSDate *)endDate;
- (void)setDateSelectionMode:(DateSelectionMode) mode;

@end

@protocol CalendarViewProtocol

- (void)calendarView:(CalendarView *)calendarView didSelectStartDate:(NSDate *)startDate;
- (void)calendarView:(CalendarView *)calendarView didSelectEndDate:(NSDate *)endDate;

@end
