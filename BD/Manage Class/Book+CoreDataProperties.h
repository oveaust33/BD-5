//
//  Book+CoreDataProperties.h
//  BD
//
//  Created by digicon on 10/15/18.
//  Copyright © 2018 Digicon. All rights reserved.
//
//

#import "Book+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Book (CoreDataProperties)

+ (NSFetchRequest<Book *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bookName;
@property (nullable, nonatomic, copy) NSNumber *ratting;
@property (nullable, nonatomic, copy) NSString *writter;
@property (nullable, nonatomic, copy) NSNumber *price;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, copy) NSString *uid;
@property (nullable, nonatomic, retain) Profile *profile;

@end

NS_ASSUME_NONNULL_END
