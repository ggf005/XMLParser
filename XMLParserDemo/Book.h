//
//  Book.h
//  XMLParserDemo
//
//  Created by gongguifei on 15/6/3.
//  Copyright (c) 2015年 Gong Guifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, strong) NSString *bookId;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *summary;

@end
