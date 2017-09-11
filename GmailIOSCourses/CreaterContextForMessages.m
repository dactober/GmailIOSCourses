//
//  CreaterContextForInbox.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/22/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "CreaterContextForMessages.h"
#import "MessageEntity+CoreDataClass.h"
#import "Message.h"
@interface CreaterContextForMessages()
@property(nonatomic,retain) NSManagedObjectModel *model;
@end
@implementation CreaterContextForMessages
-(instancetype)init{
    self=[super init];
    if(self){
        
        [self managedObjectModel];
        [self setupManagedObjectContext];
        
    }
    return self;
}
-(NSFetchedResultsController *)getFetchedResultsController:(NSString*)label{
    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"MessageEntity" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"label == %@", label]];
    NSSortDescriptor *sort=[[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    NSFetchedResultsController *theFethResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    
    return theFethResultsController;;
}
-(NSURL*)storeURL{
    NSURL *url=[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [url URLByAppendingPathComponent:@"storeMessages.sqlite"];
}
-(void)managedObjectModel{
    NSURL *momdURL=[[NSBundle mainBundle]URLForResource:@"MessageModel" withExtension:@"momd"];
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
    MessageEntity *new=[NSEntityDescription insertNewObjectForEntityForName:@"MessageEntity" inManagedObjectContext:context];
    new.date=message.date;
    new.from=message.from;
    new.subject=message.subject;
    new.snippet=message.snippet;
    new.messageID=message.ID;
    new.body=[message decodedMessage];
    new.mimeType=message.payload.mimeType;
    new.label= message.labelIDs.list;
}
-(void)deleteFromContext:(NSString*)ID{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MessageEntity"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"messageID == %@", ID]];
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    for (NSManagedObject *managedObject in results)
    {
        [self.context deleteObject:managedObject];
    }
}
@end
