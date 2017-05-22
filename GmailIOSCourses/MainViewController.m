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
#import "Inbox+CoreDataClass.h"
#import "CreaterContextForInbox.h"
@interface MainViewController ()
@property (nonatomic)NSUInteger number;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property(nonatomic,strong) NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSArray* listOfMessages;
@property (weak, nonatomic) IBOutlet UIButton *send;
@property(nonatomic,strong)Message *message;

@end
@implementation MainViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    
    CreaterContextForInbox *contForInbox=[[CreaterContextForInbox alloc]init];
    self.fetchedResultsController=[contForInbox fetchedResultsController];
    self.context=[contForInbox context];
    self.fetchedResultsController.delegate=self;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Inbox"];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    if (!results) {
        [self updateListOfMessages:false];
    }else{
        [self updateListOfMessages:true];
    }
    
    // Do any additional setup after loading the view.
}

-(void)updateListOfMessages:(bool) flag{
    [self.indicator startAnimating];
    [self.coordinator readListOfMessages:^(NSArray* listOfMessages){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.listOfMessages=listOfMessages;
            for(int i=0;i<listOfMessages.count;i++){
               
                [self.coordinator getMessage:[listOfMessages[i] objectForKey:@"id"] callback:^(Message* message){
                    
                    if(!flag){
                        
                        Inbox *new=[NSEntityDescription insertNewObjectForEntityForName:@"Inbox" inManagedObjectContext:self.context];
                        new.date=message.date;
                        new.from=message.from;
                        new.subject=message.subject;
                        new.snippet=message.snippet;
                        new.messageID=[listOfMessages[i] objectForKey:@"id"];
                        new.body=[message decodedMessage];
                        new.mimeType=message.payload.mimeType;
                        
                    }else{
                        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Inbox"];
                        [request setPredicate:[NSPredicate predicateWithFormat:@"messageID == %@", [listOfMessages[i] objectForKey:@"id"]]];
                        NSError *error = nil;
                        NSArray *results = [self.context executeFetchRequest:request error:&error];
                        if(![results count]){
                            self.message=message;
                            Inbox *new=[NSEntityDescription insertNewObjectForEntityForName:@"Inbox" inManagedObjectContext:self.context];
                            new.date=message.date;
                            new.from=message.from;
                            new.subject=message.subject;
                            new.snippet=message.snippet;
                            new.body=[message decodedMessage];
                            new.mimeType=message.payload.mimeType;
                            new.messageID=[listOfMessages[i] objectForKey:@"id"];
                           
                        }
                    }
                    
                
                    
                } ];
            }
            
            [self.settingsViewController setMessages:listOfMessages];
         
            
        });
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[[self fetchedResultsController]sections]count];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id sectionInfo=[[_fetchedResultsController sections]objectAtIndex:section];
    self.number =[sectionInfo numberOfObjects];
    return self.number;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.indicator stopAnimating];
    CustomTableCell *cell=(CustomTableCell *)[tableView dequeueReusableCellWithIdentifier:myId forIndexPath:indexPath];
    
    Inbox *inboxDataModel=[_fetchedResultsController objectAtIndexPath:indexPath];

        dispatch_async(dispatch_get_main_queue(), ^{
        
            [cell customCellData:inboxDataModel];
        });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Inbox *inboxDataModel=[_fetchedResultsController objectAtIndexPath:indexPath];
    
    if([inboxDataModel.mimeType isEqualToString:@"text/html"]){
        DetailViewControllerForHtml *dvcfHTML=[self.storyboard instantiateViewControllerWithIdentifier:@"html"];
        [dvcfHTML setData:inboxDataModel coordinator:self.coordinator context:self.context];
       
        [self.navigationController pushViewController:dvcfHTML animated:YES];
    }else{
        DetailViewController *dvc=[self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
        [dvc setData:inboxDataModel coordinator:self.coordinator context:self.context];
        
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
    NSError *mocSaveError=nil;
    if(![self.context save:&mocSaveError]){
        NSLog(@"Save did not complete successfully. Error: %@",[mocSaveError localizedDescription]);
    }
    [self.myTableView endUpdates];
}

- (IBAction)send:(id)sender {
    SendViewController *send=[self.storyboard instantiateViewControllerWithIdentifier:@"Send"];
    [send setData:self.coordinator flag:false message:nil];
            [self.navigationController pushViewController:send animated:YES];
}
- (IBAction)refresh:(id)sender {
    [self updateListOfMessages:true];
}

@end
