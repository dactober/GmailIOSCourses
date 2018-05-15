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
    self.tableView = [self createTableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"LeftMenuTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"leftMenuCell"];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
}

- (UITableView *)createTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.tableHeaderView = [self headerView];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableView];
    [tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:65].active = YES;
    [tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:20].active = YES;
    return tableView;
}

- (UIView *)headerView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    view.backgroundColor = [UIColor blackColor];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return TableViewCellTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftMenuTableViewCell *cell = (LeftMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"leftMenuCell" forIndexPath:indexPath];
    NSDictionary *dict = [self tableMapping][@(indexPath.row)];
    NSString *title = [dict.allKeys firstObject];
    cell.image.image = dict[title];
    cell.label.text = title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setSideMenuFromNavigationController];
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
             @(TableViewCellTypeDrive) : @{@"Drive" : [UIImage imageNamed:@"drive"] },
             @(TableViewCellTypeCalendar) : @{@"Calendar" : [UIImage imageNamed:@"calendar"] },
             };
}


@end
