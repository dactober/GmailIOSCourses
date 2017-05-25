//
//  SentMessageFetcher.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/12/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "SendMessagesFetcher.h"
#import "Message.h"
static int maxResults=20;
@interface SendMessagesFetcher () 
@property(strong,nonatomic)NSURLSession *session;
@end
@implementation SendMessagesFetcher
-(instancetype)initWithData:(NSString*)accessToken{
    self=[super init];
    if(self){
        self.accessToken=accessToken;
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}
-(void)readListOfMessages:(NSString*)labelId callback:(void(^)(NSDictionary*))callback{
    NSString* serverAddressForReadMessages=[NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/me/messages?fields=messages(id,threadId),nextPageToken&maxResults=%d&labelIds=%@",maxResults,labelId];;
    NSURL *url = [NSURL URLWithString:serverAddressForReadMessages];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@",self.accessToken];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        callback(json);
    }] resume];
    
}

-(void )getMessage:(NSString *)messageID callback:(void(^)(Message*))callback{
    NSString* serverAddressForMessage=[NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/me/messages/%@?field=raw",messageID];
    NSURL *url = [NSURL URLWithString:serverAddressForMessage];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@",self.accessToken];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        Message* message= [self createMessage:json];
        callback(message);
        ;
    }] resume];
    
}
-(Message *)createMessage:(NSDictionary *)message{
    Message *msg=[[Message alloc]initWithData:message];
    return msg;
}

@end
