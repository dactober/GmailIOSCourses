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
#import "DetailViewControllerForHtml.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSMutableArray* listOfMessages;
@property(nonatomic,strong)NSMutableDictionary *messages;
@property(nonatomic,strong)Message *message;
@property(nonatomic,strong)NSDictionary* tableDictionary;

@end
@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.listOfMessages=[[NSMutableArray alloc]init];
    self.messages=[NSMutableDictionary new];
  
   
    
   
    
    
    // Do any additional setup after loading the view.
}
-(void)updateListOfMessages{
    [self.coordinator readListOfMessages:^(NSMutableArray* listOfMessages){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.listOfMessages=listOfMessages;
            [self.settingsViewController setMessages:listOfMessages];
            [self.myTableView reloadData];
            
        });
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self updateListOfMessages];
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
    
    [self.coordinator getMessage:[self.tableDictionary objectForKey:@"id"] callback:^(Message* message){
        self.message=message;
        NSString *indexPathForDictionary=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        self.messages[indexPathForDictionary]=self.message;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [cell customCellData:message];
        });
    } ];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indexPathForDictionary=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    self.message=[self.messages objectForKey:indexPathForDictionary];
    if([self.message.payload.mimeType isEqualToString:@"text/html"]){
        DetailViewControllerForHtml *dvcfHTML=[self.storyboard instantiateViewControllerWithIdentifier:@"html"];
        [dvcfHTML setData:self.message coordinator:self.coordinator];
        [self.navigationController pushViewController:dvcfHTML animated:YES];
    }else{
        DetailViewController *dvc=[self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
        [dvc setData:[self.messages objectForKey:indexPathForDictionary] coordinator:self.coordinator];
        [self.navigationController pushViewController:dvc animated:YES];
    }
    
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
