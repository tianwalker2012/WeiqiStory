//
//  EZCommonUtil.m
//  WeiqiStory
//
//  Created by xietian on 12-10-16.
//
//

#import "EZCommonUtil.h"

@implementation EZCommonUtil

//What the lesson I have learned from this method's defintion?
//When there is no dependence, make it as indepenedent as possible.
//From this hand on experience, this could turn into my prinicple now.
//Why it is so slow? IS this better now?
//Seems better now.
//So even if you have a tons of memory, keep your interface lean.
+ (UIInterfaceOrientation) currentOrientation
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

+ (NSString*) currentOrientationStr
{
    
    UIInterfaceOrientation orientation = [EZCommonUtil currentOrientation];
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
