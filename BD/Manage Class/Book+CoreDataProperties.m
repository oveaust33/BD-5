//
//  Book+CoreDataProperties.m
//  BD
//
//  Created by digicon on 10/15/18.
//  Copyright © 2018 Digicon. All rights reserved.
//
//

#import "Book+CoreDataProperties.h"

@implementation Book (CoreDataProperties)

+ (NSFetchRequest<Book *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Book"];
}

@dynamic bookName;
@dynamic ratting;
@dynamic writter;
@dynamic price;
@dynamic image;
@dynamic uid;
@dynamic profile;

@end
