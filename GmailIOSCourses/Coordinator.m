//
//  Coordinator1.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/5/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Coordinator.h"
#import "Message.h"
#import "SendMessagesFetcher.h"
#import "InboxMessagesFetcher.h"
#import "Inbox+CoreDataClass.h"
#import "CreaterContextForInbox.h"
#import "CreaterContextForSentMessage.h"
@implementation Coordinator
-(instancetype)initWithData:(NSString*)email accessToken:(NSString*)accessToken{
    self=[super init];
    if(self){
        self.userID=email;
        self.accessToken=accessToken;
        self.imf=[[InboxMessagesFetcher alloc]initWithData:self.accessToken];
        self.smf=[[SendMessagesFetcher alloc]initWithData:accessToken];
        self.contForInbox=[[CreaterContextForInbox alloc]init];
        self.contForSent=[[CreaterContextForSentMessage alloc]init];
    }
    return self;
}

-(void)readListOfMessages:(void(^)(NSDictionary*))callback label:(NSString *)labelId{
    if([labelId isEqualToString:@"INBOX"]){
        
        [self.imf readListOfMessages:labelId callback:callback];
    }
    else{
        
        [self.smf readListOfMessages:labelId callback:callback];
    }
    
    
    
}
-(void)getMessage:(NSString *)messageID callback:(void(^)(Message*))callback{
    
     
    [self.smf getMessage:messageID callback:callback];
}

-(void)sendMessage:(NSString *)to subject:(NSString*) subject body:(NSString*)body{
    [Message send:self.userID to:to subject:subject body:body accessToken:self.accessToken];
    
}
-(void)addObjectToInboxContext:(Message*)message context:(NSManagedObjectContext*)context{
    [self.contForInbox addObjectToInboxContext:message context:context];
}
-(void)addObjectToSentContext:(Message*)message context:(NSManagedObjectContext*)context{
    [self.contForSent addObjectToSentContext:message context:context];
}
-(bool) isHasObject:(NSString*)ID{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Inbox"];
     NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"messageID == %@", ID]];
   
    NSArray *results = [self.contForInbox.context executeFetchRequest:request error:&error];
    if([results count]){
        return true;
    }
    else{
        return false;
    }
}
-(bool) isHasObjectSent:(NSString*)ID{
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Sent"];
        NSError *error = nil;
        [request setPredicate:[NSPredicate predicateWithFormat:@"messageID == %@", ID]];
        
        NSArray *results = [self.contForSent.context executeFetchRequest:request error:&error];
        if([results count]){
            return true;
        }
        else{
            return false;
        }
}
@end
