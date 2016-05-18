//
//  ViewController.h
//  Wristagrams
//
//  Created by admin on 2015-05-16.
//  Copyright (c) 2015 Kodemine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"

@interface ViewController : UIViewController

- (void)addItem:(NSString*)itemText withImagePath:(NSString*)imagePath;
- (void)updateItem:(Cell*)cell withText:(NSString*)text withImagePath:(NSString*)imagePath;
- (int)getCurrentDataCount;

@end