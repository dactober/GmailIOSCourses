//
//  AllMessagesFetcher.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/18/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "AllMessagesFetcher.h"
#import "Message.h"

@interface AllMessagesFetcher () 
@property(strong,nonatomic)NSURLSession *session;
@end
@implementation AllMessagesFetcher 
-(instancetype)initWithData:(NSString*)accessToken{
    self=[super init];
    if(self){
        self.accessToken=accessToken;
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}
-(void)readListOfMessages:(NSString*)serverAddressForReadMessages callback:(void(^)(NSArray*))callback{
    
    NSURL *url = [NSURL URLWithString:serverAddressForReadMessages];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@",self.accessToken];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        self.messageArray=[json objectForKey:@"messages"];
        
        callback(self.messageArray);
    }] resume];
    
}

-(void )getMessage:(NSString *)serverAddressForReadMessages callback:(void(^)(Message*))callback{
    NSURL *url = [NSURL URLWithString:serverAddressForReadMessages];
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
