

#import "DataModel.h"

@implementation DataModel

#pragma mark- Commmon CRUD Operation

#pragma mark- Modify Data




- (BOOL)insertBook:(EBook*)entityObject{
    BOOL success=NO;
    
    @try {
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Book" inManagedObjectContext:context];
        Book *book = (Book*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        book=[self GetManagedObejectWithManagedObject:book FromEntityObject:entityObject];
        
        NSArray *profiles  =[self getDataWithEnitity:@"Profile" Managed:YES Predicate:nil Sorts:nil FetchLimit:0 Expressions:nil];
        Profile *prof;
        
        if (profiles.count>0){
            prof = profiles.firstObject;
            [prof addBooksObject:book];
        }
        
        NSError *error;
        
        if (![context save:&error]) {
            
        } else {
            success=YES;
            
        }
        
    } @catch (NSException *exception) {
        NSLog(@"excp %@", exception);
    }
    
    return success;
}



// Update if exist (by given predicate), otherwise insert

-(long)rowCountForEntity:(NSString*)entity{
    NSManagedObjectContext *context = [self managedObjectContext];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:context]];
    
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSUInteger count = [context countForFetchRequest:request error:&err];
  
    if(count == NSNotFound) {
        return 0;
    }

    return (long)count;
}


-(BOOL)modifyData:(NSObject*)eObject Entity:(NSString*)entity Predicate:(NSPredicate*)predicate{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSArray*objects= [self getDataWithEnitity:entity Managed:YES Predicate:predicate Sorts:nil FetchLimit:0 Expressions:nil Context:context];
    
    if(objects.count){
        NSManagedObject*object=objects.firstObject;
        object=[self GetManagedObejectWithManagedObject:object FromEntityObject:eObject];
        
        
        NSError *error;
        if (![context save:&error]) {
            return NO;
        } else {
            return YES;
            
        }
    }
    else{
        return [self insertDataArray:@[eObject] Entity:entity];
    }
}


#pragma mark- Insert Data

- (BOOL)insertDataArray:(NSArray*)entityObjects Entity:(NSString*)entityName{
    BOOL success=NO;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for(NSObject*entityObj in entityObjects){
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        NSManagedObject*managedObject = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        managedObject=[self GetManagedObejectWithManagedObject:managedObject FromEntityObject:entityObj];
    }
    
    NSError *error;
    
    if (![context save:&error]) {
   
    } else {
        success=YES;
        
    }
    
    return success;
}

#pragma mark- Get Data

//N.B: Sort will not work to fetch attribute

-(void)getDataWithEnitity:(NSString*)entity Managed:(BOOL)managed Predicate:(NSPredicate*)predicate Sorts:(NSArray*)sorts FetchLimit:(int)fetch Expressions:(NSArray*)exprs completion:(void (^)(NSArray* data))completion{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if(completion){
        
        [context performBlock:^{
            
            NSArray *dataArray=[self getDataWithEnitity:entity Managed:managed Predicate:predicate Sorts:sorts FetchLimit:fetch Expressions:exprs Context:context];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(dataArray);
            });
            
        }];
        
    }
    else{
        NSArray *dataArray=[self getDataWithEnitity:entity Managed:managed Predicate:predicate Sorts:sorts FetchLimit:fetch Expressions:exprs Context:context];
        _fetchedData=[[NSArray alloc] initWithArray:dataArray];
    }
}


-(NSArray*)getDataWithEnitity:(NSString*)entity Managed:(BOOL)managed Predicate:(NSPredicate*)predicate Sorts:(NSArray*)sorts FetchLimit:(int)fetch Expressions:(NSArray*)exprs{
    
    return  [self getDataWithEnitity:entity Managed:managed Predicate:predicate Sorts:sorts FetchLimit:fetch Expressions:exprs Context:[self managedObjectContext]];
    
}

