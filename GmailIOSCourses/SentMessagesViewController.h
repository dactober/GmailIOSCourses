//
//  SearchViewController.h
//
//
//  Created by Aleksey Drachyov on 5/17/17.
//
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"
#import "Coordinator.h"
#import "SendViewController.h"
#import "SettingsTableViewController.h"
#import "SentMessagesViewController.h"

static NSString *myIdForSent = @"SentId";

@interface SentMessagesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

+ (instancetype)controllerWithCoordinator:(Coordinator *)coordinator;
- (instancetype)initWithCoordinator:(Coordinator *)coordinator;

@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, strong) SettingsTableViewController *settingsViewController;
@property(nonatomic, strong) SentMessagesViewController *sentMessagesViewController;
@end
