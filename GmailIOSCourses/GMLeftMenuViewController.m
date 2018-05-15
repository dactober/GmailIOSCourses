//
//  GMLeftMenuViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/2/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import "GMLeftMenuViewController.h"
#import "LeftMenuTableViewCell.h"
#import "MainViewController.h"
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "DriveViewController.h"
#import <Google/SignIn.h>
#import "CreaterContextForMessages.h"
#import "LeftMenuHeaderView.h"

typedef NS_ENUM(NSUInteger, TableViewCellType) {
    TableViewCellTypeGmail,
    TableViewCellTypeDrive,
    TableViewCellTypeCalendar,
    
    TableViewCellTypeCount
};
@interface GMLeftMenuViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) LGSideMenuController *sideMenu;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIButton *logOut;
@property (nonatomic, strong) LeftMenuTableViewCell *currentCell;
@end

@implementation GMLeftMenuViewController

+ (instancetype)leftMenuWithItems:(NSArray *)items {
    return [[self alloc] initWithItems:items];
}

- (instancetype)initWithItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self.items = items;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setImageView];
    self.tableView = [self createTableView];
    self.logOut = [self createLogOutButton];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"LeftMenuTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"leftMenuCell"];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
}

- (void)setImageView {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:@"gradient"];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:imageView];
    [imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [imageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

- (UITableView *)createTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableView];
    [tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:65].active = YES;
    [tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    return tableView;
}

- (UIButton *)createLogOutButton {
    UIButton *logOut = [[UIButton alloc] initWithFrame:CGRectZero];
    [logOut setBackgroundImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
    logOut.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:logOut];
    [logOut.topAnchor constraintEqualToAnchor:self.tableView.bottomAnchor constant:8].active = YES;
    [logOut.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16].active = YES;
    [logOut.widthAnchor constraintEqualToConstant:40].active = YES;
    [logOut.heightAnchor constraintEqualToConstant:40].active = YES;
    
    [logOut.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-16].active = YES;
    [logOut addTarget:self action:@selector(showLogOutAlert) forControlEvents:UIControlEventTouchUpInside];
    return logOut;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return TableViewCellTypeCount;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [LeftMenuHeaderView header];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftMenuTableViewCell *cell = (LeftMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"leftMenuCell" forIndexPath:indexPath];
    NSDictionary *dict = [self tableMapping][@(indexPath.row)];
    NSString *title = [dict.allKeys firstObject];
    cell.image.image = dict[title];
    cell.label.text = title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!self.currentCell && indexPath.row == 0) {
        self.currentCell = cell;
        cell.label.textColor = UIColor.blackColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setSideMenuFromNavigationController];
    self.currentCell.label.textColor = [UIColor lightGrayColor];
    LeftMenuTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.label.textColor = [UIColor blackColor];
    self.currentCell = cell;
    switch (indexPath.row) {
        case TableViewCellTypeGmail:
            self.sideMenu.rootViewController = self.items[TableViewCellTypeGmail];
            [self.sideMenu hideLeftViewAnimated:YES completionHandler:nil];
            break;
        case TableViewCellTypeDrive:
            self.sideMenu.rootViewController = self.items[TableViewCellTypeDrive];
            [self.sideMenu hideLeftViewAnimated:YES completionHandler:nil];
            break;
        case TableViewCellTypeCalendar:
            
            break;
            
        default:
            break;
    }
}

- (void)setSideMenuFromNavigationController {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LGSideMenuController class]]) {
            self.sideMenu = (LGSideMenuController *)controller;
            return;
        }
    }
}

- (NSDictionary *)tableMapping {
    return @{
             @(TableViewCellTypeGmail) : @{@"Gmail" : [UIImage imageNamed:@"mail"] },
             @(TableViewCellTypeDrive) : @{@"Drive" : [UIImage imageNamed:@"drive"] },
             @(TableViewCellTypeCalendar) : @{@"Calendar" : [UIImage imageNamed:@"calendar"] },
             };
}

- (NSDictionary *)leftMenuMapping {
    return @{
             @(TableViewCellTypeGmail) : @"Gmail",
             @(TableViewCellTypeDrive) : @"Drive",
             @(TableViewCellTypeCalendar) : @"Calendar",
             };
}

- (void)logout {
    [[GIDSignIn sharedInstance] signOut];
    [self deleteAllEntities:@"MessageEntity"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showLogOutAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Attention" message:@"Do you want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self logout];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteAllEntities:(NSString *)nameEntity {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    NSURL *momdURL = [[NSBundle mainBundle] URLForResource:@"MessageModel" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momdURL];
    context.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    [context.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[CreaterContextForMessages storeURL] options:nil error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    context.undoManager = [[NSUndoManager alloc] init];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [context deleteObject:object];
    }
    
    error = nil;
    [context save:&error];
}


@end
