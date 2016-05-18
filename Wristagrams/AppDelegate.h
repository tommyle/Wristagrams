//
//  AppDelegate.h
//  Wristagrams
//
//  Created by admin on 2015-05-16.
//  Copyright (c) 2015 Kodemine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ViewController.h"
#import "EditorViewController.h"
#import "CoreDataStack.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) EditorViewController *editorViewController;
@property (strong, nonatomic) CoreDataStack *coreDataStack;

@end

