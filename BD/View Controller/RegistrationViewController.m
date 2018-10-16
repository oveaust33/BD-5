//
//  RegistrationViewController.m
//  BD
//
//  Created by maclab on 10/15/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import "RegistrationViewController.h"
#import "DataModel.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.passProfile){
        self.nameTextFiled.text = self.passProfile.name;
        self.emailTextFiled.text = self.passProfile.email;
        self.passwordTextFiled.text = self.passProfile.password;
    }
    else {
        
    }
  
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Logout"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = flipButton;
    
    self.title = @"Registration";

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

- (IBAction)signupAction:(id)sender {
    
    self.passProfile  = [[EProfile alloc] init];
    self.passProfile.name = self.nameTextFiled.text;
    self.passProfile.email = self.emailTextFiled.text;
    self.passProfile.password = self.passwordTextFiled.text;
    self.passProfile.userID = @(10);
    
    DataModel *dm = [[DataModel alloc] init];
    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userID=%@",prof.userID];
    
    //   BOOL inserted =  [dm insertDataArray:@[prof] Entity:@"Profile"];
    
    BOOL modified =  [dm modifyData:self.passProfile Entity:@"Profile" Predicate:nil];
    NSLog(@"Saved %d", modified);
    
    if (modified){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        // show error alert
    }
}


@end
