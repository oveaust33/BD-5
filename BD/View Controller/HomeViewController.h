//
//  HomeViewController.h
//  BD
//
//  Created by maclab on 10/15/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EProfile.h"
#import "DataModel.h"
#import "LoginViewController.h"
#import "BookDetailsViewController.h"
#import "EBook.h"
#import "BookTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *bookListTable;
@property (strong, nonatomic) EProfile *passProfile;

@end

NS_ASSUME_NONNULL_END
