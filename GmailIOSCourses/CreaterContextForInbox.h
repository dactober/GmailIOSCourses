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
@interface CreaterContextForInbox : NSObject
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,strong) NSManagedObjectContext *context;
-(NSManagedObjectContext*)setupBackGroundManagedObjectContext;
-(void)addObjectToInboxContext:(Message*)message context:(NSManagedObjectContext*)context;
@property(nonatomic,strong)NSPersistentContainer *container;
@end
