//
//  Profile+CoreDataProperties.m
//  BD
//
//  Created by digicon on 10/15/18.
//  Copyright © 2018 Digicon. All rights reserved.
//
//

#import "Profile+CoreDataProperties.h"

@implementation Profile (CoreDataProperties)

+ (NSFetchRequest<Profile *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Profile"];
}

@dynamic email;
@dynamic isLogin;
@dynamic name;
@dynamic password;
@dynamic userID;
@dynamic books;

@end
