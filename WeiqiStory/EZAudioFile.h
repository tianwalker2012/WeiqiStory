//
//  EZAudioFile.h
//  WeiqiStory
//
//  Created by xietian on 12-10-18.
//
//

#import <Foundation/Foundation.h>

@interface EZAudioFile : NSObject

//Whether this file in mainBundle or in the document directory.
@property (nonatomic, assign) BOOL inMainBundle;

//Already downloaded or what?
@property (nonatomic, assign) BOOL downloaded;

@property (nonatomic, strong) NSString* fileName;

- (NSURL*) getFileURL;

-(id)initWithCoder:(NSCoder *)decoder;

-(void)encodeWithCoder:(NSCoder *)coder;

@end
