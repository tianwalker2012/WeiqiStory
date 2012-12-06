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
    
    CGPoint orgPos = node.position;
    CGPoint orgAnchor = node.anchorPoint;
    
    //CGFloat orgX = orgAnchor.x * dimension.width;
    
    //CGFloat orgY = orgAnchor.y * dimension.height;
    CGRect backBox = node.boundingBox;
    
    node.anchorPoint = ccp(0, 0);
    node.position = backBox.origin;
    
    CGFloat changeX = changedAnchor.x * dimension.width;
    
    CGFloat changeY = changedAnchor.y * dimension.height;
    
    //CGPoint pos = node.boundingBox.origin;
    
    CGPoint changedPos = ccp(node.position.x + changeX, node.position.y + changeY);
    node.position = changedPos;
    node.anchorPoint = changedAnchor;
    EZDEBUG(@"orgAnchor %@,changeAnchor:%@, org position:%@, changed Position:%@",NSStringFromCGPoint(orgAnchor), NSStringFromCGPoint(changedAnchor), NSStringFromCGPoint(orgPos), NSStringFromCGPoint(changedPos));
}




@end