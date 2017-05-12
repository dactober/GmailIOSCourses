//
//  SentMessageFetcher.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/12/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "SendMessageFetcher.h"
#import "Message.h"
@implementation SendMessageFetcher
-(instancetype)initWithData:(NSString*)accessToken{
    self=[super init];
    if(self){
        self.accessToken=accessToken;
        
    }
    return self;
}
-(void)send:(NSString*)from to:(NSString*)to subject:(NSString*)subject body:(NSString*)body{
    NSString *server=[NSString stringWithFormat:@"https://www.googleapis.com/upload/gmail/v1/users/%@/messages/send?uploadType=media",from];
    NSURL *userinfoEndpoint = [NSURL URLWithString:server];
    NSString *currentAccessToken = self.accessToken;
    
   
    
    // Handle refreshing tokens
    
    NSString *message = [NSString stringWithFormat:@"{\"raw\": \"%@\"}",[Message encodedMessage:from to:to subject:subject body:body]];
    NSLog(@"%@", message);
    
    // creates request to the userinfo endpoint, with access token in the Authorization header
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:userinfoEndpoint];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", currentAccessToken];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"message/rfc822" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[message length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[message dataUsingEncoding:NSUTF8StringEncoding]];
     
     NSURLSessionConfiguration *configuration =
     [NSURLSessionConfiguration defaultSessionConfiguration];
     NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                           delegate:nil
                                                      delegateQueue:nil];
     // performs HTTP request
     NSURLSessionDataTask *postDataTask =
     [session dataTaskWithRequest:request
                completionHandler:^(NSData *_Nullable data,
                                    NSURLResponse *_Nullable response,
                                    NSError *_Nullable error) {
                    // Handle response
                }];
     
     [postDataTask resume];
}
@end
