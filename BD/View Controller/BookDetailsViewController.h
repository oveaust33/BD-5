//
//  BookDetailsViewController.h
//  BD
//
//  Created by maclab on 10/15/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBook.h"
#import "DataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookDetailsViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (strong, nonatomic)  EBook *passBook;

@end

NS_ASSUME_NONNULL_END
