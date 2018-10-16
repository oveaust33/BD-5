//
//  HomeViewController.m
//  BD
//
//  Created by maclab on 10/15/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController (){
    
    NSMutableArray *dataArray;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Add"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(addAction)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Logout"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    self.bookListTable.delegate  = self;
    self.bookListTable.dataSource  = self;
    
    self.title = @"Home";
    
    [self.navigationItem setHidesBackButton:YES];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    DataModel *dm = [[DataModel alloc] init];

    NSArray *books = [dm getDataWithEnitity:@"Book" Managed:NO Predicate:nil Sorts:nil FetchLimit:0 Expressions:nil];
    
    dataArray = [[NSMutableArray alloc] initWithArray:books];
    
    [self.bookListTable reloadData];
}


-(void)addAction{

    BookDetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"BookDetailsViewControllerID"];
    [self.navigationController pushViewController:details animated:YES];
}

-(void)logout{
    
    self.passProfile.isLogin = @(0);
    DataModel *dm = [[DataModel alloc] init];
    
    BOOL modified =  [dm modifyData:self.passProfile Entity:@"Profile" Predicate:nil];
    NSLog(@"Saved %d", modified);
    
    if (modified){
        LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerID"];
        [self.navigationController setViewControllers:@[login]];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EBook *book =  [dataArray objectAtIndex:indexPath.row];
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookTableViewCellID"];
    cell.nameLabel.text = book.bookName;
    cell.priceLabel.text = book.price.stringValue;
    NSData *data = book.image;
    
    if (data){
        cell.coverImageView.image = [[UIImage alloc] initWithData:data];
    }
    else {
        cell.coverImageView.image = [UIImage imageNamed:@"placeholder.png"];
    }
    
    cell.textLabel.numberOfLines = 0;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EBook *book =  [dataArray objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BookDetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"BookDetailsViewControllerID"];
    details.passBook = book;
    [self.navigationController pushViewController:details animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//        EBook *profile =  [dataArray objectAtIndex:indexPath.row];
//        NSPredicate *pred = [NSPredicate predicateWithFormat:@"userID=%@",profile.userID];
//
//        DataModel *dm = [[DataModel alloc] init];
//        BOOL deleted = [dm deleteDataWithEnitity:@"Profile" Predicate:pred];
//
//        if (deleted){
//            [dataArray removeObjectAtIndex:indexPath.row];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//        }
//    }
    
    
}

@end
