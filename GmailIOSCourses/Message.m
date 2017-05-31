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

@end
static NSString *const mimeTypeRelated = @"multipart/related";
static NSString *const mimeTypeAlternative = @"multipart/alternative";
static NSString *const mimeTypeMixed=@"multipart/mixed";
static NSString *const mimeTypeApplicationPdf=@"application/pdf";
static NSString *const notSupported=@"Contex isn't supported";
@implementation Message

-(instancetype)initWithData:(NSDictionary*) message{
    self=[super init];
    bool sub=false;
    bool fr=false;
    if(self){
        self.sizeEstimate=[message objectForKey:@"sizeEstimate"];
        self.labelIDs=[[LabelIds alloc]initWithData:[message objectForKey:@"labelIds"]];
        self.ID=[message objectForKey:@"id"];
        self.snippet=[message objectForKey:@"snippet"];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        self.internalDate=[message objectForKey:@"internalDate"] ;
        NSNumber *number = [f numberFromString:self.internalDate];
        double myDub = [number doubleValue];
        NSTimeInterval time=myDub/1000;
        self.date=[NSDate dateWithTimeIntervalSince1970:time];
        
        self.historyID=[message objectForKey:@"historyId"];
        self.payload=[[Payload alloc]initWithData:[message objectForKey:@"payload"]];
        
        for(int i=0;i<self.payload.headers.count;i++){
            if(sub && fr ){
                break;
            }
            if([[self.payload.headers[i] objectForKey:@"name"] isEqual:@"Subject"]){
                
                self.subject=[self.payload.headers[i]objectForKey:@"value"];
                sub=true;
            }else{
                if([[self.payload.headers[i] objectForKey:@"name"] isEqual:@"From"]){
                    
                    self.from=[self.payload.headers[i]objectForKey:@"value"];
                    fr=true;
                }
            }
        }
        
        self.threadId=[message objectForKey:@"threadId"];
    }

    return self;
}
-(NSString *)decodedMessage{
    NSString *decodedString;
   if([self.payload.mimeType isEqualToString:mimeTypeRelated]){
        Payload *payload=[[Payload alloc]initWithData:self.payload.parts[0]];
        if([ payload.mimeType isEqualToString:mimeTypeAlternative]){
            Payload *payload1=[[Payload alloc]initWithData:payload.parts[0]];
            if([payload.mimeType isEqualToString:mimeTypeApplicationPdf]){
                return notSupported;
            }
            self.payload.headers=payload1.headers;
            self.payload.mimeType=payload1.mimeType;
            BodyOFMessage* body=[payload1 body];
            NSString* data=body.data;
            data = [data stringByReplacingOccurrencesOfString:@"-"
                                                   withString:@"+"];
            data = [data stringByReplacingOccurrencesOfString:@"_"
                                                   withString:@"/"];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
            decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
           // NSLog(@"decoded string - %@",decodedString);
            
        }else{
            self.payload.headers=payload.headers;
            self.payload.mimeType=payload.mimeType;
            if([payload.mimeType isEqualToString:mimeTypeApplicationPdf]){
                return notSupported;
            }
            BodyOFMessage* body=[payload body];
            NSString* data=body.data;
            data = [data stringByReplacingOccurrencesOfString:@"-"
                                                   withString:@"+"];
            data = [data stringByReplacingOccurrencesOfString:@"_"
                                                   withString:@"/"];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
            decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            //NSLog(@"decoded string - %@",decodedString);
            
            
        }
    }else{
        if([self.payload.mimeType isEqualToString:mimeTypeAlternative]||[self.payload.mimeType  isEqualToString:mimeTypeMixed]){
            Payload *payload=[[Payload alloc]initWithData:self.payload.parts[0]];
            if([self.payload.mimeType  isEqualToString:mimeTypeMixed]){
                Payload *payload=[[Payload alloc]initWithData:self.payload.parts[0]];
                if([payload.mimeType isEqualToString:mimeTypeApplicationPdf]){
                    return notSupported;
                }
                if([payload.mimeType isEqualToString:mimeTypeAlternative]){
                    Payload *payload1=[[Payload alloc]initWithData:payload.parts[0]];
                    self.payload.headers=payload1.headers;
                    self.payload.mimeType=payload1.mimeType;
                    BodyOFMessage* body=[payload1 body];
                    NSString* data=body.data;
                    data = [data stringByReplacingOccurrencesOfString:@"-"
                                                           withString:@"+"];
                    data = [data stringByReplacingOccurrencesOfString:@"_"
                                                           withString:@"/"];
                    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
                    decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
                }else{
                    self.payload.headers=payload.headers;
                    self.payload.mimeType=payload.mimeType;
                    if([payload.mimeType isEqualToString:mimeTypeApplicationPdf]){
                        return notSupported;
                    }
                    BodyOFMessage* body=[payload body];
                    NSString* data=body.data;
                    data = [data stringByReplacingOccurrencesOfString:@"-"
                                                           withString:@"+"];
                    data = [data stringByReplacingOccurrencesOfString:@"_"
                                                           withString:@"/"];
                    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
                    decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
                }
                
                
            }else{
                self.payload.headers=payload.headers;
                self.payload.mimeType=payload.mimeType;
                if([payload.mimeType isEqualToString:mimeTypeApplicationPdf]){
                    return notSupported;
                }
                BodyOFMessage* body=[payload body];
                NSString* data=body.data;
                data = [data stringByReplacingOccurrencesOfString:@"-"
                                                       withString:@"+"];
                data = [data stringByReplacingOccurrencesOfString:@"_"
                                                       withString:@"/"];
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
                decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            }
            
            //NSLog(@"decoded string - %@",decodedString);
            
        }else{
            if([self.payload.mimeType isEqualToString:mimeTypeApplicationPdf]){
                return notSupported;
            }
            BodyOFMessage* body=[self.payload body];
            NSString* data=body.data;
            data = [data stringByReplacingOccurrencesOfString:@"-"
                                                   withString:@"+"];
            data = [data stringByReplacingOccurrencesOfString:@"_"
                                                   withString:@"/"];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
            decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
           // NSLog(@"decoded string - %@",decodedString);
            
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
@end
