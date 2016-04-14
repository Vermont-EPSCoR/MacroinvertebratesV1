//
//  XMLDelegateBug.h
//  macroinvertebrates
//
//  Created by pclemins on 3/17/16.
//  Copyright © 2016 mmai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLDelegateBug : NSObject <NSXMLParserDelegate>

//@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSMutableArray *arrInsectSections;
//@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage;
@property (nonatomic, strong) NSMutableString *currentValue;
@property (nonatomic, strong) NSString *currentElement;

-(void)parserDidStartDocument:(NSXMLParser *)parser;
-(void)parserDidEndDocument:(NSXMLParser *)parser;
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
-(NSArray*) getArray;

@end
