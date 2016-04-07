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
    else if([currentElement isEqualToString:@"timestamp"]) {
        currentValue = [NSMutableString stringWithString:[currentValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];

        @autoreleasepool {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
            NSDate *date = [[NSDate alloc] init];
            date = [dateFormatter dateFromString:currentValue];
//            NSLog(@"XMLDelegateBug in the timestamp: %@", currentValue);
//            NSLog(@"Parsed Date: %@", date);
            self.timestamp = date;
        }

        [currentValue setString:@""];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if([currentElement isEqualToString:@"text"] || [currentElement isEqualToString:@"timestamp"])
        [currentValue appendString:string];
}

-(NSArray*) getArray {
    return arrInsectSections;
}

@end

