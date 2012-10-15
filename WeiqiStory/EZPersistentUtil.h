//
//  EZPersistentUtil.h
//  WeiqiStory
//
//  Created by xietian on 12-10-4.
//
//

#import <Foundation/Foundation.h>

//What's the purpose of this class?
//I would like to have all the persistent support code snippet here.
//So I could turn the URL back and forth to string
@interface  NSURL(EZExtension)

- (id)proxyForJson;


@end

@interface EZPersistentUtil : NSObject

@end