-(NSArray*)getDataWithEnitity:(NSString*)entity Managed:(BOOL)managed Predicate:(NSPredicate*)predicate Sorts:(NSArray*)sortDescriptors FetchLimit:(int)fetchLimit Expressions:(NSArray*)expressions Context:(NSManagedObjectContext*)context{
    
    @try {
        
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDes = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
        [fetchRequest setEntity:entityDes];
        
        if(predicate)
            [fetchRequest setPredicate:predicate];
        
        
        if(expressions.count){
            fetchRequest.resultType = NSDictionaryResultType;
            fetchRequest.propertiesToFetch = expressions;
        }
        else{
            if(sortDescriptors.count){
                [fetchRequest setSortDescriptors:sortDescriptors];
            }
            
            [fetchRequest setFetchLimit:fetchLimit];
        }
        
        
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        if(fetchedObjects.count){
            if([[fetchedObjects firstObject] isKindOfClass:[NSManagedObject class]]){
                
                if(managed){
                    [dataArray addObjectsFromArray:fetchedObjects];
                }
                else{
                    for (NSManagedObject *obj in fetchedObjects){
                        
                        id eobj = [self GetEntityObjectFromManagedObeject:obj];
                        
                        if(eobj){
                            [dataArray addObject:eobj];
                        }
                    }
                }
            }
            else{
                [dataArray addObjectsFromArray:fetchedObjects];
            }
        }
        
        return dataArray;

    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    } @finally {
        
    }
    
}



#pragma mark- Delete Data


-(void)deleteDataWithEnitity:(NSString*)entity Predicate:(NSPredicate*)predicate completion:(void (^)(BOOL deleted))completion{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if(completion){
        
        [context performBlock:^{
            
            BOOL isDeleted=[self deleteDataWithEnitity:entity Predicate:predicate Context:context];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(isDeleted);
            });
            
        }];
        
    }
    else{
        _isSuccess=[self deleteDataWithEnitity:entity Predicate:predicate Context:context];
    }
}


-(BOOL)deleteDataWithEnitity:(NSString*)entity Predicate:(NSPredicate*)predicate{
    
    return  [self deleteDataWithEnitity:entity Predicate:predicate Context:[self managedObjectContext]];
    
}

-(BOOL)deleteDataWithEnitity:(NSString*)entity Predicate:(NSPredicate*)predicate Context:(NSManagedObjectContext*)context{
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDes = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    [fetchRequest setEntity:entityDes];
    
    if(predicate)
        [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if(fetchedObjects.count){
        for(id obj in fetchedObjects)
            [context deleteObject:obj];
    }
    else{
        return YES;
    }
    
    if (![context save:&error]){

        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark- Update Data

// Update Entitiy(s): (all attribute) by given predicate
// As Async operation

-(void)updateDataWithEnitity:(NSString*)entity EntityObject:(NSObject*)entityObject Predicate:(NSPredicate*)predicate completion:(void (^)(BOOL updated))completion{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if(completion){
        
        [context performBlock:^{
            
            BOOL isupdated=[self updateDataWithEnitity:entity EntityObject:entityObject Predicate:predicate Context:context];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(isupdated);
            });
            
        }];
        
    }
    else{
        _isSuccess=[self updateDataWithEnitity:entity EntityObject:entityObject Predicate:predicate Context:context];
    }
}


// Update Entitiy(s): (all attribute) by given predicate

-(BOOL)updateDataWithEnitity:(NSString*)entity EntityObject:(NSObject*)entityObject Predicate:(NSPredicate*)predicate{
    
    return  [self updateDataWithEnitity:entity EntityObject:entityObject Predicate:predicate Context:[self managedObjectContext]];
    
}


-(BOOL)updateDataWithEnitity:(NSString*)entityName EntityObject:(NSObject*)entityObject Predicate:(NSPredicate*)predicate Context:(NSManagedObjectContext*)context{
    
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    

    
    if([fetchedObjects count]){
        
        for(NSManagedObject* object in fetchedObjects){
            
            NSManagedObject*mObject=object;
            
//            mObject=[Mapper GetManagedObejectWithManagedObject:mObject FromEntityObject:entityObject];
        }
    }
    else{
        return NO;
    }
    
    if (![context save:&error]){

        return NO;
    }
    else{
        return YES;
    }
    
}

// Update Entitiy(s): specific attribute by given predicate and value
// As Async operation

-(void)updateDataWithEnitity:(NSString*)entityName Predicate:(NSPredicate*)predicate UpdateKey:(NSString*)updateKey UpdatedValue:(id)updatedValue completion:(void (^)(BOOL updated))completion{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if(completion){
        
        [context performBlock:^{
            
            BOOL isupdated=[self updateDataWithEnitity:entityName Predicate:predicate UpdateKey:updateKey UpdatedValue:updatedValue Context:[self managedObjectContext]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(isupdated);
            });
            
        }];
        
    }
    else{
        _isSuccess=[self updateDataWithEnitity:entityName Predicate:predicate UpdateKey:updateKey UpdatedValue:updatedValue Context:[self managedObjectContext]];
    }
}


