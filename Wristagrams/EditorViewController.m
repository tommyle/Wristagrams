//
//  EditorViewController.m
//  Wristagrams
//
//  Created by admin on 2015-05-17.
//  Copyright (c) 2015 Kodemine. All rights reserved.
//

#import "EditorViewController.h"
#import "UIColor+Custom.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface EditorViewController () {
    AppDelegate *_delegate;
    NSMutableArray *_toolbarItems;
    UIImage *_selectedImage;
}

@end

@implementation EditorViewController

@synthesize cell;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor dayOneBlue];
        self.navigationController.navigationBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor dayOneBlue];
    }
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(done)];
    [[self navigationItem] setRightBarButtonItem: doneButton];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(cancel)];
    [[self navigationItem] setLeftBarButtonItem: cancelButton];
    
    self.view.backgroundColor = [UIColor bluishBlack];
    
    _mainTextView.backgroundColor = [UIColor bluishBlack];
    _mainTextView.textColor = [UIColor whiteColor];
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    //Transparent toolbar
    [keyboardToolbar setBackgroundImage:[UIImage new]
                   forToolbarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [keyboardToolbar setShadowImage:[UIImage new]
               forToolbarPosition:UIToolbarPositionAny];
    
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btnCamera setFrame:CGRectMake(0, 0, 35, 35)];
    [btnCamera setFrame:CGRectMake(0, 0, 66, 32)];
    btnCamera.alpha = 0.25;
    
    //UIImage *imageCamera = [UIImage imageNamed: @"camera3.png"];
    UIImage *imageCamera = [UIImage imageNamed: @"camera4.png"];
    [btnCamera setBackgroundImage:imageCamera forState:UIControlStateNormal];
    [btnCamera addTarget:self action:@selector(btnCameraPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //button border
    CAShapeLayer *buttonBorder = [CAShapeLayer layer];
    buttonBorder.strokeColor = [UIColor paleTan].CGColor;
    buttonBorder.fillColor = nil;
    //buttonBorder.lineDashPattern = @[@1, @2];
    buttonBorder.path = [UIBezierPath bezierPathWithRect:btnCamera.bounds].CGPath;
    buttonBorder.frame = CGRectMake(btnCamera.bounds.origin.x, btnCamera.bounds.origin.y, btnCamera.bounds.size.height, btnCamera.bounds.size.width);
    buttonBorder.cornerRadius = 10;
    buttonBorder.opacity = 0.3;
    //buttonBorder.borderWidth = 1;
    [btnCamera.layer addSublayer:buttonBorder];
    
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithCustomView:btnCamera];
    
    _toolbarItems = [NSMutableArray arrayWithObjects: flexibleSpace, cameraItem, flexibleSpace, nil];
    
    keyboardToolbar.items = _toolbarItems;
    [keyboardToolbar sizeToFit];
    
    //add a dashed border
    /*
    CAShapeLayer *toolbarBorder = [CAShapeLayer layer];
    toolbarBorder.strokeColor = [UIColor paleBlack].CGColor;
    toolbarBorder.fillColor = nil;
    toolbarBorder.lineDashPattern = @[@2, @2];
    toolbarBorder.path = [UIBezierPath bezierPathWithRect:keyboardToolbar.bounds].CGPath;
    toolbarBorder.frame = CGRectMake(keyboardToolbar.bounds.origin.x, keyboardToolbar.bounds.origin.y - 1, keyboardToolbar.bounds.size.height + 1, keyboardToolbar.bounds.size.width);
    [keyboardToolbar.layer addSublayer:toolbarBorder];
     */
    
    _mainTextView.inputAccessoryView = keyboardToolbar;
    
    [self resetController];
    
    [self observeKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.0];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [_mainTextView becomeFirstResponder];
    [UIView commitAnimations];
}

- (void)done
{
    // Save image if one was selected
    NSString *tmpPathToFile = nil;
    NSString *uniqueName = [NSString stringWithFormat:@"%@-%lu", @"pic", (unsigned long)([[NSDate date] timeIntervalSince1970]*10.0)];
    
    if (_selectedImage != nil) {
        NSData *imageData = UIImageJPEGRepresentation(_selectedImage, 1.0);
        
        NSURL *groupURL = [[NSFileManager defaultManager]
                           containerURLForSecurityApplicationGroupIdentifier:
                           @"group.memogram"];
        NSString *path = groupURL.path;
        
        tmpPathToFile = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@.jpg", path, uniqueName]];
        
        if([imageData writeToFile:tmpPathToFile atomically:YES]){
            //Write was successful.
        }
    }
    
    
    //This is true when:
    // - If there is an existing image and it was removed... _selectedImage would be nil
    // - If there was an existing image and it was replaced... _selected image would not be nil
    if (cell.image != nil) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:cell.image error:&error];
        if (!success) {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
    }
    
    if (cell == nil) {
        [_delegate.viewController addItem: _mainTextView.text withImagePath:tmpPathToFile];
    }
    else {
        //need to delete image if it was changed?
        [_delegate.viewController updateItem: cell withText:_mainTextView.text withImagePath:tmpPathToFile];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [_mainTextView resignFirstResponder];
    [UIView commitAnimations];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel
{
    //[self.menuTableViewController.tableView reloadData];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [_mainTextView resignFirstResponder];
    [UIView commitAnimations];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnCameraPressed:(UIButton*)button
{
    if (_selectedImage) {
        
        UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
        actionSheet.delegate = self;
        [actionSheet addButtonWithTitle:@"Remove Photo"];
        [actionSheet addButtonWithTitle:@"Choose Another Photo"];
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
        
        //[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
        
        //actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [actionSheet showFromBarButtonItem:self.navigationItem.backBarButtonItem animated:YES];
        } else {
            [actionSheet showFromToolbar:self.navigationController.toolbar];
        }
    }
    else {
        [self imagePicker];
    }
    
    //_imageBotConstraint.constant = 800;
   // _textViewTopConstraint.constant = 20;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Remove Photo"]) {
        _selectedImage = nil;
        [self setToolbarImage:_selectedImage];
    }
    else if ([buttonTitle isEqualToString:@"Choose Another Photo"]) {
        [self imagePicker];
    }
}

