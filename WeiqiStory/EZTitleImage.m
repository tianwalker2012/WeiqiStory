//
//  EZTitleImage.m
//  WeiqiStory
//
//  Created by xietian on 12-12-9.
//
//

#import "EZTitleImage.h"
#import "EZCCExtender.h"
#import "EZConstants.h"

@implementation EZTitleImage

- (id) initWith:(NSString*)imageFile viewPort:(CGSize)portSize
{
    self = [super init];
    if(self){
        CCSprite* completeImg = [CCSprite spriteWithFile:imageFile];
        self.contentSize = completeImg.contentSize;
        _portSize = portSize;
        _imageFile = imageFile;
    }
    
    return self;
}


//How could I assume this position is based my anchor.
//So just set it up.
- (void) setPosition:(CGPoint)position
{
    super.position = position;
    // CGPoint anchorPoint = self.anchorPoint;
    //[self changeAnchor:ccp(0, 0)];
    //CCNode* parent = _workingImg.parent;
    CGRect imageRect = CGRectMake(fabs(self.boundingBox.origin.x), self.boundingBox.size.height - fabs(self.boundingBox.origin.y) - _portSize.height, _portSize.width, _portSize.height);

    if(CGRectContainsRect(_currentRect, imageRect)){
        EZDEBUG(@"currentRect:%@, imageRect:%@ still available", NSStringFromCGRect(_currentRect), NSStringFromCGRect(imageRect));
        return;
    }
    
    //Minus mean make it bigger.
    _currentRect = CGRectInset(imageRect, -_portSize.width*0.2, -_portSize.height*0.2);
    
    if(_currentRect.origin.x < 0){
        _currentRect.origin.x = 0;
    }
    if(_currentRect.origin.y < 0){
        _currentRect.origin.y = 0;
    }
    
    if(_currentRect.origin.x + _currentRect.size.width > self.contentSize.width){
        _currentRect.size.width = self.contentSize.width - _currentRect.origin.x;
    }
    
    if(_currentRect.origin.y + _currentRect.size.height > self.contentSize.height){
        _currentRect.size.height = self.contentSize.height - _currentRect.origin.y;
    }
    
    CGFloat deltaX = imageRect.origin.x - _currentRect.origin.x;
    //Why reversed on the y coordinator?
    //Draw the image on a paper, you will understand why is this case.
    CGFloat deltaY = _currentRect.origin.y - imageRect.origin.y;
    
    [_workingImg removeFromParentAndCleanup:YES];
    EZDEBUG(@"The current boundingBox is:%@, deltaX:%f, deltaY:%f", NSStringFromCGRect(self.boundingBox), deltaX, deltaY);
    EZDEBUG(@"imageRect:%@,currentRect:%@",NSStringFromCGRect(imageRect), NSStringFromCGRect(_currentRect));
    
    _workingImg = [CCSprite spriteWithFile:_imageFile rect:_currentRect];
    _workingImg.position = ccp(fabs(self.boundingBox.origin.x + deltaX), fabs(self.boundingBox.origin.y - deltaY));
    _workingImg.anchorPoint = ccp(0, 0);
    [self addChild:_workingImg];
    //[self changeAnchor:oldAnchor];
}

@end
