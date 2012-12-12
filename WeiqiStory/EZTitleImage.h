//
//  EZTitleImage.h
//  WeiqiStory
//
//  Created by xietian on 12-12-9.
//
//

#import "cocos2d.h"

//What's the purpose of this class?
//Visualize it?
//You pass me a image, and tell me the size of the view port,
//I will separate the image into several pieces.
//Only disply part of the pieces at a time.
//Enjoy what you are doing, you don't know, because you never do this before, just spend the time to build the mental image of this
//thing, you can do this. 
@interface EZTitleImage : CCNode

- (id) initWith:(NSString*)imageFile viewPort:(CGSize)portSize;


//@property (nonatomic, strong) CCSprite* completeImg;
@property (nonatomic, strong) CCSprite* workingImg;
@property (nonatomic, strong) NSString* imageFile;
@property (nonatomic, assign) CGSize portSize;
@property (nonatomic, assign) CGRect currentRect;

@end
