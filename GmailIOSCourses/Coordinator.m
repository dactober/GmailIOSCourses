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
static NSString* const sentEntity=@"Sent";
static NSString* const inboxEntity=@"Inbox";
static NSString* const inbox=@"INBOX";
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
-(void)getMessages:(NSString*) label{
    [self readListOfMessages:^(NSDictionary* listOfMessages) {
        NSArray* arrayOfMessages=[listOfMessages objectForKey:@"messages"];
        NSString* nextPageToken=[listOfMessages objectForKey:@"nextPageToken"];
        
        __block NSInteger counter=0;
        NSManagedObjectContext *context=[self.contForInbox setupBackGroundManagedObjectContext];
        
        void(^trySaveContext)(void)=^{
            counter++;
            
            if(counter%20==0){
                NSError *mocSaveError=nil;
                if(![context save:&mocSaveError]){
                    NSLog(@"Save did not complete successfully. Error: %@",[mocSaveError localizedDescription]);
                }else{
                    
                    [self.contForInbox.context save:nil];
                    
                }
            }
            
        };
        [context performBlock:^{
            for(int i=0;i<arrayOfMessages.count;i++){
                
                if([self isHasObject:[arrayOfMessages[i]objectForKey:@"id"]]){
                    trySaveContext();
                }else{
                    [self getMessage:[arrayOfMessages[i] objectForKey:@"id"] callback:^(Message* message){
                        [self addObjectToInboxContext:message context:context];
                        trySaveContext();
                    } ];
                }
                
                
            }
        }];
        
        
        
        
    } label:label];
}
-(void)readListOfMessages:(void(^)(NSDictionary*))callback label:(NSString *)labelId{
    if([labelId isEqualToString:inbox]){
        
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
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:inboxEntity];
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
