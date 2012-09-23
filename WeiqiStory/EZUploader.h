//
//  Uploader.h
//  FirstCocos2d
//
//  Created by Apple on 12-9-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//What's the purpose of this object?
//Upload the stored steps to server.
//How about the server information?
//Already store in the configure file. 
@interface EZUploader : NSObject

- (NSDictionary*) getFromServer;

@end
