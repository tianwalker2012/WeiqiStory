//
//  EZExtender.h
//  WeiqiStory
//
//  Created by xietian on 12-9-23.
//
//

#import <Foundation/Foundation.h>
#import "EZConstants.h"
//This is a files which contain a bunch of extension I used to extend the functionality of the NSObject.


@interface NSObject(EZPrivate)

- (void) performBlock:(EZOperationBlock)block withDelay:(NSTimeInterval)delay;

- (void) executeBlock:(EZOperationBlock)block;

- (void) executeBlockInBackground:(EZOperationBlock)block inThread:(NSThread*)thread;

- (void) executeBlockInMainThread:(EZOperationBlock)block;

@end

@interface UIView(EZPrivate)

//The purpose is to get current orienation out
- (UIInterfaceOrientation) currentOrientation;

- (NSString*) orientationToStr;

- (void) setPosition:(CGPoint)pos;

@end


@interface NSDate(EZPrivate)

- (NSInteger) convertDays;

- (NSDate*) beginning;

- (NSDate*) ending;

- (int) orgWeekDay;

- (int) monthDay;

+ (NSDate*) stringToDate:(NSString*)format dateString:(NSString*)dateStr;

- (NSString*) stringWithFormat:(NSString*)format;

- (NSDate*) adjustDays:(int)days;

- (NSDate*) adjustMinutes:(int)minutes;

- (NSDate*) adjust:(NSTimeInterval)delta;

- (NSComparisonResult) compareTime:(NSDate*)date;

- (NSDate*) combineTime:(NSDate*)time;

//True mean they are equal with the format, False mean not equal.
- (BOOL) equalWith:(NSDate*)date format:(NSString*)format;

//Check if the date fall inbetween the specified start and end.
//It will including the stat and end date.
- (BOOL) InBetweenDays:(NSDate*)start end:(NSDate*)end;

- (BOOL) InBetween:(NSDate*)start end:(NSDate*)end;

//Wether have passed the passin time or not
- (BOOL) isPassed:(NSDate*)date;

@end

@interface NSString(EZPrivate)
- (NSString*) trim;
- (NSInteger) hexToInt;
@end


@interface UIColor(EZPrivate)
    + (UIColor*) decimalToColor:(NSString*)hexStr;
//We support 3Hex like CCC or ccc or 6Hex bcbcbc. etc
    + (UIColor*) hexToColor:(NSString*)hexStr;
    - (NSString*) toHexString;
@end



