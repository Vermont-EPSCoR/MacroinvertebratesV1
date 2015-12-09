//
//  HTTPRequestHandler.m
//  
//
//  Created by Bijay Koirala on 11/28/15.
//
//

#import "HTTPRequestHandler.h"

@implementation HTTPRequestHandler

+(NSDictionary*)restData: (NSString*)weburl
{
    NSDictionary *rest_data = nil;
    NSURL *url = [NSURL URLWithString:weburl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                   queue:[NSOperationQueue mainQueue]
                       completionHandler:^(NSURLResponse *response,
                                           NSData *data, NSError *connectionError) {
                           
                           if (data.length > 0 && connectionError == nil) {
                           
                        ///rest_data = [NSJSONSerialization JSONObjectWithData:data
                                                                                //     options:0
                                                                                  //       error:NULL];
                             
                                                        }
                                                        
                              }];
    return rest_data;

}


@end
