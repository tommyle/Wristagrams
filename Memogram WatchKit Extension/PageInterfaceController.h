//
//  PageInterfaceController.h
//  Wristagrams
//
//  Created by admin on 2015-05-24.
//  Copyright (c) 2015 Kodemine. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "CoreDataStack.h"

@interface PageInterfaceController : WKInterfaceController

@property (strong, nonatomic) CoreDataStack *coreDataStack;

@end
