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
#import "DetailViewControllerForHtml.h"
#import "CreaterContextForMessages.h"
#import "MessageEntity+CoreDataClass.h"
#import "LoadingViewController.h"

@interface MainViewController ()
@property(nonatomic, assign) NSUInteger number;
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *listOfMessages;
@property(weak, nonatomic) IBOutlet UIButton *send;
@property(strong, nonatomic) Coordinator *coordinator;
@property(weak, nonatomic) id<LGSideMenuDelegate> delegate;
@end
static NSString *const text = @"text/html";
static NSString *const inbox = @"INBOX";
static NSString *const inboxEntity = @"Inbox";
static const int kCountVisibleCells = 7;
static const int kCountCellsForUpdate = 5;
@implementation MainViewController

+ (instancetype)controllerWithCoordinator:(Coordinator *)coordinator delegate:(id<LGSideMenuDelegate>)delegate {
    return [[self alloc] initWithCoordinator:coordinator delegate:delegate];
}

- (instancetype)initWithCoordinator:(Coordinator *)coordinator delegate:(id<LGSideMenuDelegate>)delegate {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:inboxEntity];
    if (self) {
        self.coordinator = coordinator;
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = inboxEntity;
    self.fetchedResultsController = [self.coordinator.contForMessages fetchedResultsController:inbox];
    self.fetchedResultsController.delegate = self;
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@,%@", error, [error userInfo]);
        exit(-1);
    }
}

- (void)updateListOfMessages {
    [self.coordinator messages:inbox];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateListOfMessages];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    self.number = [sectionInfo numberOfObjects];
    return self.number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableCell *cell = (CustomTableCell *)[tableView dequeueReusableCellWithIdentifier:myIdForInbox forIndexPath:indexPath];
    MessageEntity *inboxDataModel = [_fetchedResultsController objectAtIndexPath:indexPath];
    [cell customCellDataForInbox:inboxDataModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageEntity *messageModel = [_fetchedResultsController objectAtIndexPath:indexPath];
    if ([messageModel.mimeType isEqualToString:text]) {
        DetailViewControllerForHtml *dvcfHTML = [self.storyboard instantiateViewControllerWithIdentifier:@"html"];
        [dvcfHTML setData:messageModel coordinator:self.coordinator context:self.coordinator.contForMessages.context];
        [self.navigationController pushViewController:dvcfHTML animated:YES];
    } else {
        DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
        [dvc setData:messageModel coordinator:self.coordinator context:self.coordinator.contForMessages.context];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.number - 1 - indexPath.row == 0) {
        [self.coordinator messages:inbox];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kCountCellsForUpdate && self.tableView.visibleCells.count < kCountVisibleCells) {
        [self updateListOfMessages];
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
    didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self hideLoading:[LoadingViewController sharedInstance]];
    [self.tableView endUpdates];
}

- (IBAction)send:(id)sender {
    SendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"Send"];
    [send setData:self.coordinator flag:false message:nil];
    [self.navigationController pushViewController:send animated:YES];
}
- (IBAction)refresh:(id)sender {
    [self updateListOfMessages];
}

@end
