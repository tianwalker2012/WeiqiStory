//
//  CCExtender.m
//  WeiqiStory
//
//  Created by xietian on 12-12-6.
//
//

#import "EZCCExtender.h"
#import "EZConstants.h"


@implementation EZCCExtender


@end


@implementation CCNode(EZPrivate)

//The purpose is to change the anchor of a node without change it's position
//It is prepared for the rotation and scale down and up.
- (void) changeAnchor:(CGPoint)changedAnchor
{
    CCNode* node = self;
    CGSize dimension = node.boundingBox.size;
    
    CGPoint orgAnchor = node.anchorPoint;
    
    CGFloat orgX = orgAnchor.x * dimension.width;
    
    CGFloat orgY = orgAnchor.y * dimension.height;
    
    CGFloat changeX = changedAnchor.x * dimension.width;
    
    CGFloat changeY = changedAnchor.y * dimension.height;
    
    CGPoint pos = node.boundingBox.origin;
    
    CGPoint changedPos = ccp(pos.x+(changeX - orgX), pos.y+(changeY - orgY));
    CGPoint orgPos = pos;
    node.position = changedPos;
    node.anchorPoint = changedAnchor;
    EZDEBUG(@"orgAnchor %@,changeAnchor:%@, org position:%@, changed Position:%@",NSStringFromCGPoint(orgAnchor), NSStringFromCGPoint(changedAnchor), NSStringFromCGPoint(orgPos), NSStringFromCGPoint(changedPos));
}




@end