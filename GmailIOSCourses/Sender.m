//
//  Sender.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/25/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Sender.h"
#import "Message.h"
#import "Coordinator.h"
@interface Sender()
@property(nonatomic,strong)NSURLSession *session;
@end
@implementation Sender

- (instancetype)initWithSession:(NSURLSession *)session {
    self=[super init];
    if(self){
        self.session=session;
    }
    return self;
}
- (void)send:(NSString*)from to:(NSString*)to subject:(NSString*)subject body:(NSString*)body accessToken:(NSString*)accessToken {
    NSString *server=[NSString stringWithFormat:@"https://content.googleapis.com/gmail/v1/users/%@/messages/send?alt=json",from];
    NSURL *url = [NSURL URLWithString:server];
    NSString *currentAccessToken = accessToken;
    NSDictionary *dict=@{@"raw":[Message encodedMessage:from to:to subject:subject body:body]};
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *request =[self request:url accessToken:currentAccessToken];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:messageData ];
    // performs HTTP request
    [[self.session dataTaskWithRequest:request
                     completionHandler:^(NSData *_Nullable data,
                                         NSURLResponse *_Nullable response,
                                         NSError *_Nullable error) {
                         // Handle response
                     }] resume];
}

- (void)deleteMessage:(Coordinator*)coordinator messageID:(NSString*)messageID callback:(void(^)(void))callback {
    NSString* serverAddressForReadMessages=[NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/me/messages/%@",messageID];
    NSURL *url = [NSURL URLWithString:serverAddressForReadMessages];
    NSMutableURLRequest *request = [self request:url accessToken:coordinator.accessToken];
    [request setHTTPMethod:@"DELETE"];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        callback();
    }] resume];
}

- (NSMutableURLRequest*)request:(NSURL*)url accessToken:(NSString*)token {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@",token];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    return request;
}
@end