- (UIImage *)crop:(CGRect)rect withImage:(UIImage *)image {
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:0.0f orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return result;
}

- (UIImage*)scale: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)resizeImage:(UIImage*)sourceImage scaledToWidth:(float)i_width {
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    CGSize newSize = CGSizeMake(newWidth,newHeight);
    
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newWidth, newHeight));
    CGImageRef imageRef = sourceImage.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

// The callback for frame-changing of keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGFloat height = keyboardFrame.size.height + 5;
    
    NSLog(@"Updating constraints.");
    // Because the "space" is actually the difference between the bottom lines of the 2 views,
    // we need to set a negative constant value here.
    self.keyboardHeight.constant = height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.keyboardHeight.constant = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) imagePicker
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                 init];
    pickerController.delegate = self;
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        pickerController.navigationBar.barTintColor = [UIColor dayOneBlue];
        pickerController.navigationBar.translucent = NO;
        pickerController.navigationBar.tintColor = [UIColor whiteColor];
    }else {
        // iOS 6.1 or earlier
        pickerController.navigationBar.tintColor = [UIColor dayOneBlue];
    }
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
    _selectedImage = image;
    [self setToolbarImage: image];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void) setToolbarImage:(UIImage*)image
{
    UIToolbar *keyboardToolbar = (UIToolbar*)_mainTextView.inputAccessoryView;
    UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCamera setFrame:CGRectMake(0, 0, 66, 32)];
    btnCamera.alpha = 0.25;
    
    UIImage *imageCamera = [UIImage imageNamed: @"camera4.png"];
    UIImage *mergedImage;
    
    if (image != nil) {
        UIImage *scaledImage = [self scale:image scaledToWidth:66];
        UIImage *croppedImage = [self crop:CGRectMake(0, btnCamera.bounds.size.height / 4, btnCamera.bounds.size.width, btnCamera.bounds.size.height) withImage:scaledImage];
        
        //overlay
        UIGraphicsBeginImageContextWithOptions(croppedImage.size, NO, 0.0f);
        [croppedImage drawInRect:CGRectMake(0, 0, croppedImage.size.width, croppedImage.size.height)];
        [imageCamera drawInRect:CGRectMake(0, 0, imageCamera.size.width, imageCamera.size.height)];
        mergedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else {
        mergedImage = imageCamera;
    }
    
    [btnCamera setBackgroundImage:mergedImage forState:UIControlStateNormal];
    [btnCamera addTarget:self action:@selector(btnCameraPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //button border
    CAShapeLayer *buttonBorder = [CAShapeLayer layer];
    buttonBorder.strokeColor = [UIColor paleTan].CGColor;
    buttonBorder.fillColor = nil;
    //buttonBorder.lineDashPattern = @[@1, @2];
    buttonBorder.path = [UIBezierPath bezierPathWithRect:btnCamera.bounds].CGPath;
    buttonBorder.frame = CGRectMake(btnCamera.bounds.origin.x, btnCamera.bounds.origin.y, btnCamera.bounds.size.height, btnCamera.bounds.size.width);
    buttonBorder.cornerRadius = 10;
    buttonBorder.opacity = 0.3;
    
    [btnCamera.layer addSublayer:buttonBorder];
    
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithCustomView:btnCamera];
    
    [_toolbarItems replaceObjectAtIndex:1 withObject:cameraItem];
    
    keyboardToolbar.items = _toolbarItems;
}

- (void) resetController {
    _selectedImage = nil;
    
    if (self.cell != nil) {
        _mainTextView.text = self.cell.text;
        
        if (self.cell.image != nil) {
            NSData *imageData = [NSData dataWithContentsOfFile:cell.image];
            _selectedImage = [UIImage imageWithData:imageData];
        }
    }
    else {
        _mainTextView.text = @"";
    }
    
    [self setToolbarImage:_selectedImage];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //Fixes issue with image picker causing the status bar text to go black
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
