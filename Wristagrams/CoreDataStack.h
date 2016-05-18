//
//  CoreDataStack.h
//  Wristagrams
//
//  Created by admin on 2015-05-21.
//  Copyright (c) 2015 Kodemine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Settings.h"
#import "Cell.h"

@interface CoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (Cell*)createCell:(NSString*)text withImagePath:(NSString*)imagePath;
- (void)deleteCell:(Cell*)cell;
- (NSMutableArray*)getCellData;
- (void)exchangeIndex:(Cell*)cell1 withCell:(Cell*)cell2;

@end
