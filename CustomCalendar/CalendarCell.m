//
//  CalendarCell.m
//  CustomCalendar
//
//  Created by Susmita Horrow on 31/01/16.
//  Copyright © 2016 Ashutosh. All rights reserved.
//

#import "CalendarCell.h"

@implementation CalendarCell

- (void)prepareForReuse {
	[super prepareForReuse];
	self.dateLabel.text = @"";
	self.imageView.image = nil;
}

+ (NSString *)reuseIdentifier {
	return @"CalendarCell";
}

@end
