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
#import "Sender.h"
@interface Coordinator()
@property(nonatomic,strong) NSString* nextPageToken;
@end
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
        self.sender=[[Sender alloc]initWithData:[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]];
    }
    return self;
}
-(void)getMessages:(NSString*) label{
    [self readListOfMessages:^(NSDictionary* listOfMessages) {
        NSArray* arrayOfMessages=[listOfMessages objectForKey:@"messages"];
       self.nextPageToken =[listOfMessages objectForKey:@"nextPageToken"];
        
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
                
                if([self isHasObject:[arrayOfMessages[i]objectForKey:@"id"] label:label]){
                    trySaveContext();
                }else{
                    [self getMessage:[arrayOfMessages[i] objectForKey:@"id"] callback:^(Message* message){
                        if([label isEqualToString:inbox]){
                            [self addObjectToInboxContext:message context:context label:inboxEntity];
                        }else{
                            [self addObjectToInboxContext:message context:context label:sentEntity];
                        }
                        
                        trySaveContext();
                    } ];
                }
                
                
            }
        }];
        
        
        
        
    } label:label nextPageToken:self.nextPageToken];
}
-(void)readListOfMessages:(void(^)(NSDictionary*))callback label:(NSString *)labelId nextPageToken:(NSString *)nextPage{
    if([labelId isEqualToString:inbox]){
        
        [self.imf readListOfMessages:labelId callback:callback nextPage:nextPage];
    }
    else{
        
        [self.smf readListOfMessages:labelId callback:callback nextPage:nextPage];
    }
    
    
    
}
-(void)getMessage:(NSString *)messageID callback:(void(^)(Message*))callback{
    
     
    [self.smf getMessage:messageID callback:callback];
}

-(void)sendMessage:(NSString *)to subject:(NSString*) subject body:(NSString*)body{
    [self.sender send:self.userID to:to subject:subject body:body accessToken:self.accessToken];
    
}
-(void)deleteMessage:(NSString*)ID label:(NSString*)label{
    if([label isEqualToString:inbox]){
        [self.sender deleteMessage:self messageID:ID callback:^{
            [self deleteFromContext:ID label:label];
            [self.contForInbox.context save:nil];
            
        }];
    }else{
        
        [self.sender deleteMessage:self messageID:ID callback:^{
            [self deleteFromContext:ID label:label];
            [self.contForInbox.context save:nil];
            
        }];
    }

}
-(void)deleteFromContext:(NSString*)ID label:(NSString*)label{
    if([label isEqualToString:inbox]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:inboxEntity];
        [request setPredicate:[NSPredicate predicateWithFormat:@"messageID == %@", ID]];
        NSError *error = nil;
        NSArray *results = [self.contForInbox.context executeFetchRequest:request error:&error];
        for (NSManagedObject *managedObject in results)
        {
            [self.contForInbox.context deleteObject:managedObject];
        }
        
    }
    else{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Sent"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"messageID == %@", ID]];
        NSError *error = nil;
        NSArray *results = [self.contForInbox.context executeFetchRequest:request error:&error];
        for (NSManagedObject *managedObject in results)
        {
            [self.contForInbox.context deleteObject:managedObject];
        }
        
    }
    
}

-(void)addObjectToInboxContext:(Message*)message context:(NSManagedObjectContext*)context label:(NSString *)label{
    [self.contForInbox addObjectToInboxContext:message context:context label:label];
}
-(bool) isHasObject:(NSString*)ID label:(NSString*)label{
    NSFetchRequest *request;
    if([label isEqualToString:inbox]){
       request = [NSFetchRequest fetchRequestWithEntityName:inboxEntity];
    }else{
        request = [NSFetchRequest fetchRequestWithEntityName:sentEntity];
    }
    
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

@end
