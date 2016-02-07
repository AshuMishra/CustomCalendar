//
//  CalendarView.m
//  CustomCalendar
//
//  Created by Susmita Horrow on 31/01/16.
//  Copyright © 2016 Ashutosh. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarCell.h"
#import "FullyHorizontalFlowLayout.h"

@interface CalendarView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger numberOfMonth;
@property (assign, nonatomic) DateSelectionMode selectionMode;
@property (strong, nonatomic) NSMutableArray *monthsArray;
@property (strong, nonatomic) NSMutableArray *yearsArray;
@property (strong, nonatomic) NSArray *startingDays;
@property (strong, nonatomic) NSArray *monthlyDateCount;

@property (strong, nonatomic) NSIndexPath *startDateIndexPath;
@property (strong, nonatomic) NSIndexPath *endDateIndexPath;

@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *monthNameLabel;
@property (strong, nonatomic) FullyHorizontalFlowLayout *flowLayout;

@end

@implementation CalendarView

#pragma mark - View Life cycle methods

- (void)awakeFromNib {
	[super awakeFromNib];
	[self.collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:CalendarCell.reuseIdentifier];
	UINib *nib = [UINib nibWithNibName:@"CalendarCell" bundle: [NSBundle mainBundle]];
	[self.collectionView registerNib:nib forCellWithReuseIdentifier:CalendarCell.reuseIdentifier];
	self.flowLayout = [[FullyHorizontalFlowLayout alloc] init];
	[self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
	self.collectionView.collectionViewLayout = self.flowLayout;
}

#pragma mark - Public methods

+ (CalendarView *)calendarView {
	return [[[NSBundle mainBundle]loadNibNamed:@"CalendarView" owner:self options:nil] firstObject];
}

- (void)configureForMonth:(NSInteger)numberOfMonth {
	self.numberOfMonth = numberOfMonth;
	[self configureDatasource];
	[self configureStartDays];
	[self configureMonthlyDayCount];
	self.collectionView.allowsMultipleSelection = NO;
	[self.collectionView reloadData];
	[self configureHeaderView:[self currentSection]];
}

- (NSDate *)startDate {
	return [self dateForIndexPath:self.startDateIndexPath];
}

- (NSDate *)endDate {
	return [self dateForIndexPath:self.endDateIndexPath];
}

- (void)setDateSelectionMode:(DateSelectionMode) mode {
	self.selectionMode = mode;
}

#pragma mark - Private methods

- (NSDateFormatter *)dateFormatter {
	static NSDateFormatter *formatter;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		formatter = [[NSDateFormatter alloc]init];
	});
	return formatter;
}

- (void)configureDatasource {
	NSDateComponents *yearComponents  = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth  fromDate:[NSDate date]];
	int currentYear  = (int)[yearComponents year];
	int currentmonth = (int)[yearComponents month];
	self.monthsArray = [NSMutableArray array];
	self.yearsArray = [NSMutableArray array];
	for(int month = currentmonth; month <= self.numberOfMonth + 1; month++) {
		currentmonth = (month - 1) % 12;
		[self.monthsArray addObject:[NSNumber numberWithInt:currentmonth]];
		if (currentmonth == 0) {
			currentYear ++;
		}
		[self.yearsArray addObject:[NSNumber numberWithInt:currentYear]];
	}
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

- (NSInteger)currentDateIndex {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:[NSDate date]];
	return components.day;
}

- (BOOL)isSunday:(NSIndexPath*)indexPath {
	NSInteger startIndex = [[self.startingDays objectAtIndex:indexPath.section] integerValue];
	NSInteger dateIndex = indexPath.row - (startIndex - 1);
	return (dateIndex + startIndex - 1) % 7 == 0;
}

- (BOOL)isOlderDate:(NSIndexPath*)indexPath {
	NSInteger startIndex = [[self.startingDays objectAtIndex:indexPath.section] integerValue];
	NSInteger dateIndex = indexPath.row - (startIndex - 1);
	return (dateIndex + 1 < [self currentDateIndex]) && (indexPath.section == 0);
}

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath {
	NSInteger startIndex = [[self.startingDays objectAtIndex:indexPath.section] integerValue];
	NSInteger dateIndex = indexPath.row - (startIndex - 1) + 1;

	NSInteger monthIndex = [self.monthsArray[indexPath.section] integerValue] + 1;
	NSInteger yearIndex = [self.yearsArray[indexPath.section] integerValue];
	return [self dateForDateIndex:dateIndex monthIndex:monthIndex yearIndex:yearIndex];
}

- (NSDate *)dateForDateIndex:(NSInteger)dateIndex monthIndex:(NSInteger)monthIndex yearIndex:(NSInteger) yearIndex {
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setDay: dateIndex];
	[components setMonth:monthIndex];
	[components setYear:yearIndex];
	return [[NSCalendar currentCalendar] dateFromComponents:components];
}

