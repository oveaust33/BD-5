//
//  BookDetailsViewController.m
//  BD
//
//  Created by maclab on 10/15/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import "BookDetailsViewController.h"

@interface BookDetailsViewController ()

@end

@implementation BookDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickImage)];
    [self.coverImageView setUserInteractionEnabled:YES];
    [self.coverImageView addGestureRecognizer:tap];
    
    if (self.passBook != nil){
        self.titleTextField.text = self.passBook.bookName;
        self.priceTextField.text = self.passBook.price.stringValue;
       
        NSData *data = self.passBook.image;
        
        if (data){
            self.coverImageView.image = [[UIImage alloc] initWithData:data];
        }
        else {
            self.coverImageView.image = [UIImage imageNamed:@"placeholder.png"];
        }
    }
}

- (IBAction)submitAction:(id)sender {

    NSData *data = UIImagePNGRepresentation(self.coverImageView.image);

    BOOL insert = NO;
    
    if (self.passBook == nil){
        self.passBook  = [[EBook alloc] init];
        insert = YES;
    }
    
    self.passBook.bookName = self.titleTextField.text;
    self.passBook.price = @([self.priceTextField.text floatValue]);
    self.passBook.image = data;
    
    DataModel *dm = [[DataModel alloc] init];
    BOOL saved = NO;
    
    if (insert){
        self.passBook.uid = [[NSUUID UUID] UUIDString];
        saved  = [dm insertBook:self.passBook];
    }
    else {
        NSPredicate *pred  = [NSPredicate predicateWithFormat:@"uid=%@", self.passBook.uid];
        saved  =[dm modifyData:self.passBook Entity:@"Book" Predicate:pred];
    }
    
    if (saved){
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}

-(void)pickImage{
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;

        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:true completion:nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.coverImageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
