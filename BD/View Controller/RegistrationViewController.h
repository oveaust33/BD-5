//
//  RegistrationViewController.h
//  BD
//
//  Created by maclab on 10/15/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EProfile.h"
#import "LoginViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegistrationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *emailTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;
@property (strong, nonatomic) EProfile *passProfile;

@end

NS_ASSUME_NONNULL_END
