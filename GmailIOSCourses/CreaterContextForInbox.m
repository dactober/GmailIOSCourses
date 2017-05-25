//
//  CreaterContextForInbox.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/22/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "CreaterContextForInbox.h"
#import "Inbox+CoreDataClass.h"
#import "Message.h"
@interface CreaterContextForInbox()
@property(nonatomic,retain) NSManagedObjectModel *model;
@end
@implementation CreaterContextForInbox
-(instancetype)init{
    self=[super init];
    if(self){
        NSError *error;
      // [[NSFileManager defaultManager]removeItemAtPath:[self storeURL].path error:&error];
        [self managedObjectModel];
        self.container=[[NSPersistentContainer alloc]initWithName:@"Container" managedObjectModel:self.model];
        [self setupManagedObjectContext];
        if(![[self fetchedResultsController]performFetch:&error]){
            NSLog(@"Unresolved error %@,%@",error,[error userInfo]);
            exit(-1);
        }
    }
    return self;
}
-(NSFetchedResultsController *)fetchedResultsController{
    if(_fetchedResultsController!=nil){
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Inbox" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort=[[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    NSFetchedResultsController *theFethResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController=theFethResultsController;
    return _fetchedResultsController;
}
-(NSURL*)storeURL{
    NSURL *url=[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [url URLByAppendingPathComponent:@"storeInbox.sqlite"];
}
-(void)managedObjectModel{
    NSURL *momdURL=[[NSBundle mainBundle]URLForResource:@"InboxMessageModel" withExtension:@"momd"];
    self.model=[[NSManagedObjectModel alloc]initWithContentsOfURL:momdURL];
}
-(void)setupManagedObjectContext{
    self.context=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.context.persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.model];
    NSError* error;
    [self.context.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error];
    if(error){
        NSLog(@"error %@",error);
        
    }
    self.context.undoManager=[[NSUndoManager alloc]init];
}
-(NSManagedObjectContext*)setupBackGroundManagedObjectContext{
    NSManagedObjectContext* context=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.parentContext=self.context;
    return context;
}
-(void)addObjectToInboxContext:(Message*)message context:(NSManagedObjectContext*)context{
    Inbox *new=[NSEntityDescription insertNewObjectForEntityForName:@"Inbox" inManagedObjectContext:context];
    new.date=message.date;
    new.from=message.from;
    new.subject=message.subject;
    new.snippet=message.snippet;
    new.messageID=message.ID;
    new.body=[message decodedMessage];
    new.mimeType=message.payload.mimeType;
    
}
@end
