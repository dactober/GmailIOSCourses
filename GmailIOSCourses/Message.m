//
//  Message.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/6/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Message.h"
#import "Coordinator.h"
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
    NSString *message = [NSString stringWithFormat:@"From: %@\r\nTo: %@\r\nSubject: %@\r\n\r\n%@",from,to,subject,body];
   // NSString *rawMessage = [message stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    
    NSData *encodedMessage = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encoded = [encodedMessage base64EncodedStringWithOptions:0];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"+"
                                           withString:@"-"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"/"
                                           withString:@"_"];
    NSLog(@"%@", encoded);
    
    return encoded;
}
-(void)deleteMessage:(Coordinator*)coordinator callback:(void(^)(void))callback{
    NSString* serverAddressForReadMessages=[NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/%@/messages/%@",coordinator.userID,self.ID];
    NSURL *url = [NSURL URLWithString:serverAddressForReadMessages];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@",coordinator.accessToken];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"DELETE"];
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        callback();
        
    }] resume];
}
@end
