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
        self.labelIDs=[[LabelIds alloc]initWithData:[message objectForKey:@"labelIds"]];
        self.ID=[message objectForKey:@"id"];
        self.snippet=[message objectForKey:@"snippet"];
        self.internalDate=[message objectForKey:@"internalDate"];
        self.historyID=[message objectForKey:@"historyId"];
        self.payload=[[Payload alloc]initWithData:[message objectForKey:@"payload"]];
        
        self.threadId=[message objectForKey:@"threadId"];
    }
    return self;
}
-(NSString *)decodedMessage{
    NSString *decodedString;
   if([self.payload.mimeType isEqualToString:@"multipart/related"]){
        Payload *payload=[[Payload alloc]initWithData:self.payload.parts[0]];
        if([ payload.mimeType isEqualToString:@"multipart/alternative"]){
            Payload *payload1=[[Payload alloc]initWithData:payload.parts[0]];
            self.payload.headers=payload1.headers;
            BodyOFMessage* body=[payload1 body];
            NSString* data=body.data;
            data = [data stringByReplacingOccurrencesOfString:@"-"
                                                   withString:@"+"];
            data = [data stringByReplacingOccurrencesOfString:@"_"
                                                   withString:@"/"];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
            decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            NSLog(@"decoded string - %@",decodedString);
            
        }else{
            self.payload.headers=payload.headers;
            BodyOFMessage* body=[payload body];
            NSString* data=body.data;
            data = [data stringByReplacingOccurrencesOfString:@"-"
                                                   withString:@"+"];
            data = [data stringByReplacingOccurrencesOfString:@"_"
                                                   withString:@"/"];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
            decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            NSLog(@"decoded string - %@",decodedString);
            
            
        }
    }else{
        if([self.payload.mimeType isEqualToString:@"multipart/alternative"]||[self.payload.mimeType  isEqualToString:@"multipart/mixed"]){
            Payload *payload=[[Payload alloc]initWithData:self.payload.parts[0]];
            self.payload.headers=payload.headers;
            BodyOFMessage* body=[payload body];
            NSString* data=body.data;
            data = [data stringByReplacingOccurrencesOfString:@"-"
                                                   withString:@"+"];
            data = [data stringByReplacingOccurrencesOfString:@"_"
                                                   withString:@"/"];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
            decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            NSLog(@"decoded string - %@",decodedString);
            
        }else{
            BodyOFMessage* body=[self.payload body];
            NSString* data=body.data;
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
+ (NSString *)encodedMessage:(NSString*)from to:(NSString*)to subject:(NSString*)subject body:(NSString*)body{
    NSString *message = [NSString stringWithFormat:@"From: <%@>\nTo: <%@>\nSubject: <%@\n\n%@>",from,to,subject,body];
   // NSString *rawMessage = [message stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    
    NSData *encodedMessage = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encoded = [encodedMessage base64EncodedStringWithOptions:0];
    NSLog(@"%@", encoded);
    
    return encoded;
}
@end