// Update Entitiy(s): specific attribute by given predicate and value

-(BOOL)updateDataWithEnitity:(NSString*)entityName Predicate:(NSPredicate*)predicate UpdateKey:(NSString*)updateKey UpdatedValue:(id)updatedValue{
    
    return  [self updateDataWithEnitity:entityName Predicate:predicate UpdateKey:updateKey UpdatedValue:updatedValue Context:[self managedObjectContext]];
    
}


-(BOOL)updateDataWithEnitity:(NSString*)entityName Predicate:(NSPredicate*)predicate UpdateKey:(NSString*)updateKey UpdatedValue:(id)updatedValue Context:(NSManagedObjectContext*)context{
    
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    
    if([fetchedObjects count]){
        
        for(NSManagedObject* object in fetchedObjects){
            
            NSManagedObject*mObject=object;
            
            [mObject setValue:updatedValue forKey:updateKey];
            
        
        }
        
    }
    else{
        return NO;
    }
    
    if (![context save:&error]){

        return NO;
    }
    else{
        return YES;
    }
    
}


-(void)executeWithSelector:(SEL)selector Objects:(NSArray*)objects Completion:(void (^)(BOOL success))completion{
    
    if(completion){
        NSManagedObjectContext *contextBG = [self backgroundManagedObjectContext];
        
        [contextBG performBlock:^{
            
            if([self respondsToSelector:selector])
                [self performSelector:selector withObject:objects withObject:contextBG];
            
            else  if([self respondsToSelector:selector])
                [self performSelector:selector withObject:contextBG];
            
            [self saveInMultipleContextWithCompletion:^(BOOL success, NSError*error){
                _isSuccess=success;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(success);
                    
                    if(error){

                    }
                });
                
            }];
            
        }];
    }
    else{
        BOOL success=NO;
        NSManagedObjectContext *context= [self managedObjectContext];
        
        if([self respondsToSelector:selector])
            [self performSelector:selector withObject:objects withObject:context];
        
        else if([self respondsToSelector:selector])
            [self performSelector:selector withObject:context];
        
        NSError *error;
        if (![context save:&error]) {

        } else {
            success=YES;
        }
        
        _isSuccess=success;
    }
    
    
}


#pragma mark - Core Data stack


