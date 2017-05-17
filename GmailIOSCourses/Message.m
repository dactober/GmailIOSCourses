//
//  Message.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/6/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Message.h"
#import "Coordinator.h"
@interface Message ()
@property(strong,nonatomic)NSURLSession *session;
@end

@implementation Message
-(instancetype)initWithData:(NSDictionary*) message{
    self=[super init];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    bool sub=false;
    bool fr=false;
    bool d=false;
    if(self){
        self.sizeEstimate=[message objectForKey:@"sizeEstimate"];
        self.labelIDs=[[LabelIds alloc]initWithData:[message objectForKey:@"labelIds"]];
        self.ID=[message objectForKey:@"id"];
        self.snippet=[message objectForKey:@"snippet"];
        self.internalDate=[message objectForKey:@"internalDate"];
        self.historyID=[message objectForKey:@"historyId"];
        self.payload=[[Payload alloc]initWithData:[message objectForKey:@"payload"]];
        for(int i=0;i<self.payload.headers.count;i++){
            if(sub && fr && d){
                break;
            }
            if([[self.payload.headers[i] objectForKey:@"name"] isEqual:@"Subject"]){
                
                self.subject=[self.payload.headers[i]objectForKey:@"value"];
                sub=true;
            }else{
                if([[self.payload.headers[i] objectForKey:@"name"] isEqual:@"From"]){
                    
                    self.from=[self.payload.headers[i]objectForKey:@"value"];
                    fr=true;
                }else{
                    if([[self.payload.headers[i] objectForKey:@"name"] isEqual:@"Date"]){
                        
                        NSDateFormatter *df=[NSDateFormatter new];
                        [df setDateFormat:@"E, d MMM yyyy HH:mm:ss"];
                        NSMutableString* date=[NSMutableString stringWithString:[self.payload.headers[i]objectForKey:@"value" ]];
                        if(![date containsString:@","]){
                            [date insertString:@"," atIndex:3];
                        }
                       
                        if([date containsString:@" +"]){
                            
                            NSRange range = [date rangeOfString:@" +"];
                            NSString *shortString = [date substringToIndex:range.location];
                            
                            self.date=[df dateFromString:shortString];
                            
                        
                        }else{
                            if([date containsString:@" -"]){
                                NSRange range = [date rangeOfString:@" -"];
                                NSString *shortString = [date substringToIndex:range.location];
                                
                                self.date=[df dateFromString:shortString];
                            }
                            
                                                    
                        }
                }
                    d=true;
            }
        }
        
        self.threadId=[message objectForKey:@"threadId"];
    }
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
   
    
    NSData *encodedMessage = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encoded = [encodedMessage base64EncodedStringWithOptions:0];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"+"
                                           withString:@"-"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"/"
                                           withString:@"_"];
    NSLog(@"%@", encoded);
    
    return encoded;
}
+(void)send:(NSString*)from to:(NSString*)to subject:(NSString*)subject body:(NSString*)body accessToken:(NSString*)accessToken{
    NSString *server=[NSString stringWithFormat:@"https://content.googleapis.com/gmail/v1/users/%@/messages/send?alt=json",from];
    NSURL *userinfoEndpoint = [NSURL URLWithString:server];
    NSString *currentAccessToken = accessToken;
    
    NSDictionary *dict=@{@"raw":[Message encodedMessage:from to:to subject:subject body:body]};
    
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:dict
                                                          options:NSJSONWritingPrettyPrinted error:nil];
    
    // NSLog(@"%@", message);
    // creates request to the userinfo endpoint, with access token in the Authorization header
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:userinfoEndpoint];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", currentAccessToken];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:messageData ];
    // performs HTTP request
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request
               completionHandler:^(NSData *_Nullable data,
                                   NSURLResponse *_Nullable response,
                                   NSError *_Nullable error) {
                   // Handle response
               }] resume];
}
-(void)deleteMessage:(Coordinator*)coordinator callback:(void(^)(void))callback{
    NSString* serverAddressForReadMessages=[NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/%@/messages/%@",coordinator.userID,self.ID];
    NSURL *url = [NSURL URLWithString:serverAddressForReadMessages];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@",coordinator.accessToken];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"DELETE"];
    
    
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        callback();
        
    }] resume];
}
@end
