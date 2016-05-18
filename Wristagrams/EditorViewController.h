//
//  EditorViewController.h
//  Wristagrams
//
//  Created by admin on 2015-05-17.
//  Copyright (c) 2015 Kodemine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"

@interface EditorViewController : UIViewController <UIActionSheetDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;
@property (weak, nonatomic) Cell *cell;

- (void) resetController;

@end
