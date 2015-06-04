//
//  BookParserOperation.h
//  XMLParserDemo
//
//  Created by gongguifei on 15/6/3.
//  Copyright (c) 2015年 Gong Guifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookParserOperation : NSOperation
@property (nonatomic, strong) NSMutableArray *bookList;

- (instancetype)initWithData:(NSData *)data;
@end
