//
//  PageInterfaceController.m
//  Wristagrams
//
//  Created by admin on 2015-05-24.
//  Copyright (c) 2015 Kodemine. All rights reserved.
//

#import "PageInterfaceController.h"
#import "CoreDataStack.h"
#import "Cell.h"

@interface PageInterfaceController ()
@property (weak, nonatomic) IBOutlet WKInterfaceImage *image;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *label;

@end

@implementation PageInterfaceController {
    NSMutableArray *_currentData;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    //self.title = @"";
    
    self.coreDataStack = [[CoreDataStack alloc] init];
    _currentData = context;
}

/*
- (id)init {
    if ((self =[super init]))
    {
        self.title = @"";
    }
    
    return self;
}
 */

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    Cell *c = (Cell*)[_currentData objectAtIndex:0];
    NSData *imageData = [NSData dataWithContentsOfFile:c.image];
    UIImage *img = [UIImage imageWithData:imageData];
    
    [_image setImage:img];
    _label.text = c.text;
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



