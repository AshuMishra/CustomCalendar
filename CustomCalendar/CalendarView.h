//
//  CalendarView.h
//  CustomCalendar
//
//  Created by Susmita Horrow on 31/01/16.
//  Copyright © 2016 Ashutosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarView : UIView {
	
}

+ (CalendarView *)calendarView;
- (void)configureForMonth:(NSInteger)numberOfMonth;

@end