#pragma mark - UICollectionViewDatasource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return self.numberOfMonth;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSInteger startIndex = [[self.startingDays objectAtIndex:section] integerValue];
	NSInteger totalDays = [[self.monthlyDateCount objectAtIndex:section] integerValue];
	return (totalDays + startIndex-1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CalendarCell.reuseIdentifier forIndexPath:indexPath];
	NSInteger startIndex = [[self.startingDays objectAtIndex:indexPath.section] integerValue];
	NSInteger dateIndex = indexPath.row - (startIndex - 1);
	if (indexPath.row >= startIndex - 1 && dateIndex < [self.monthlyDateCount[indexPath.section] integerValue]) {
		cell.dateLabel.text = [NSString stringWithFormat:@"%lu",(long)dateIndex + 1];
		if ([indexPath isEqual:self.startDateIndexPath]) { //Configuration for start day
			cell.imageView.image = [UIImage imageNamed:@"Right"];
			cell.dateLabel.textColor = [UIColor whiteColor];
		}else if ([indexPath isEqual:self.endDateIndexPath]) { //Configuration for end day
			cell.imageView.image = [UIImage imageNamed:@"Left"];
			cell.dateLabel.textColor = [UIColor whiteColor];
		}else { // Configuration for normal day
			BOOL isOlderDate = [self isOlderDate:indexPath];
			cell.userInteractionEnabled = !isOlderDate;
			if ([self isSunday:indexPath]) {
				cell.dateLabel.textColor = isOlderDate ? [UIColor grayColor] : [UIColor redColor];
			} else {
				cell.dateLabel.textColor = isOlderDate ? [UIColor grayColor] : [UIColor blackColor];
			}
		}
	}
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(CGRectGetWidth(collectionView.frame) / 7.0, CGRectGetWidth(collectionView.frame)/7.0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 0.0;
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableArray *indexPathsToReload = [NSMutableArray array];
	switch (self.selectionMode) {
		case SelectStart: {
			if ([indexPath isEqual:self.startDateIndexPath] ||
			   (self.endDateIndexPath &&
			   ([indexPath compare:self.endDateIndexPath] == NSOrderedDescending || [indexPath compare:self.endDateIndexPath] == NSOrderedSame))) { return; }
			NSIndexPath *previousSelected = self.startDateIndexPath;
			self.startDateIndexPath = indexPath;
			if (previousSelected) {
				[indexPathsToReload addObject:previousSelected];
			}
			if (self.startDateIndexPath) {
				[indexPathsToReload addObject:self.startDateIndexPath];
			}
			if ([self.delegate respondsToSelector:@selector(calendarView:didSelectStartDate:)]) {
				[self.delegate calendarView:self didSelectStartDate:[self startDate]];
			}
			break;
		}
		case SelectEnd: {
			if ([indexPath isEqual:self.endDateIndexPath] ||
			   (self.startDateIndexPath &&
			   ([indexPath compare:self.startDateIndexPath] == NSOrderedAscending || [indexPath compare:self.startDateIndexPath] == NSOrderedSame))) {
			       return;
			    }
			NSIndexPath *previousSelected = self.endDateIndexPath;
			self.endDateIndexPath = indexPath;
			if (previousSelected) {
				[indexPathsToReload addObject:previousSelected];
			}
			if (self.endDateIndexPath) {
				[indexPathsToReload addObject:self.endDateIndexPath];
			}
			if ([self.delegate respondsToSelector:@selector(calendarView:didSelectEndDate:)]) {
				[self.delegate calendarView:self didSelectEndDate:[self endDate]];
			}
			break;
		}
	}
	[self.collectionView reloadItemsAtIndexPaths:indexPathsToReload];
}

#pragma mark - IBActions

- (IBAction)showNext:(id)sender {
	[self shouldShowPrevious:YES];
}

- (IBAction)showPrevious:(id)sender {
	[self shouldShowPrevious:NO];
}

- (void)shouldShowPrevious:(BOOL)previous {
	NSInteger section =[self currentSection];
	NSInteger newSection = section;
	if  (section >= 0 && previous) {
		newSection ++;
	} else if (section < self.collectionView.numberOfSections && !previous) {
		newSection --;
	}
	CGRect frame;
	if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
		frame = CGRectMake(0, self.collectionView.frame.size.height * (newSection),
							  self.collectionView.frame.size.width, self.collectionView.frame.size.height);

	} else {
		frame = CGRectMake(self.collectionView.frame.size.width * (newSection), 0,
							  self.collectionView.frame.size.width, self.collectionView.frame.size.height);
	}
	[self.collectionView scrollRectToVisible:frame animated:YES];
	[self configureHeaderView: newSection];

}

- (NSInteger)currentSection {
	NSInteger section;
	CGPoint contentOffset = self.collectionView.contentOffset;
	if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
		section = (contentOffset.y + self.collectionView.center.y) / self.collectionView.frame.size.height;
	}else {
		section = (contentOffset.x + self.collectionView.center.x) / self.collectionView.frame.size.width;
	}
	return section;
}

#pragma mark - UIScrollViewDelegte methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self configureHeaderView:[self currentSection]];
}

#pragma mark - Private methods

- (void)updateMonthLabel:(NSInteger) index {
	if (index >= 0 && index < self.monthsArray.count && index < self.yearsArray.count) {
		NSInteger monthNumber = [[self.monthsArray objectAtIndex: index] integerValue];
		NSInteger currentYear = [[self.yearsArray objectAtIndex: index] integerValue];
		NSString *name = [NSString stringWithFormat:@"%@ %li",[[[self dateFormatter] monthSymbols]objectAtIndex: monthNumber],(long)currentYear];
		self.monthNameLabel.text = name;
	}
}

- (void)configureHeaderView:(NSInteger)currentSection {
	self.previousButton.enabled = currentSection > 0;
	self.nextButton.enabled = currentSection < (self.collectionView.numberOfSections - 1);
	[self updateMonthLabel: currentSection];
}


@end