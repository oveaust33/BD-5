//
//  EProfile.h
//  BD
//
//  Created by Admin on 10/10/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EProfile : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *userID;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSNumber *isLogin;
@end

NS_ASSUME_NONNULL_END
