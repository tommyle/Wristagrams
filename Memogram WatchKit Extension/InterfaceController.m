//
//  InterfaceController.m
//  Memogram WatchKit Extension
//
//  Created by admin on 2015-05-20.
//  Copyright (c) 2015 Kodemine. All rights reserved.
//

#import "InterfaceController.h"
#import "CoreDataStack.h"
#import "PageInterfaceController.h"

@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceImage *image;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *label;

@end


@implementation InterfaceController {
    NSMutableArray *_currentData;
}

- (id)init {
    self = [super init];
    if (self) {
        self.coreDataStack = [[CoreDataStack alloc] init];
        
        _currentData = [self.coreDataStack getCellData];
        
        [WKInterfaceController reloadRootControllersWithNames:@[@"PageInterfaceController", @"PageInterfaceController"] contexts:@[_currentData, _currentData]];
    }
    return self;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    /*
    NSArray  *pages = [[NSArray alloc] initWithObjects:@"PageInterfaceController1",@"PageInterfaceController1", nil];
    NSArray *contexts = [[NSArray alloc] initWithObjects: nil];
    
    [self presentControllerWithNames:pages contexts:contexts];
     */
    
    /*
    PageInterfaceController *p = [[PageInterfaceController alloc] init];
    
    [self presentControllerWithName:@"PageInterfaceController1" context:nil];
     */
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



