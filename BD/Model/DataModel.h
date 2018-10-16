

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "EProfile.h"
#import "Profile+CoreDataProperties.h"
#import "EBook.h"
#import "Book+CoreDataProperties.h"


@interface DataModel : NSObject{
    

}

@property (strong, nonatomic) id data;
@property BOOL isSuccess;
@property NSArray*fetchedData;



- (BOOL)insertBook:(EBook*)entityObject;

-(long)rowCountForEntity:(NSString*)entity;


// Common CRUD

-(BOOL)modifyData:(NSObject*)eObject Entity:(NSString*)entity Predicate:(NSPredicate*)predicate;

- (BOOL)insertDataArray:(NSArray*)entityObjects Entity:(NSString*)entityName;

-(void)getDataWithEnitity:(NSString*)entity Managed:(BOOL)managed Predicate:(NSPredicate*)predicate Sorts:(NSArray*)sorts FetchLimit:(int)fetch Expressions:(NSArray*)exprs completion:(void (^)(NSArray* data))completion;

-(NSArray*)getDataWithEnitity:(NSString*)entity Managed:(BOOL)managed Predicate:(NSPredicate*)predicate Sorts:(NSArray*)sorts FetchLimit:(int)fetch Expressions:(NSArray*)exprs;


-(void)deleteDataWithEnitity:(NSString*)entity Predicate:(NSPredicate*)predicate completion:(void (^)(BOOL deleted))completion;
-(BOOL)deleteDataWithEnitity:(NSString*)entity Predicate:(NSPredicate*)predicate;



-(void)updateDataWithEnitity:(NSString*)entityName Predicate:(NSPredicate*)predicate UpdateKey:(NSString*)updateKey UpdatedValue:(id)updatedValue completion:(void (^)(BOOL updated))completion;

-(BOOL)updateDataWithEnitity:(NSString*)entityName Predicate:(NSPredicate*)predicate UpdateKey:(NSString*)updateKey UpdatedValue:(id)updatedValue;

-(void)updateDataWithEnitity:(NSString*)entity EntityObject:(NSObject*)entityObject Predicate:(NSPredicate*)predicate completion:(void (^)(BOOL updated))completion;

-(BOOL)updateDataWithEnitity:(NSString*)entity EntityObject:(NSObject*)entityObject Predicate:(NSPredicate*)predicate;

-(void)saveContextOnlyWithCompletion:(void (^)(BOOL success, NSError *error))completion;

@end
