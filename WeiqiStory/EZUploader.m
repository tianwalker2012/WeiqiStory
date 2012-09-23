//
//  Uploader.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZUploader.h"
#import "SBJson.h"
#import "EZConstants.h"

@implementation EZUploader

- (NSDictionary*) getFromServer
{
    NSString* strURL = @"http://172.16.0.17:8888/download/my.json";
    NSData* data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strURL]];
    //[NSString stringWithContentsOfURL:@"" encoding: error:<#(NSError **)#>
    
    NSString* str = [NSString stringWithContentsOfURL:[NSURL URLWithString:strURL] encoding:NSUTF8StringEncoding error:nil];
    EZDEBUG(@"String:%@", str);
    return str.JSONValue;
}

@end