- (void)managedObjectContextDidSave:(NSNotification *)notification{
    NSLog(@"managedObjectContextDidSave");
    
    __block  BOOL success=NO;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    [context performBlockAndWait:^(){
        [context mergeChangesFromContextDidSaveNotification:notification];
        
        NSError *error;
        if (![context save:&error]) {
            
            //            [POSUtilities handleErrorException:error ViewClass:self Method:NSStringFromSelector(_cmd) ShowAlert:NO];
        } else {
            success=YES;
        }
        
        //        [self.delegate dataClassDidExecute:self BackGroundMessage:backGroundMessage Successfull:success];
        
    }];
    
    
}
- (void)saveContext{
    @try {
        
        NSError *error = nil;
        NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
        
        if (managedObjectContext != nil) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
    @catch (NSException *exception) {
        
        
    }
    @finally {
        
    }
}


-(void)saveContextOnlyWithCompletion:(void (^)(BOOL success, NSError *error))completion{
    
    NSManagedObjectContext *contextBG = [self backgroundManagedObjectContext];
    NSManagedObjectContext *contextMain = [self managedObjectContext];
    
    __block  NSError*  error = nil;
    
    if([contextBG hasChanges]){
        NSLog(@"< BG HAS CONTEXT CHNAGES >");
     
        if (![contextBG save:&error]){
            completion(NO,error);
            NSLog(@"< BG CONTEXT DIDN'T SAVE >");
        }
        else{
            NSLog(@"< BG CONTEXT SAVED >");

            if([contextMain hasChanges]){
                NSLog(@"< MAIN HAS CONTEXT CHNAGES >");

                [contextMain performBlock:^{
                    error=nil;
                    
                    if (![contextMain save:&error]){
                        completion(NO, error);
                        NSLog(@"< MAIN CONTEXT DIDN'T SAVE >");
                    }
                    else{
                        completion(YES, nil);
                        NSLog(@"< MAIN CONTEXT SAVED >");
                    }
                    
                }];
            }
            else{
                NSLog(@"< NO CHNAGES IN MAIN CONTEXT >");
            }
        }
    }
    else{
        
        NSLog(@"< NO CHNAGES IN BG CONTEXT >");

        if([contextMain hasChanges]){
            NSLog(@"< MAIN HAS CONTEXT CHNAGES >");
            
            [contextMain performBlock:^{
                error=nil;
                
                if (![contextMain save:&error]){
                    completion(NO, error);
                    NSLog(@"< MAIN CONTEXT DIDN'T SAVE >");
                }
                else{
                    completion(YES, nil);
                    NSLog(@"< MAIN CONTEXT SAVED >");
                }
                
            }];
        }
        else{
            NSLog(@"< NO CHNAGES IN MAIN CONTEXT >");
        }
    }
}


-(void)saveInMultipleContextWithCompletion:(void (^)(BOOL success, NSError *error))completion{
    
    NSManagedObjectContext *contextBG = [self backgroundManagedObjectContext];
    NSManagedObjectContext *contextMain = [self managedObjectContext];
    
    __block  NSError*  error = nil;
    
    if (![contextBG save:&error]){
        
        completion(NO,error);
    }
    else{
        [contextMain performBlock:^{
            error=nil;
            
            if (![contextMain save:&error]){
                completion(NO, error);
            }
            else{
                completion(YES, nil);
            }
            
        }];
        
    }
}



-(void)saveInMultiLevelBlock{
    
//    NSManagedObjectContext *contextWriter = [self writerManagedObjectContext];
    NSManagedObjectContext *contextBG = [self backgroundManagedObjectContext];
    NSManagedObjectContext *contextMain = [self managedObjectContext];
    
    
    __block  NSError*  error = nil;
//    __block BOOL success=NO;
    
    if (![contextBG save:&error]){
        
        
        //       (__block) dataToNil=nil;
        //        [contextWriter reset];
        //        [contextBG reset];
        //        [contextMain reset];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //            [self.delegate dataClassDidExecute:self BackGroundMessage:backGroundMessage Successfull:NO];
        });
    }
    else{
        [contextMain performBlock:^{
            error=nil;
            
            if (![contextMain save:&error]){
                
                
                //                dataToNil=nil;
                //                [contextWriter reset];
                //                [contextBG reset];
                //                [contextMain reset];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [self.delegate dataClassDidExecute:self BackGroundMessage:backGroundMessage Successfull:NO];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //                    [self.delegate dataClassDidExecute:self BackGroundMessage:backGroundMessage Successfull:YES];
                });
             
            }
            
            
        }];
        
    }
    
}



-(BOOL)resetDataStore{
    
    
    BOOL reset=[self resetApplicationModel];
    if (reset) {
        [self managedObjectContext];
    }
    return reset;
}

