//
//  EZTableViewCell.h
//  WeiqiStory
//
//  Created by xietian on 12-11-8.
//
//

#import <UIKit/UIKit.h>

//What the purpose of this class?
//It is to reuse the panels.
//To generate the basic pattern each time from scratch is a very costly, operation.
//So that I need to have this cell hold all the panels, which can be fetched out and replaced accordingly.
@interface EZTableViewCell : UITableViewCell

//The key the point string, mean no panel will over lap each other in this map.
//Other things, simply keep it as transparent as possible. 
@property (nonatomic, strong) NSMutableDictionary* panels;

//For example, if current index is not dirty?
//Then this cell don't need to be updated.
//Do you agree?
@property (nonatomic, strong) NSMutableDictionary* currentIndexs;

- (BOOL) isIndexExist:(CGPoint)pos;

- (void) addIndex:(CGPoint)pos;

@end
