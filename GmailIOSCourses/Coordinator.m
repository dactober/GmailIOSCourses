//
//  Coordinator1.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/5/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Coordinator.h"
#import "Message.h"
#import "AllMessagesFetcher.h"
@implementation Coordinator
-(instancetype)initWithData:(NSString*)email accessToken:(NSString*)accessToken{
    self=[super init];
    if(self){
        self.userID=email;
        self.accessToken=accessToken;
        self.amf=[[AllMessagesFetcher alloc]initWithData:self.accessToken];
        
    }
    return self;
}

-(void)readListOfMessages:(void(^)(NSMutableArray*))callback{
    self.serverAddressForReadMessages=[NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/%@/messages?fields=messages(id,threadId),nextPageToken&maxResults=%d",self.userID,20];
    
    [self.amf readListOfMessages:self.serverAddressForReadMessages callback:callback];
    
}
-(void)getMessage:(NSString *)messageID callback:(void(^)(Message*))callback{
    self.serverAddressForReadMessages=[NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/%@/messages/%@?field=raw",self.userID,messageID];
    [self.amf getMessage:self.serverAddressForReadMessages callback:callback];
}

-(void)sendMessage:(NSString *)to subject:(NSString*) subject body:(NSString*)body{
    [Message send:self.userID to:to subject:subject body:body accessToken:self.accessToken];
    
}
@end
