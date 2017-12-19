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
#import "MessageEntity+CoreDataClass.h"
#import "CreaterContextForMessages.h"

@interface SentMessagesViewController ()
@property (nonatomic)NSUInteger number;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)NSArray* listOfMessages;
@property (weak, nonatomic) IBOutlet UIButton *send;
@property (nonatomic, strong)Message *message;
@property (nonatomic, strong)NSManagedObjectContext* context;
@property( nonatomic, strong)NSString* nextPageToken;
@end

static NSString* const sent=@"SENT";
static NSString *const text=@"text/html";
static NSString* const sentEntity=@"Sent";
@implementation SentMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fetchedResultsController = [self.coordinator.contForMessages getFetchedResultsController:sent];
    self.fetchedResultsController.delegate=self;
    NSError *error;
    if(![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@,%@",error,[error userInfo]);
        exit(-1);
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self updateListOfMessages];
}

- (void)updateListOfMessages {
    [self.coordinator getMessages:sent];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self fetchedResultsController]sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionInfo = [[_fetchedResultsController sections]objectAtIndex:section];
    self.number = [sectionInfo numberOfObjects];
    return self.number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableCell *cell = (CustomTableCell *)[tableView dequeueReusableCellWithIdentifier:myIdForSent forIndexPath:indexPath];
    MessageEntity *sentDataModel = [_fetchedResultsController objectAtIndexPath:indexPath];
    [cell customCellDataForInbox:sentDataModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageEntity *sentDataModel=[_fetchedResultsController objectAtIndexPath:indexPath];
    if([sentDataModel.mimeType isEqualToString:text]) {
        DetailViewControllerForHtml *dvcfHTML = [self.storyboard instantiateViewControllerWithIdentifier:@"html"];
        [dvcfHTML setData:sentDataModel coordinator:self.coordinator context:self.coordinator.contForMessages.context];
        [self.navigationController pushViewController:dvcfHTML animated:YES];
    } else {
        DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
        [dvc setData:sentDataModel coordinator:self.coordinator context:self.coordinator.contForMessages.context];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.number-1-indexPath.row == 0) {
        [self.coordinator getMessages:sent];
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
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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
