//
//  Uploader.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZUploader.h"
#import "SBJson.h"
#import "EZHttpListener.h"
#import "EZFileUtil.h"

@interface  EZUploader()
{
    //NSURLConnection* connection;
}

@end

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

//Actually, which content type is really doesn't matter.
//What if I am interested to know it's status?
- (void) uploadFile:(NSString*)fileName resultBlock:(EZEventBlock)block
{
    //Default is dcument directory
    NSURL* fileURL = [EZFileUtil fileToURL:fileName];
    
    //This is for small file, if download large file, we need to make it do it gradually, otherwise
    //The memory will eat out.
    [self uploadToServer:[NSData dataWithContentsOfURL:fileURL] fileName:fileName contentType:@"Whatever" resultBlock:block];
}

- (void) uploadFileURL:(NSURL*)fileURL resultBlock:(EZEventBlock)block
{
    //This is for small file, if download large file, we need to make it do it gradually, otherwise
    //The memory will eat out.
    EZDEBUG(@"url:%@", fileURL.baseURL);
    [self uploadToServer:[NSData dataWithContentsOfURL:fileURL] fileName:@"firstLecture0.caf" contentType:@"Whatever" resultBlock:block];
}

- (void) uploadToServer:(NSData*)data fileName:(NSString*)name contentType:(NSString*)contentType resultBlock:(EZEventBlock)block
{
    NSString* requestURL = @"http://172.16.0.18:3000/upload";
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    NSString* boundary = @"CoolUploadxxoo";
    // set Content-Type in HTTP header
    NSString *contentTypeParam = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentTypeParam forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    
    NSDictionary* _params = @{};
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload.file\"; filename=\"%@\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Type:%@\r\n\r\n", contentType] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:[NSURL URLWithString:requestURL]];
    EZHttpListener* listener = [[EZHttpListener alloc] init];
    listener.resultBlock = block;
    //This is blocking way of doing thing, later will change it to non-blocking way.
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:listener];
    
    [connection start];
    //connection = nil;
    EZDEBUG(@"Should have started");
}

#pragma mark NSURLConnection delegate.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    EZDEBUG(@"Connection error:%@", error);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    EZDEBUG(@"Recieved data:%@", response);
}

@end
