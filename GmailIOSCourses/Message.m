//
//  Message.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/6/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Message.h"

@implementation Message
-(instancetype)initWithData:(NSDictionary*) message{
    self=[super init];
    if(self){
        self.sizeEstimate=[message objectForKey:@"sizeEstimate"];
        self.labelsIDs=[message objectForKey:@"labelIds"];
        self.ID=[message objectForKey:@"id"];
        self.snippet=[message objectForKey:@"snippet"];
        self.internalDate=[message objectForKey:@"internalDate"];
        self.historyID=[message objectForKey:@"historyId"];
        self.payload=[message objectForKey:@"payload"];
        self.threadId=[message objectForKey:@"threadId"];
    }
    return self;
}
-(NSString *)decodeMessage{
    NSString *decodedString;
    if([[self.payload objectForKey:@"mimeType"] isEqualToString:@"multipart/related"]){
        self.parts=[self.payload objectForKey:@"parts"];
        if([[self.parts[0] objectForKey:@"mimeType"] isEqualToString:@"multipart/alternative"]){
            self.parts=[self.parts[0] objectForKey:@"parts"];
            NSDictionary* body=[self.parts[0] objectForKey:@"body"];
            NSString* data=[body objectForKey:@"data"];
            data = [data stringByReplacingOccurrencesOfString:@"-"
                                                   withString:@"+"];
            data = [data stringByReplacingOccurrencesOfString:@"_"
                                                   withString:@"/"];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
            decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            NSLog(@"decoded string - %@",decodedString);
            
        }else{
            NSDictionary* body=[self.parts[0] objectForKey:@"body"];
            NSString* data=[body objectForKey:@"data"];
            data = [data stringByReplacingOccurrencesOfString:@"-"
                                                   withString:@"+"];
            data = [data stringByReplacingOccurrencesOfString:@"_"
                                                   withString:@"/"];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
            decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            NSLog(@"decoded string - %@",decodedString);
            
            
        }
    }else{
        if([[self.payload objectForKey:@"mimeType"] isEqualToString:@"multipart/alternative"]||[[self.payload objectForKey:@"mimeType"] isEqualToString:@"multipart/mixed"]){
            self.parts=[self.payload objectForKey:@"parts"];
            NSDictionary* body=[self.parts[0] objectForKey:@"body"];
            NSString* data=[body objectForKey:@"data"];
            data = [data stringByReplacingOccurrencesOfString:@"-"
                                                   withString:@"+"];
            data = [data stringByReplacingOccurrencesOfString:@"_"
                                                   withString:@"/"];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
            decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            NSLog(@"decoded string - %@",decodedString);
            
        }else{
            NSDictionary* body=[self.payload objectForKey:@"body"];
            NSString* data=[body objectForKey:@"data"];
            data = [data stringByReplacingOccurrencesOfString:@"-"
                                                   withString:@"+"];
            data = [data stringByReplacingOccurrencesOfString:@"_"
                                                   withString:@"/"];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
            decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            NSLog(@"decoded string - %@",decodedString);
            
        }
    }
    
    return decodedString;
    
}

@end
