//
//  Uploader.h
//  FirstCocos2d
//
//  Created by Apple on 12-9-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZConstants.h"

//What's the purpose of this object?
//Upload the stored steps to server.
//How about the server information?
//Already store in the configure file. 
@interface EZUploader : NSObject<NSURLConnectionDataDelegate>

- (NSDictionary*) getFromServer;

- (void) uploadToServer:(NSData*)data fileName:(NSString*)name contentType:(NSString*)contentType resultBlock:(EZEventBlock)block;

//Once this is done, I could upload my editted episode.
//Which is great.
- (void) uploadFile:(NSString*)fileName resultBlock:(EZEventBlock)block;

- (void) uploadFileURL:(NSURL*)fileName resultBlock:(EZEventBlock)block;


@end
