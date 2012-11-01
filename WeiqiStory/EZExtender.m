//
//  EZExtender.m
//  WeiqiStory
//
//  Created by xietian on 12-9-23.
//
//

#import "EZExtender.h"


NSString* doubleString(NSString* str)
{
    return [NSString stringWithFormat:@"%@%@", str, str];
}

@interface BlockCarrier : NSObject

@property (strong, nonatomic) EZOperationBlock block;

- (id) initWithBlock:(EZOperationBlock)block;

- (void) runBlock;

@end


@implementation UIView(EZPrivate)

- (UIInterfaceOrientation) currentOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    return orientation;
}

- (void) setPosition:(CGPoint)pos
{
    [self setFrame:CGRectMake(pos.x, pos.y, self.frame.size.width, self.frame.size.height)];
}

- (NSString*) orientationToStr
{
    UIInterfaceOrientation orientation = [self currentOrientation];
    if(orientation == UIInterfaceOrientationPortrait){
        return @"Portrait";
    }
    else if(orientation == UIDeviceOrientationPortraitUpsideDown){
        return @"PortraitUpsideDown";
    }
        //Do something if the orientation is in Portrait
    else if(orientation == UIInterfaceOrientationLandscapeLeft){
        return @"LandscapeLeft";
    }
            // Do something if Left
    else {// if(orientation == UIInterfaceOrientationLandscapeRight){
        return @"LandscapeRight";
    }
                //Do something if right
}

@end

#define SecondsPerDay 24*3600

@implementation NSDate(EZPrivate)

- (NSInteger) convertDays
{
    return [self timeIntervalSince1970]/SecondsPerDay;
}

- (BOOL) isPassed:(NSDate*)date
{
    return [self timeIntervalSinceDate:date] <= 0;
}

- (BOOL) InBetween:(NSDate*)start end:(NSDate*)end
{
    NSTimeInterval selfInt = [self timeIntervalSince1970];
    return selfInt > [start timeIntervalSince1970] && selfInt < [end timeIntervalSince1970];
}

//Get the beginning of this date
- (NSDate*) beginning
{
    return [NSDate stringToDate:@"yyyyMMdd" dateString:[self stringWithFormat:@"yyyyMMdd"]];
}

- (NSDate*) ending
{
    return [self.beginning adjust:SecondsPerDay-1];
}

- (BOOL) InBetweenDays:(NSDate*)start end:(NSDate*)end
{
    NSTimeInterval curDay = self.timeIntervalSince1970/SecondsPerDay;
    NSTimeInterval startDay = start.timeIntervalSince1970/SecondsPerDay;
    NSTimeInterval endDay = end.timeIntervalSince1970/SecondsPerDay;
    return (curDay >= startDay && curDay <= endDay);
}

- (NSDate*) adjustDays:(int)days
{
    return [self adjust:days * SecondsPerDay];
}

//Combine the date with the time.
//I love this, relentlessly refractor.
//Since I only need minutes precision,
//So I will only combine minutes
- (NSDate*) combineTime:(NSDate*)time
{
    NSString* dateStr = [self stringWithFormat:@"yyyy-MM-dd"];
    NSString* timeStr = [time stringWithFormat:@"HH:mm"];
    NSString* combineStr = [NSString stringWithFormat:@"%@ %@",dateStr,timeStr];
    return [NSDate stringToDate:@"yyyy-MM-dd HH:mm" dateString:combineStr];
}

- (NSDate*) adjustMinutes:(int)minutes
{
    return [self adjust:minutes*60];
}

- (NSComparisonResult) compareTime:(NSDate*)date
{
    NSDate* combinedTime = [self combineTime:date];
    return [self compare:combinedTime];
}

- (NSDate*) adjust:(NSTimeInterval)delta
{
    NSTimeInterval seconds = [self timeIntervalSince1970];
    return [[NSDate alloc] initWithTimeIntervalSince1970:(seconds+delta)];
}

- (int) monthDay
{
    return [[self stringWithFormat:@"dd"] intValue];
}

- (int) orgWeekDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    uint unitFlags = NSWeekdayCalendarUnit;
    NSDateComponents* dcomponent = [calendar components:unitFlags fromDate:self];
    return [dcomponent weekday];
}


- (BOOL) equalWith:(NSDate*)date format:(NSString*)format
{
    return [[self stringWithFormat:format] compare:[date stringWithFormat:format]] == NSOrderedSame;
}

+ (NSDate*) stringToDate:(NSString*)format dateString:(NSString*)dateStr
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    return [df dateFromString:dateStr];
}

