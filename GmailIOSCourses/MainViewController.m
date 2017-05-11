//
//  MainViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 4/30/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "MainViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLRGmail.h"
#import "CustomTableCell.h"
#import "DetailViewController.h"
#import "Message.h"
@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSArray* listOfMessages;
@property(nonatomic,strong)NSMutableArray *messages;
@property(nonatomic,strong)Message *message;
@property(nonatomic,strong)NSDictionary* tableDictionary;

@end
@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.messages=[NSMutableArray new];
    
    void(^callback)(NSArray*)=^(NSArray* listOfMessages){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.listOfMessages=listOfMessages;
            [self.myTableView reloadData];
        });
    };
    [self.coordinator readListOfMessages:callback];
   
    
    
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.listOfMessages count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomTableCell *cell=(CustomTableCell *)[tableView dequeueReusableCellWithIdentifier:myId forIndexPath:indexPath];
    self.tableDictionary =[self.listOfMessages objectAtIndex:indexPath.row];
    void(^callback)(NSDictionary*)=^(NSDictionary* listOfMessages){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.message=[self.coordinator createMessage:listOfMessages];
            [self.messages addObject:self.message];
            [cell customCellData:self.message];
        });
    };
    [self.coordinator getMessage:[self.tableDictionary objectForKey:@"id"] callback:callback];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *dvc=[self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
   [dvc setData:[self.myTableView cellForRowAtIndexPath:indexPath] message:[self.messages objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:dvc animated:YES];
}
- (IBAction)sent:(id)sender {
    SendViewController *send=[self.storyboard instantiateViewControllerWithIdentifier:@"Send"];
    [self.navigationController pushViewController:send animated:YES];
}


@end