- (BOOL) resetApplicationModel{
    
    @try{
        BOOL resetOk = NO;
        AppDelegate *appDelegate=[AppDelegate shared];
        
        
        NSURL *storeURL = [[self applicationStoresDirectory] URLByAppendingPathComponent:@"DJDB.sqlite"];
        
        if (storeURL) {
            resetOk = YES;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtURL:storeURL error:NULL];
            NSError* error = nil;
            
            if([fileManager fileExistsAtPath:[NSString stringWithContentsOfURL:storeURL encoding:NSASCIIStringEncoding error:&error]])
            {
                [fileManager removeItemAtURL:storeURL error:nil];
            }
            
            NSManagedObjectContext *context=[self managedObjectContext];
            
            for (NSManagedObject *ct in [context registeredObjects]) {
                NSLog(@"managedObjectContext");
                [context deleteObject:ct];
            }
            
            appDelegate.managedObjectContext = nil;
            appDelegate.persistentStoreCoordinator = nil;
            
            
        }
        else{
            resetOk = NO;
            
        }
        return resetOk;
    }
    @catch (NSException *exception){
    }
    @finally {
        
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext{
    
    AppDelegate *appDelegate=[AppDelegate shared];
    
    
    if (appDelegate.managedObjectContext != nil) {
        return appDelegate.managedObjectContext;
    }
    
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        appDelegate.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        //        [appDelegate.managedObjectContext setParentContext:[self writerManagedObjectContext]];
        
        //        if(backGroundMessage){
        //            //            [appDelegate.managedObjectContext setParentContext:[self writerManagedObjectContext]];
        //        }
        //        else
        {
            [appDelegate.managedObjectContext setRetainsRegisteredObjects:YES];
            [appDelegate.managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    
    
    return appDelegate.managedObjectContext;
    
}

-(NSManagedObjectContext*)backgroundManagedObjectContext{
    
    AppDelegate *appDelegate=[AppDelegate shared];
    
    if (appDelegate.backgroundManagedObjectContext != nil) {
        return appDelegate.backgroundManagedObjectContext;
    }
    
    
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        
        appDelegate.backgroundManagedObjectContext= [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [appDelegate.backgroundManagedObjectContext setParentContext:[self managedObjectContext]];
        
        //        if(contextBG.persistentStoreCoordinator){
        //            NSLog(@"has coord");
        //
        //        }
        //        else{
        //            [contextBG setPersistentStoreCoordinator:coordinator];
        //            NSLog(@"coord nill");
        //        }
        
    }
    
    
    return appDelegate.backgroundManagedObjectContext;
}

-(NSManagedObjectContext*)writerManagedObjectContext{
    AppDelegate *appDelegate=[AppDelegate shared];
    
    if (appDelegate.writerManagedObjectContext != nil){
        return appDelegate.writerManagedObjectContext;
    }
    
    
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil){
        
        appDelegate.writerManagedObjectContext= [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        if(appDelegate.writerManagedObjectContext.persistentStoreCoordinator){
            NSLog(@"writer has coord");
            
        }
        else{
            [appDelegate.writerManagedObjectContext setPersistentStoreCoordinator:coordinator];
            NSLog(@"writer coord nill");
        }
        
        
    }
    
    
    return appDelegate.writerManagedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel{
    
    AppDelegate *appDelegate=[AppDelegate shared];
    
    if (appDelegate.managedObjectModel != nil) {
        return appDelegate.managedObjectModel;
    }
    
    
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DJDB" withExtension:@"momd"];
    
    
    if(modelURL){
        appDelegate.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    }
    else{
        appDelegate.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

    }
    
    
    return appDelegate.managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    
    @try{
        
        AppDelegate *appDelegate=[AppDelegate shared];
        
        if (appDelegate.persistentStoreCoordinator) {
            return appDelegate.persistentStoreCoordinator;
        }
        
        
        NSURL *storeURL = [[self applicationStoresDirectory] URLByAppendingPathComponent:@"DJDB.sqlite"];
        
        //    apple provided migration
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, @{@"journal_mode" : @"DELETE"}, NSSQLitePragmasOption,  nil];
        
        //NSDictionary *options2 = @{ NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"} };
        
        
        NSError *error = nil;
        appDelegate.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        if (![appDelegate.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            NSFileManager *fm = [NSFileManager defaultManager];
            
            // Move Incompatible Store
            if ([fm fileExistsAtPath:[storeURL path]]) {
                NSURL *corruptURL = [[self applicationIncompatibleStoresDirectory] URLByAppendingPathComponent:[self nameForIncompatibleStore]];
                
                // Move Corrupt Store
                NSError *errorMoveStore = nil;
                [fm moveItemAtURL:storeURL toURL:corruptURL error:&errorMoveStore];
                
                if (errorMoveStore) {
                    NSLog(@"Unable to move corrupt store.");
                }
            }
            
            NSError *errorAddingStore = nil;
            
            if (![appDelegate.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&errorAddingStore]) {
                
                NSLog(@"Unable to create persistent store after recovery. %@, %@", errorAddingStore, errorAddingStore.localizedDescription);
                
                // Show Alert View
                NSString *title = @"Warning";
                NSString *applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
                NSString *message = [NSString stringWithFormat:@"An error occurred while %@ tried to read your data. Please delete the app & install again or contact our customer service.", applicationName];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
                
            }
            else{
                NSLog(@"Data migration successfull.");
            }
            
            
            
        }
        
        
        return appDelegate.persistentStoreCoordinator;
        
    }
    @catch (NSException *exception){

    }
    @finally {
        
    }
}

- (NSURL *)applicationStoresDirectory {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *applicationApplicationSupportDirectory = [[fm URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *URL = [applicationApplicationSupportDirectory URLByAppendingPathComponent:@"Stores"];
    
    if (![fm fileExistsAtPath:[URL path]]) {
        NSError *error = nil;
        [fm createDirectoryAtURL:URL withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            NSLog(@"Unable to create directory for data stores.");
            
            return nil;
        }
    }
    
    return URL;
}

- (NSURL *)applicationIncompatibleStoresDirectory {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *URL = [[self applicationStoresDirectory] URLByAppendingPathComponent:@"Incompatible"];
    
    if (![fm fileExistsAtPath:[URL path]]) {
        NSError *error = nil;
        [fm createDirectoryAtURL:URL withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            NSLog(@"Unable to create directory for corrupt data stores.");
            
            return nil;
        }
    }
    
    return URL;
}

- (NSString *)nameForIncompatibleStore {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    
    return [NSString stringWithFormat:@"%@.sqlite", [dateFormatter stringFromDate:[NSDate date]]];
}


/*
 - (NSURL *)applicationDocumentsDirectory{
 return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
 }*/

-(id)GetEntityObjectFromManagedObeject:(id)managedObject{
    
    @try{
        NSObject* entityObject;
        
        if ([managedObject class]==[Profile class]) {
            Profile*obj=(Profile*)managedObject;
            EProfile*eObj=[[EProfile alloc]init];
            
            eObj.name=obj.name;
            eObj.email=obj.email;
            eObj.userID=obj.userID;
            eObj.password=obj.password;
            eObj.isLogin=obj.isLogin;

            entityObject=eObj;
        }
        else if ([managedObject class]==[Book class]) {
            Book*obj=(Book*)managedObject;
            EBook*eObj=[[EBook alloc]init];
            
            eObj.writter=obj.writter;
            eObj.bookName=obj.bookName;
            eObj.ratting=obj.ratting;
            eObj.price=obj.price;
            eObj.image=obj.image;
            eObj.uid=obj.uid;

            entityObject=eObj;
        }
        
        return entityObject;
    }
    @catch (NSException *exception){
        
    }
    @finally {
        
    }
    
}



-(id)GetManagedObejectWithManagedObject:(id)managedObject FromEntityObject:(id)entityObject{
    
    @try{
        
        NSManagedObject* managedObj;
        //
        if ([entityObject class]==[EProfile class]) {
            EProfile* eObj=(EProfile*)entityObject;
            Profile *obj=(Profile*)managedObject;
            
            obj.name=eObj.name;
            obj.email=eObj.email;
            obj.userID=eObj.userID;
            obj.password=eObj.password;
            obj.isLogin=eObj.isLogin;

            managedObj=obj;
        }
        
        else if ([entityObject class]==[EBook class]) {
            EBook* eObj=(EBook*)entityObject;
            Book *obj=(Book*)managedObject;
            
            obj.writter=eObj.writter;
            obj.bookName=eObj.bookName;
            obj.ratting=eObj.ratting;
            obj.price=eObj.price;
            obj.image=eObj.image;
            obj.uid=eObj.uid;

            managedObj=obj;
        }
        
        return managedObj;
        
    }
    @catch (NSException *exception){
        
    }
    @finally {
        
    }
    
    
}


@end
