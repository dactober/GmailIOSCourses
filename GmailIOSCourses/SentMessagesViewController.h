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
@interface SentMessagesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate>
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,strong)SettingsTableViewController* settingsViewController;
@property(nonatomic,strong)SentMessagesViewController *sentMessagesViewController;
@property (strong,nonatomic)Coordinator *coordinator;
@end
static NSString *myIdForSent=@"SentId";
