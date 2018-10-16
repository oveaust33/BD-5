//
//  Profile+CoreDataProperties.h
//  BD
//
//  Created by digicon on 10/15/18.
//  Copyright © 2018 Digicon. All rights reserved.
//
//

#import "Profile+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Profile (CoreDataProperties)

+ (NSFetchRequest<Profile *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSNumber *isLogin;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSNumber *userID;
@property (nullable, nonatomic, retain) NSSet<Book *> *books;

@end

@interface Profile (CoreDataGeneratedAccessors)

- (void)addBooksObject:(Book *)value;
- (void)removeBooksObject:(Book *)value;
- (void)addBooks:(NSSet<Book *> *)values;
- (void)removeBooks:(NSSet<Book *> *)values;

@end

NS_ASSUME_NONNULL_END
