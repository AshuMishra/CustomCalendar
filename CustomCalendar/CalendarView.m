//
//  CalendarView.m
//  CustomCalendar
//
//  Created by Susmita Horrow on 31/01/16.
//  Copyright © 2016 Ashutosh. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarCell.h"
#import "CalendarHeaderView.h"

@interface CalendarView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger numberOfMonth;
@property (strong, nonatomic) NSArray *monthNameArray;
@property (strong, nonatomic) NSArray *startingDays;
@property (strong, nonatomic) NSArray *monthlyDateCount;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@end

@implementation CalendarView

- (void)awakeFromNib {
	[super awakeFromNib];
	[self.collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:CalendarCell.reuseIdentifier];
	UINib *nib = [UINib nibWithNibName:@"CalendarCell" bundle: [NSBundle mainBundle]];
	UINib *headerNib = [UINib nibWithNibName:@"CalendarHeaderView" bundle: [NSBundle mainBundle]];
	[self.collectionView registerNib:nib forCellWithReuseIdentifier:CalendarCell.reuseIdentifier];
	[self.collectionView registerClass:[CalendarHeaderView class]
			forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
				   withReuseIdentifier:CalendarHeaderView.reuseIdentifier];
	[self.collectionView registerNib:headerNib
		  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
		  		 withReuseIdentifier:CalendarHeaderView.reuseIdentifier];
}

+ (CalendarView *)calendarView {
	return [[[NSBundle mainBundle]loadNibNamed:@"CalendarView" owner:self options:nil] firstObject];
}

- (void)configureForMonth:(NSInteger)numberOfMonth {
	self.numberOfMonth = numberOfMonth;
	[self configureMonthNames];
	[self configureStartDays];
	[self configureMonthlyDayCount];
	self.collectionView.allowsMultipleSelection = YES;
	[self.collectionView reloadData];
}

- (void)configureStartDays {
	NSMutableArray *startingArray = [NSMutableArray array];
	NSDate *currentDate = [NSDate date];
	for (int i = 0 ; i < self.numberOfMonth; i++) {
		[startingArray addObject:[self firstDayOfMonth:currentDate]];
		NSDate *firstDate = [self firstDateOfMonth:currentDate];
		currentDate = [NSDate dateWithTimeInterval: 60 * 60 * 24 * [[self getNumberOfDaysInMonthForDate:firstDate] integerValue] sinceDate:firstDate];
	}
	self.startingDays = startingArray;
}

- (void)configureMonthlyDayCount {
	NSMutableArray *daysArray = [NSMutableArray array];
	NSDate *currentDate = [NSDate date];
	for (int i = 0 ; i < self.numberOfMonth; i++) {
		[daysArray addObject:[self getNumberOfDaysInMonthForDate:currentDate]];
		NSDate *firstDate = [self firstDateOfMonth:currentDate];
		currentDate = [NSDate dateWithTimeInterval: 60 * 60 * 24 * [[self getNumberOfDaysInMonthForDate:firstDate] integerValue] sinceDate:firstDate];
	}
	self.monthlyDateCount = daysArray;
}

- (NSNumber *)getNumberOfDaysInMonthForDate:(NSDate *)date {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
	NSUInteger numberOfDaysInMonth = range.length;
	return  [NSNumber numberWithInteger:numberOfDaysInMonth];
}

- (NSNumber *)firstDayOfMonth: (NSDate *)date  {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date];
	components.day = 1;
	NSDate *firstDayOfMonth = [gregorian dateFromComponents:components];
	components = [gregorian components: NSWeekdayCalendarUnit fromDate: firstDayOfMonth];
	NSUInteger weekdayIndex = [components weekday];
	return [NSNumber numberWithInteger:weekdayIndex];
}

- (NSDate *)firstDateOfMonth: (NSDate *)date {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date];
	components.day = 1;
	return [gregorian dateFromComponents:components];
}

- (void)configureMonthNames {
	NSDateComponents *yearComponents  = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth  fromDate:[NSDate date]];
	int currentYear  = [yearComponents year];
	int currentmonth = [yearComponents month];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	NSMutableArray *monthNames = [NSMutableArray array];

	for(int months = currentmonth; months <= self.numberOfMonth; months++) {
		NSString *name = [NSString stringWithFormat:@"%@ %i",[[dateFormatter monthSymbols]objectAtIndex: months - 1],currentYear];
		[monthNames addObject:name];
	}
	self.monthNameArray = monthNames;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSInteger startIndex = [[self.startingDays objectAtIndex:section] integerValue];
	NSInteger totalDays = [[self.monthlyDateCount objectAtIndex:section] integerValue];
	return (totalDays + startIndex-1);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return self.numberOfMonth;
}

- (NSInteger)currentDateIndex {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:[NSDate date]];
	return components.day;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CalendarCell.reuseIdentifier forIndexPath:indexPath];
	NSInteger startIndex = [[self.startingDays objectAtIndex:indexPath.section] integerValue];
	NSInteger dateIndex = indexPath.row - (startIndex - 1);
	if (indexPath.row >= startIndex - 1 && dateIndex < [self.monthlyDateCount[indexPath.section] integerValue]) {
		cell.dateLabel.text = [NSString stringWithFormat:@"%lu",(long)dateIndex + 1];
		BOOL isOlderDate = (dateIndex + 1 < [self currentDateIndex]) && (indexPath.section == 0);
		cell.userInteractionEnabled = !isOlderDate;
		if ((dateIndex + startIndex - 1) % 7 == 0) {
			cell.dateLabel.textColor = isOlderDate ? [UIColor grayColor] : [UIColor redColor];
		} else {
			cell.dateLabel.textColor = isOlderDate ? [UIColor grayColor] : [UIColor blackColor];
		}
	} else {
		cell.dateLabel.text = @"";
	}

	return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	CalendarHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CalendarHeaderView.reuseIdentifier forIndexPath:indexPath];
	view.monthNameLabel.text = [self.monthNameArray objectAtIndex:indexPath.section];
	return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	return CGSizeMake(CGRectGetWidth(collectionView.frame), 80);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(CGRectGetWidth(collectionView.frame) / 7.0, CGRectGetWidth(collectionView.frame)/7.0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 0.0;
}

- (NSDate *)dateForDateIndex:(NSInteger)dateIndex monthIndex:(NSInteger)monthIndex {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:[NSDate date]];

	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay: dateIndex];
	[comps setMonth:monthIndex];
	[comps setYear:components.year];
	return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	CalendarCell *cell = (CalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
	NSDate *selectedDate = [self dateForDateIndex:[cell.dateLabel.text integerValue] monthIndex:indexPath.section];

	if (self.startDate == nil) {
		self.startDate = selectedDate;
	}else if (self.endDate == nil) {
		self.endDate = selectedDate;
	}
	cell.imageView.image = [selectedDate isEqual:self.startDate] ? [UIImage imageNamed:@"Right"] : [UIImage imageNamed:@"Left"];

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	CalendarCell *cell = (CalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
	NSDate *selectedDate = [self dateForDateIndex:[cell.dateLabel.text integerValue] monthIndex:indexPath.section];
	if ([selectedDate isEqual:self.startDate]) {
		self.startDate = nil;
	}else if ([selectedDate isEqual:self.endDate]) {
		self.endDate = nil;
	}
	cell.imageView.image = nil;
}

@end