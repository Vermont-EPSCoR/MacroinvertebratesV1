//
//  XMLDelegateBug.m
//  macroinvertebrates
//
//  Created by csys on 3/17/16.
//  Copyright © 2016 mmai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLDelegateBug.h"

@interface XMLDelegateBug ()
@end

@implementation XMLDelegateBug

@synthesize currentElement;
@synthesize arrInsectSections;
@synthesize currentValue;

-(void)parserDidStartDocument:(NSXMLParser *)parser {
    arrInsectSections = [[NSMutableArray alloc] init];
    currentValue = [[NSMutableString alloc] init];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    // Nothing to do
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"%@", [parseError localizedDescription]);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

    // Keep track of element currently being parsed
    currentElement = elementName;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([currentElement isEqualToString:@"text"]) {
        [arrInsectSections addObject:[NSString stringWithString:currentValue]];
        [currentValue setString:@""];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if([currentElement isEqualToString:@"text"])
        [currentValue appendString:string];
}

-(NSArray*) getArray {
    return arrInsectSections;
}

@end

