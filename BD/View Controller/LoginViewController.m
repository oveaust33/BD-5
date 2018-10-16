//
//  LoginViewController.m
//  BD
//
//  Created by maclab on 10/15/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "EProfile.h"
#import "DataModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Login";
}

- (IBAction)loginAction:(id)sender {
    
    DataModel *dm = [[DataModel alloc] init];
    NSArray *profiles =  [dm getDataWithEnitity:@"Profile" Managed:NO Predicate:nil Sorts:nil FetchLimit:0 Expressions:nil];
    
    if (profiles.count > 0){
        EProfile *profile = profiles.firstObject;
        
        if ([profile.email isEqualToString:self.emailTextFiled.text] && [profile.password isEqualToString:self.passwordTextFiled.text]){
            
            profile.isLogin = @(1);
            
            BOOL updated = [dm modifyData:profile Entity:@"Profile" Predicate:nil];
            NSLog(@"upd %d", updated);
            
            HomeViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewControllerID"];
            home.passProfile = profile;
            [self.navigationController pushViewController:home animated:YES];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                            message:@"Given email or password is not correct"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Please sign up first"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
}

- (IBAction)signupAction:(id)sender {
    RegistrationViewController *reg = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewControllerID"];
    
    [self.navigationController pushViewController:reg animated:YES];
}

- (IBAction)forgetAction:(id)sender {
    
}




@end
