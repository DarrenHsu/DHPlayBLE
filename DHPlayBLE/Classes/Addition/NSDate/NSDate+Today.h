//
//  NSDate+Today.h
//  SKLifePlan
//
//  Created by skcu1805 on 2014/11/11.
//  Copyright (c) 2014年 D.H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Today)

- (NSInteger) chineseYearValue;
- (NSInteger) yearValue;
- (NSInteger) monthValue;
- (NSInteger) dayValue;

+ (NSDate *) getTodayDate;
+ (NSString *) getToday;
+ (NSString *) getChineseToday;
+ (NSString *) getChineseDateStringWithDate:(NSDate *) date;

+ (NSDate *) getDateWithString:(NSString *) dstr format:(NSString *) format;
+ (NSDate *) getDateWithInsurableAge:(NSInteger) year;

- (NSString *) getStringWithFormat:(NSString *) format;

- (NSInteger) insurableYearSinceToday;
- (NSInteger) insurableYearSinceDate:(NSDate *) date;

- (NSInteger) yearSinceToday;
- (NSInteger) yearSinceDate:(NSDate *)  date;

- (NSInteger) monthSinceToday;
- (NSInteger) daySinceToday;

- (NSString *) getChineseDateString;
- (NSString *) getFullChineseDateString;

- (NSDate *) increaseYear:(NSInteger) year;
- (NSDate *) increaseMonth:(NSInteger) month;
- (NSDate *) increaseDay:(NSInteger) day;
- (NSDate *) increaseHour:(NSInteger) hour;
- (NSDate *) increaseMinit:(NSInteger) minute;

- (NSDate *) getGMTDate;

@end