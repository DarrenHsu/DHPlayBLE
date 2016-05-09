//
//  NSDate+Today.m
//  SKLifePlan
//
//  Created by skcu1805 on 2014/11/11.
//  Copyright (c) 2014年 D.H. All rights reserved.
//

#import "NSDate+Today.h"

@implementation NSDate (Today)

- (NSInteger) chineseYearValue {
    NSDateComponents *birthdayComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    NSInteger year = [birthdayComponents year];
    return year - 1911;
}

- (NSInteger) yearValue {
    NSDateComponents *birthdayComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    NSInteger year = [birthdayComponents year];
    return year;
}

- (NSInteger) monthValue {
    NSDateComponents *birthdayComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    NSInteger month = [birthdayComponents month];
    return month;
}

- (NSInteger) dayValue {
    NSDateComponents *birthdayComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    NSInteger day = [birthdayComponents day];
    return day;
}

+ (NSDate *) getTodayDate {
    NSDate *nowDate = [self getDateWithString:[self getToday] format:@"yyyyMMdd"];
    return nowDate;
}

+ (NSString *) getToday {
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger year = [todayComponents year];
    NSInteger month = [todayComponents month];
    NSInteger day = [todayComponents day];
    NSString *today = [NSString stringWithFormat:@"%zd%02zd%02zd",year,month,day];
    return today;
}

+ (NSString *) getChineseToday {
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger year = [todayComponents year];
    NSInteger month = [todayComponents month];
    NSInteger day = [todayComponents day];
    NSString *today = [NSString stringWithFormat:@"%zd%02zd%02zd",year - 1911,month,day];
    return today;
}

+ (NSString *) getChineseDateStringWithDate:(NSDate *)date {
    NSDateComponents *birthdayComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger year = [birthdayComponents year];
    NSInteger month = [birthdayComponents month];
    NSInteger day = [birthdayComponents day];
    return [NSString stringWithFormat:@"%zd/%02zd/%02zd",year - 1911,month, day];
}

+ (NSDate *) getDateWithString:(NSString *)dstr format:(NSString *)format {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dstr];
}

- (NSString *) getStringWithFormat:(NSString *) format {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

+ (NSDate *) getDateWithInsurableAge:(NSInteger) year {
    NSDate *date = [NSDate date];
    NSDate *insurableDate = [date increaseYear:-year];
    insurableDate = [insurableDate increaseMonth:6];
    insurableDate = [insurableDate increaseYear:-1];
    return insurableDate;
}

- (NSInteger) insurableYearSinceToday {
    NSDate* now = [NSDate date];
    NSDate *insureDate = [now increaseMonth:6];

    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                       fromDate:self
                                       toDate:insureDate
                                       options:0];
    NSInteger year = [ageComponents year];
    return year;
}

- (NSInteger) insurableYearSinceDate:(NSDate *) date {
    NSDate *insureDate = [date increaseMonth:6];

    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                       fromDate:self
                                       toDate:insureDate
                                       options:0];
    NSInteger year = [ageComponents year];
    return year;
}

- (NSInteger) yearSinceToday {
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                       fromDate:self
                                       toDate:now
                                       options:0];
    NSInteger year = [ageComponents year];
    return year;
}

- (NSInteger) yearSinceDate:(NSDate *)  date {
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                       fromDate:self
                                       toDate:date
                                       options:0];
    NSInteger year = [ageComponents year];
    return year;
}

- (NSInteger) monthSinceToday {
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                       fromDate:self
                                       toDate:now
                                       options:0];
    NSInteger month = [ageComponents month];
    return month;
}

- (NSInteger) daySinceToday {
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                       fromDate:self
                                       toDate:now
                                       options:0];
    NSInteger day = [ageComponents day];
    return day;
}

- (NSString *) getChineseDateString {
    NSDateComponents *birthdayComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    NSInteger year = [birthdayComponents year];
    NSInteger month = [birthdayComponents month];
    NSInteger day = [birthdayComponents day];
    return [NSString stringWithFormat:@"%zd/%02zd/%02zd",year - 1911,month, day];
}

- (NSString *) getFullChineseDateString {
    NSDateComponents *birthdayComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit  fromDate:self];
    NSInteger year = [birthdayComponents year];
    NSInteger month = [birthdayComponents month];
    NSInteger day = [birthdayComponents day];
    NSInteger hour = [birthdayComponents hour];
    NSInteger minute = [birthdayComponents minute];
    NSInteger second = [birthdayComponents second];
    return [NSString stringWithFormat:@"%zd/%02zd/%02zd %02zd:%02zd:%02zd",year - 1911,month, day, hour, minute, second];
}

- (NSDate *) increaseYear:(NSInteger) year {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:year];
    return [gregorian dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *) increaseMonth:(NSInteger) month {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:month];
    return [gregorian dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *) increaseDay:(NSInteger) day {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:day];
    return [gregorian dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *) increaseHour:(NSInteger) hour {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setHour:hour];
    return [gregorian dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *) increaseMinit:(NSInteger) minute {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMinute:minute];
    return [gregorian dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *) getGMTDate {
    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; // You could also use the systemTimeZone method
    NSTimeInterval gmtTimeInterval = [self timeIntervalSinceReferenceDate] + timeZoneOffset;
    NSDate *gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
    return gmtDate;
}

@end