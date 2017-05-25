//
//  CreaterContextForSentMessage.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/24/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//
@class Message;
#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"
@interface CreaterContextForSentMessage : NSObject
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,strong) NSManagedObjectContext *context;
-(NSManagedObjectContext*)setupBackGroundManagedObjectContext;
-(void)addObjectToSentContext:(Message*)message context:(NSManagedObjectContext*)context;
@end
