//
//  EZCleanAction.h
//  WeiqiStory
//
//  Created by xietian on 12-9-25.
//
//

#import <Foundation/Foundation.h>
#import "EZAction.h"

//What's the purpose of this class
//Initially, I am thinking about add a presetting action which have a clean ability.
//Later I realize, clean is not as simple as clean.
//It have more than just clean.
//Whether we need to recover it or not.
//What should we do?
//What I can anticipate is that once cleaned,
//The undo must recover,
//Other wise,the back make no sense.
//Ok, let's recover all the steps,
//Since we could store them all. 
@interface EZCleanAction : EZAction

@property (assign, nonatomic) 

@end
