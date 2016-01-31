//
//  CalendarHeaderView.h
//  CustomCalendar
//
//  Created by Susmita Horrow on 31/01/16.
//  Copyright © 2016 Ashutosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarHeaderView : UICollectionReusableView {
	
}
@property (weak, nonatomic) IBOutlet UILabel *monthNameLabel;

+ (NSString *)reuseIdentifier;

@end
