//
//  EZHttpListener.m
//  WeiqiStory
//
//  Created by xietian on 12-10-16.
//
//

#import "EZHttpListener.h"

@implementation EZHttpListener

#pragma mark NSURLConnection delegate.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //EZDEBUG(@"Connection error:%@", error);
    if(_connectBlock){
        _connectBlock(error);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //EZDEBUG(@"Recieved data:%@", response);
    if(_resultBlock){
        _resultBlock(response);
    }
}

@end
