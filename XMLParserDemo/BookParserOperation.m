//
//  BookParserOperation.m
//  XMLParserDemo
//
//  Created by gongguifei on 15/6/3.
//  Copyright (c) 2015年 Gong Guifei. All rights reserved.
//

#import "BookParserOperation.h"
#import "Book.h"
@interface BookParserOperation ()<NSXMLParserDelegate>


@property (nonatomic, strong) NSXMLParser *xmlParser;

@property (nonatomic, strong) Book *currentBook;
@property (nonatomic, strong) NSMutableString *currentElementValue;

@property (nonatomic, strong) NSDictionary *modelKeys;
@end

@implementation BookParserOperation

- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init]) {
        self.xmlParser = [[NSXMLParser alloc] initWithData:data];
        self.xmlParser.delegate = self;
    }
    
    return self;
}
- (void)start
{
    self.modelKeys = @{@"title":@"title", @"author":@"author", @"summary":@"summary"};
    
    [self.xmlParser parse];
}


#pragma mark - NSXMLParser delegate

// Document handling methods
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.bookList = [NSMutableArray array];
}
// sent when the parser begins parsing of the document.
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.completionBlock();        
    });

}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"Books"]) {
        return;
    }
    
    if ([elementName isEqualToString:@"Book"]) {
        self.currentBook = [[Book alloc] init];
        self.currentBook.bookId = [attributeDict objectForKey:@"id"];
    }
    
}
// sent when the parser finds an element start tag.
// In the case of the cvslog tag, the following is what the delegate receives:
//   elementName == cvslog, namespaceURI == http://xml.apple.com/cvslog, qualifiedName == cvslog
// In the case of the radar tag, the following is what's passed in:
//    elementName == radar, namespaceURI == http://xml.apple.com/radar, qualifiedName == radar:radar
// If namespace processing >isn't< on, the xmlns:radar="http://xml.apple.com/radar" is returned as an attribute pair, the elementName is 'radar:radar' and there is no qualifiedName.

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Books"]) {
        return;
    }
    
    if ([elementName isEqualToString:@"Book"]) {
        [self.bookList addObject:self.currentBook];
        self.currentBook = nil;
    }
    else {
        if ([self.modelKeys objectForKey:elementName]) {
            [self.currentBook setValue:self.currentElementValue forKey:[self.modelKeys objectForKey:elementName]];;            
        }

    }
    
    self.currentElementValue = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (self.currentElementValue) {
        [self.currentElementValue appendString:string];
    }
    else {
        self.currentElementValue = [NSMutableString stringWithString:string];
    }
}
@end
