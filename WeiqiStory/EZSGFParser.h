//
//  EZSGFParser.h
//  EZFirstFlex
//
//  Created by xietian on 12-12-23.
//  Copyright (c) 2012年 xietian. All rights reserved.
//

#ifndef EZFirstFlex_EZSGFParser_h
#define EZFirstFlex_EZSGFParser_h

@class EZChessNode;

EZChessNode* parse(NSString* fileName);

EZChessNode* parseFullPath(NSString* fileName);

#endif
