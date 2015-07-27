//
//  ViewController.m
//  Test
//
//  Created by Pavel Deminov on 15/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "TasksViewController.h"

#define kItemName @"kItemName"

@interface TasksViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UITableView *_tableView;
    
}

@property (nonatomic,strong) NSArray *itemsArray;

@end

@implementation TasksViewController

#pragma mark ViewController Base Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _itemsArray =  @[@{kItemName:@"Task1"},@{kItemName:@"Task2"},@{kItemName:@"Task3"}];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationItem.title = @"Tasks";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _itemsArray.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict =[_itemsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:kItemName];
    
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"ThreadsSegue" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"PhotoSegue" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"AlgorithmsSegue" sender:self];
            break;
            
        default:
            break;
    }
    
    
    
}


@end
