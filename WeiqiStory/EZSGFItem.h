//
//  EZSGFItem.h
//  EZFirstFlex
//
//  Created by xietian on 12-12-23.
//  Copyright (c) 2012年 xietian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    kOtherType,//For node I don't know, I will use other node as it's name
    kComments,
    kPlantChessman,
    kPresetChessman,
    kLabel,
    kTriangler,
    kChessNode
}  SGFNodeType;

//This is represent a ITEM in the Node.
//
@interface EZSGFItem : NSObject

//
@property (nonatomic, strong) NSString* name;

@property (nonatomic, assign) SGFNodeType type;

@property (nonatomic, strong) NSMutableArray* properties;

//generate the coord from the AlphaBata
- (NSArray*) getCoords;

@end