- (NSString*) stringWithFormat:(NSString*)format
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    return [df stringFromDate:self];
}

@end


@implementation NSString(EZPrivate)

//Implement the traditional trim, space new line etc...
- (NSString*) trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSInteger) hexToInt
{
    return strtoul([self cStringUsingEncoding:NSASCIIStringEncoding], 0, 16);
}

@end

@implementation UIColor(EZPrivate)


//Make my life easier.
+ (UIColor*) decimalToColor:(NSString*)hexStr
{
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 1;
    if(hexStr.length == 9){
        NSString* redStr = [hexStr substringWithRange:NSMakeRange(0,3)];
        red = redStr.intValue/255.0;
        
        NSString* greenStr = [hexStr substringWithRange:NSMakeRange(3,3)];
        green = greenStr.intValue/255.0;
        
        NSString* blueStr = [hexStr substringWithRange:NSMakeRange(6,3)];
        blue = blueStr.intValue/255.0;
    }else if(hexStr.length == 12){
        NSString* redStr = [hexStr substringWithRange:NSMakeRange(0,3)];
        red = redStr.intValue/255.0;
        
        NSString* greenStr = [hexStr substringWithRange:NSMakeRange(3,3)];
        green = greenStr.intValue/255.0;
        
        NSString* blueStr = [hexStr substringWithRange:NSMakeRange(6,3)];
        blue = blueStr.intValue/255.0;
        
        NSString* alphaStr = [hexStr substringWithRange:NSMakeRange(9,3)];
        alpha = alphaStr.intValue/255.0;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

//We support 3Hex like CCC or ccc or 6Hex bcbcbc. etc
+ (UIColor*) hexToColor:(NSString*)hexStr
{
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 1;
    if(hexStr.length == 3){
        NSString* redStr = [hexStr substringWithRange:NSMakeRange(0,1)];
        redStr =  doubleString(redStr);
        red = redStr.hexToInt/255.0;
        
        NSString* greenStr = [hexStr substringWithRange:NSMakeRange(1,1)];
        greenStr = doubleString(greenStr);
        green = greenStr.hexToInt/255.0;
        
        NSString* blueStr = [hexStr substringWithRange:NSMakeRange(2,1)];
        blueStr = doubleString(blueStr);
        blue = blueStr.hexToInt/255.0;
        
    }else if(hexStr.length == 6){
        NSString* redStr = [hexStr substringWithRange:NSMakeRange(0,2)];
        red = redStr.hexToInt/255.0;
        
        NSString* greenStr = [hexStr substringWithRange:NSMakeRange(2,2)];
        green = greenStr.hexToInt/255.0;
        
        NSString* blueStr = [hexStr substringWithRange:NSMakeRange(4,2)];
        blue = blueStr.hexToInt/255.0;
        
    }else if(hexStr.length == 8){
        NSString* redStr = [hexStr substringWithRange:NSMakeRange(0,2)];
        red = redStr.hexToInt/255.0;
        
        NSString* greenStr = [hexStr substringWithRange:NSMakeRange(2,2)];
        green = greenStr.hexToInt/255.0;
        
        NSString* blueStr = [hexStr substringWithRange:NSMakeRange(4,2)];
        blue = blueStr.hexToInt/255.0;
        
        NSString* alphaStr = [hexStr substringWithRange:NSMakeRange(6,2)];
        alpha = alphaStr.hexToInt/255.0;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString*) toHexString
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    int redInt = red*255;
    int greenInt = green*255;
    int blueInt = blue*255;
    return [NSString stringWithFormat:@"%X%X%X", redInt, greenInt, blueInt];
}

@end


@implementation NSObject(EZPrivate)

- (void) performBlock:(EZOperationBlock)block withDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(executeBlock:) withObject:block afterDelay:delay];
}

- (void) executeBlock:(EZOperationBlock)block
{
    if(block){
        block();
    }
}

//If Most of the time it is ok
- (void) executeBlockInBackground:(EZOperationBlock)block inThread:(NSThread *)thread
{
    //[EZTaskHelper executeBlockInBG:block];
    //BlockCarrier* bc = [[BlockCarrier alloc] initWithBlock:block];
    if(thread == nil){
        [self performSelectorInBackground:@selector(executeBlock) withObject:block];
    }else{
        [self performSelector:@selector(executeBlock:) onThread:thread withObject:block waitUntilDone:NO];
    }
}

//Polish the code whenever you could. 
- (void) executeBlockInMainThread:(EZOperationBlock)block
{
    [self performSelectorOnMainThread:@selector(executeBlock:) withObject:block waitUntilDone:NO];
}

@end
