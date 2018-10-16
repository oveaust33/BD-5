//
//  AppDelegate.h
//  BD
//
//  Created by User on 10/10/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EProfile.h"
#import "DataModel.h"
#import "HomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property ( strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property ( strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property ( strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property ( strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property ( strong, nonatomic) NSManagedObjectContext *writerManagedObjectContext;

+(AppDelegate *)shared;


@end

