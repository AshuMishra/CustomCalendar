//
//  CalendarCell.h
//  CustomCalendar
//
//  Created by Susmita Horrow on 31/01/16.
//  Copyright © 2016 Ashutosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

+ (NSString *)reuseIdentifier;

@end
