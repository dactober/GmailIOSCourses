//
//  SearchViewController.m
//  
//
//  Created by Aleksey Drachyov on 5/17/17.
//
//

#import "SentMessagesViewController.h"
#import "CustomTableCell.h"
#import "DetailViewController.h"
#import "Message.h"
#import "DetailViewControllerForHtml.h"
#import "Sent+CoreDataClass.h"
#import "CreaterContextForSentMessage.h"
@interface SentMessagesViewController ()
@property (nonatomic)NSUInteger number;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSArray* listOfMessages;
@property (weak, nonatomic) IBOutlet UIButton *send;
@property(nonatomic,strong)Message *message;
@property(nonatomic,strong)NSManagedObjectContext* context;
@property(nonatomic,strong)NSString* nextPageToken;
@end

@implementation SentMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fetchedResultsController=[self.coordinator.contForSent fetchedResultsController];
    self.fetchedResultsController.delegate=self;
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self updateListOfMessages];
}
-(void)updateListOfMessages{
    [self.indicator startAnimating];
    [self.coordinator readListOfMessages:^(NSDictionary* listOfMessages){
        self.listOfMessages=[listOfMessages objectForKey:@"messages"];
        self.nextPageToken=[listOfMessages objectForKey:@"nextPageToken"];
        
        __block NSInteger counter=0;
        self.context =[self.coordinator.contForSent setupBackGroundManagedObjectContext];
        void(^trySaveContext)(void)=^{
            counter++;
            
            if(counter%20==0){
                NSError *mocSaveError=nil;
                if(![self.context save:&mocSaveError]){
                    NSLog(@"Save did not complete successfully. Error: %@",[mocSaveError localizedDescription]);
                }else{
                    [self.coordinator.contForSent.context save:nil];
                    [self.indicator stopAnimating];
                    self.indicator.hidden=YES;
                    
                }
            }
            
        };
        
        for(int i=0;i<self.listOfMessages.count;i++){
            
            if([self.coordinator isHasObjectSent:[self.listOfMessages[i]objectForKey:@"id"]]){
                trySaveContext();
            }else{
                [self.coordinator getMessage:[self.listOfMessages[i] objectForKey:@"id"] callback:^(Message* message){
                    NSManagedObjectContext* context=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                    context.parentContext=self.context;
                    [self.coordinator addObjectToSentContext:message context:context];
                    [context save:nil];
                    trySaveContext();
                } ];
            }
            
            
        }
        
    } label:@"SENT"];
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
    CustomTableCell *cell=(CustomTableCell *)[tableView dequeueReusableCellWithIdentifier:myIdForSent forIndexPath:indexPath];
    
    Sent *sentDataModel=[_fetchedResultsController objectAtIndexPath:indexPath];
    
    
    
    [cell customCellDataForSent:sentDataModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Sent *sentDataModel=[_fetchedResultsController objectAtIndexPath:indexPath];
    
    if([sentDataModel.mimeType isEqualToString:@"text/html"]){
        DetailViewControllerForHtml *dvcfHTML=[self.storyboard instantiateViewControllerWithIdentifier:@"html"];
        [dvcfHTML setDataForSent:sentDataModel coordinator:self.coordinator context:self.coordinator.contForSent.context];
        
        [self.navigationController pushViewController:dvcfHTML animated:YES];
    }else{
        DetailViewController *dvc=[self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
        [dvc setDataForSent:sentDataModel coordinator:self.coordinator context:self.coordinator.contForSent.context];
        
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
