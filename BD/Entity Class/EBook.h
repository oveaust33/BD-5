//
//  EBook.h
//  BD
//
//  Created by Admin on 10/13/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EBook : NSObject

@property (strong, nonatomic) NSString *bookName;
@property (strong, nonatomic) NSNumber *ratting;
@property (strong, nonatomic) NSString *writter;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSData *image;
@property (strong, nonatomic) NSString *uid;

@end

NS_ASSUME_NONNULL_END
