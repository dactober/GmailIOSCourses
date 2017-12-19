//
//  CreaterContextForInbox.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/22/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//
@class Message;
#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"
@interface CreaterContextForMessages : NSObject
- (NSFetchedResultsController*)getFetchedResultsController:(NSString*)label;
- (NSManagedObjectContext*)setupBackGroundManagedObjectContext;
- (void)addObjectToInboxContext:(Message*)message context:(NSManagedObjectContext*)context;
- (NSURL*)storeURL;
- (void)deleteFromContext:(NSString*)ID;
@property(nonatomic, strong) NSManagedObjectContext *context;
@end
