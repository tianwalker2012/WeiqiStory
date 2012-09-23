//
//  MainMenu.h
//  FirstCocos2d
//
//  Created by xietian on 12-9-13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


//What's the purpose of this class?
//It will serve as a main menu.
//It have 3 buttons according to my current design.
//1. Go training button
//2. Go playing button
//3. setting button.
//Currently, the idea lingering in my mind is about how to implement the mouse touch event.
//What's my opion regarding this?
//Each region handle his own business.
//First of all let's describe the process of Touch event handling.
//Each ccNode have chance to get the touch event notification.
//We have exlusive event or share mode.
//By exclusive mean that once we determined we handled this event, this event will not give to other component.
//The share mode is each person have the chance to get the touch event.
//My Share region is a good one right?
//It could act as a button object.
@class EZResponsiveRegion;
@interface MainPage : CCLayer<CCTouchDelegate>


@property (strong, nonatomic) EZResponsiveRegion* goTraining;
@property (strong, nonatomic) EZResponsiveRegion* goPlaying;
@property (strong, nonatomic) EZResponsiveRegion* configure;

@end
