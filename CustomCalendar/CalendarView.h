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

@interface CalendarView : UIView

+ (CalendarView *)calendarView;
- (void)configureForMonth:(NSInteger)numberOfMonth;
- (NSDate *)startDate;
- (NSDate *)endDate;
- (void)setDateSelectionMode:(DateSelectionMode) mode;

@end
