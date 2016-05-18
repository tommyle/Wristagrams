//
//  InterfaceController.h
//  Memogram WatchKit Extension
//
//  Created by admin on 2015-05-20.
//  Copyright (c) 2015 Kodemine. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "CoreDataStack.h"

@interface InterfaceController : WKInterfaceController

@property (strong, nonatomic) CoreDataStack *coreDataStack;

@end
