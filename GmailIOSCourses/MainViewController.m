//
//  MainViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 4/30/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "MainViewController.h"
#import "CustomTableCell.h"
#import "DetailViewController.h"
#import "Message.h"
#import "DetailViewControllerForHtml.h"
#import "MessagesList+CoreDataClass.h"
#import "Inbox+CoreDataClass.h"
@interface MainViewController ()
@property (nonatomic)NSUInteger number;
@property(nonatomic,retain) NSManagedObjectModel *model;
@property(nonatomic,strong) NSManagedObjectContext *context;
@property(nonatomic,strong) NSManagedObjectContext *contextForList;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSMutableArray* listOfMessages;
@property (weak, nonatomic) IBOutlet UIButton *send;
@property(nonatomic,strong)NSMutableDictionary *messages;
@property(nonatomic,strong)Message *message;
@property(nonatomic,strong)NSDictionary* tableDictionary;

@end
@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.listOfMessages=[[NSMutableArray alloc]init];
    self.messages=[NSMutableDictionary new];
  NSError *error;
    
    [self managedObjectModel];
    [self setupManagedObjectContext];
    
    if(![[self fetchedResultsController]performFetch:&error]){
        NSLog(@"Unresolved error %@,%@",error,[error userInfo]);
        exit(-1);
    }
    
    if(![[self fetchedResultsControllerForList]performFetch:&error]){
        NSLog(@"Unresolved error %@,%@",error,[error userInfo]);
        exit(-1);
    }

    // Do any additional setup after loading the view.
}
-(NSFetchedResultsController *)fetchedResultsControllerForList{
    if(_fetchedResultsControllerForList!=nil){
        return _fetchedResultsControllerForList;
    }
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"MessagesList" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort=[[NSSortDescriptor alloc]initWithKey:@"messageID" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    NSFetchedResultsController *theFethResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsControllerForList=theFethResultsController;
    _fetchedResultsControllerForList.delegate=self;
    return _fetchedResultsControllerForList;
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
    _fetchedResultsController.delegate=self;
    return _fetchedResultsController;
}

-(NSURL*)storeURLForList{
    NSURL *url=[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [url URLByAppendingPathComponent:@"storeForList.sqlite"];
}
-(void)managedObjectModel{
    NSURL *momdURL=[[NSBundle mainBundle]URLForResource:@"GmailIOSCourses" withExtension:@"momd"];
    self.model=[[NSManagedObjectModel alloc]initWithContentsOfURL:momdURL];
}
-(void)setupManagedObjectContextForList{
    self.contextForList=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.contextForList.persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.model];
    NSError* error;
    [self.contextForList.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURLForList] options:nil error:&error];
    if(error){
        NSLog(@"error %@",error);
        
    }
    self.contextForList.undoManager=[[NSUndoManager alloc]init];
}
-(void)setupManagedObjectContext{
    self.context=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.context.persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.model];
    NSError* error;
    [self.context.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURLForList] options:nil error:&error];
    if(error){
        NSLog(@"error %@",error);
        
    }
    self.contextForList.undoManager=[[NSUndoManager alloc]init];
}
-(void)updateListOfMessages{
    [self.coordinator readListOfMessages:^(NSMutableArray* listOfMessages){
       // dispatch_async(dispatch_get_main_queue(), ^{
            self.listOfMessages=listOfMessages;
            for(int i=0;i<listOfMessages.count;i++){
                
                MessagesList *new=[NSEntityDescription insertNewObjectForEntityForName:@"MessagesList" inManagedObjectContext:self.context];
                new.messageID=[listOfMessages[i] objectForKey:@"id"];
            }
            
            [self.settingsViewController setMessages:listOfMessages];
           
            
        //});
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self updateListOfMessages];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [[[self fetchedResultsControllerForList]sections]count];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    id sectionInfo=[[_fetchedResultsControllerForList sections]objectAtIndex:section];
    self.number =[sectionInfo numberOfObjects];
    return self.number;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomTableCell *cell=(CustomTableCell *)[tableView dequeueReusableCellWithIdentifier:myId forIndexPath:indexPath];
    Inbox *inboxDataModel=[_fetchedResultsController objectAtIndexPath:indexPath];
    MessagesList *list=[self.fetchedResultsControllerForList objectAtIndexPath:indexPath];
    
    [self.coordinator getMessage:list.messageID callback:^(Message* message){
        self.message=message;
        Inbox *new=[NSEntityDescription insertNewObjectForEntityForName:@"Inbox" inManagedObjectContext:self.context];
        new.date=message.date;
        new.from=message.from;
        new.subject=message.subject;
        new.snippet=message.snippet;
        new.body=[message decodedMessage];
        NSString *indexPathForDictionary=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        self.messages[indexPathForDictionary]=self.message;
        dispatch_async(dispatch_get_main_queue(), ^{
        
        });
    } ];
    
    [cell customCellData:inboxDataModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Inbox *inboxDataModel=[_fetchedResultsController objectAtIndexPath:indexPath];
    NSString *indexPathForDictionary=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    self.message=[self.messages objectForKey:indexPathForDictionary];
    if([self.message.payload.mimeType isEqualToString:@"text/html"]){
        DetailViewControllerForHtml *dvcfHTML=[self.storyboard instantiateViewControllerWithIdentifier:@"html"];
        [dvcfHTML setData:inboxDataModel coordinator:self.coordinator message:[self.messages objectForKey:indexPathForDictionary]];
        [self.navigationController pushViewController:dvcfHTML animated:YES];
    }else{
        DetailViewController *dvc=[self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
        [dvc setData:inboxDataModel coordinator:self.coordinator message:[self.messages objectForKey:indexPathForDictionary]];
        [self.navigationController pushViewController:dvc animated:YES];
    }
    
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.myTableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.myTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.myTableView endUpdates];
}

- (IBAction)send:(id)sender {
    SendViewController *send=[self.storyboard instantiateViewControllerWithIdentifier:@"Send"];
    [send setData:self.coordinator flag:false message:nil];
            [self.navigationController pushViewController:send animated:YES];
}
- (IBAction)refresh:(id)sender {
    [self updateListOfMessages];
}

@end
