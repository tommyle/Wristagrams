//
//  ViewController.m
//  Wristagrams
//
//  Created by admin on 2015-05-16.
//  Copyright (c) 2015 Kodemine. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"
#import "UIColor+Custom.h"
#import "EditorViewController.h"
#import "AppDelegate.h"

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark ViewController (privates methods)
//////////////////////////////////////////////////////////////

@interface ViewController () <GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
{
    __gm_weak GMGridView *_gmGridView;
    UINavigationController *_editorNav;
    
    NSMutableArray *_currentData;
    NSInteger _lastDeleteItemIndexAsked;
    AppDelegate *_delegate;
    UIColor *_borderColor;
    UIColor *_highlightColor;
}

- (void)enableEditMode;
- (void)refreshItem;
- (void)presentInfo;
- (void)presentOptions:(UIBarButtonItem *)barButton;
- (void)optionsDoneAction;
- (void)dataSetChange:(UISegmentedControl *)control;
- (void)setSelectedItem:(NSString*)text;

@end

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark ViewController implementation
//////////////////////////////////////////////////////////////


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _gmGridView.mainSuperView = self.navigationController.view; //[UIApplication
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)init
{
    if ((self =[super init]))
    {
        _delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _borderColor = [UIColor paleWhite];
        _highlightColor = [UIColor dayOnePink];
        
        self.title = @"Memogram";
        
        UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(enableEditMode)];
        
        if ([self.navigationItem respondsToSelector:@selector(leftBarButtonItems)]) {
            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:removeButton, nil];
        }else {
            self.navigationItem.leftBarButtonItem = removeButton;
        }
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(initiateAddItem)];
        
        if ([self.navigationItem respondsToSelector:@selector(rightBarButtonItems)]) {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addButton, nil];
        }else {
            self.navigationItem.rightBarButtonItem = addButton;
        }
        
        //Get data
        _currentData = [_delegate.coreDataStack getCellData];
    }
    
    return self;
}

//////////////////////////////////////////////////////////////
#pragma mark controller events
//////////////////////////////////////////////////////////////

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor paleWhite];
    
    NSInteger spacing = 11;
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = NO;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.disableEditOnEmptySpaceTap = NO;
    _gmGridView.enableEditOnLongPress = NO;
    _gmGridView.showFullSizeViewWithAlphaWhenTransforming = NO;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditorViewController *evc = [storyboard instantiateViewControllerWithIdentifier:@"Editor"];
    _editorNav = [[UINavigationController alloc] initWithRootViewController:evc];
    
    _delegate.editorViewController = evc;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _gmGridView = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(170, 210);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    Cell *c = (Cell*)[_currentData objectAtIndex: index];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"closewhite.png"];
        cell.deleteButtonOffset = CGPointMake(-20, -20);
        
        UIView *outterBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        outterBorder.backgroundColor = [UIColor paleBlack];
        outterBorder.layer.masksToBounds = NO;
        outterBorder.layer.cornerRadius = 5;
        
        outterBorder.layer.borderColor = _borderColor.CGColor;
        outterBorder.layer.borderWidth = 1.0f;
        
        cell.contentView = outterBorder;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *blackScreen = [[UIView alloc] initWithFrame:CGRectMake(10, 10, size.width - 20, size.height - 20)];
    blackScreen.backgroundColor = [UIColor bluishBlack];
    blackScreen.layer.masksToBounds = NO;
    blackScreen.layer.cornerRadius = 5;
    [cell.contentView addSubview:blackScreen];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(12, 6, size.width - 24, size.height - 32)];
    textView.text = c.text;//[NSString stringWithFormat:@"%@", c.index];
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor whiteColor];
    textView.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    textView.editable = NO;
    textView.userInteractionEnabled = NO;
    [cell.contentView addSubview:textView];
    
    if (c.image != nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, size.width - 20, size.height - 20)];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        NSData *imageData = [NSData dataWithContentsOfFile:c.image];
        UIImage *img = [UIImage imageWithData:imageData];
        [imageView setImage: img];
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %ld", (long)position);
    
    _gmGridView.editing = NO;
    
    _delegate.editorViewController.cell = [_currentData objectAtIndex:position];
    [_delegate.editorViewController resetController];
    [self presentViewController:_editorNav animated:YES completion:nil];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        Cell *c = (Cell*)[_currentData objectAtIndex:_lastDeleteItemIndexAsked];
        
        if (c.image)
            [self removeImage: c.image];
        
        [_delegate.coreDataStack deleteCell: c];
        [_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.layer.borderColor = _highlightColor.CGColor;
                         cell.contentView.layer.shadowOpacity = 0.1;
                         cell.contentView.layer.borderWidth = 2;
                     }
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.layer.borderColor = _borderColor.CGColor;
                         cell.contentView.layer.shadowOpacity = 0;
                         cell.contentView.layer.borderWidth = 1;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    NSObject *object = [_currentData objectAtIndex:oldIndex];
    [_currentData removeObject:object];
    [_currentData insertObject:object atIndex:newIndex];
    
    //NSLog([NSString stringWithFormat:@"moveItemAtIndex: %ld, %ld", (long)oldIndex, (long)newIndex]);
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [_delegate.coreDataStack exchangeIndex: [_currentData objectAtIndex:index1] withCell:[_currentData objectAtIndex:index2]];
    [_currentData exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
    
    //NSLog([NSString stringWithFormat:@"exchangeItemAtIndex: %ld, %ld", (long)index1, (long)index2]);
}


//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(312, 390);
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    UIView *fullView = [[UIView alloc] init];
    fullView.backgroundColor = [UIColor bluishBlack];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 30;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UIView *whiteBorder = [[UIView alloc] initWithFrame:CGRectMake(4, 4, fullView.frame.size.width - 8, fullView.frame.size.height - 8)];
    whiteBorder.backgroundColor = [UIColor paleWhite];
    whiteBorder.layer.masksToBounds = NO;
    whiteBorder.layer.cornerRadius = 26;
    [fullView addSubview:whiteBorder];
    
    UIView *blackScreen = [[UIView alloc] initWithFrame:CGRectMake(16, 16, fullView.frame.size.width - 32, fullView.frame.size.height - 32)];
    blackScreen.backgroundColor = [UIColor paleBlack];
    blackScreen.layer.masksToBounds = NO;
    blackScreen.layer.cornerRadius = 24;
    [fullView addSubview:blackScreen];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %ld", (long)index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.font = [UIFont boldSystemFontOfSize:15];
    
    [fullView addSubview:label];
    
    
    return fullView;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.layer.borderColor = _highlightColor.CGColor;
                         cell.contentView.layer.shadowOpacity = 0.1;
                         cell.contentView.layer.borderWidth = 2;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.layer.borderColor = _borderColor.CGColor;
                         cell.contentView.layer.shadowOpacity = 0;
                         cell.contentView.layer.borderWidth = 1;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
    
}


//////////////////////////////////////////////////////////////
#pragma mark private methods
//////////////////////////////////////////////////////////////

- (void)initiateAddItem
{
    // Example: adding object at the last position
    //NSString *newItem = @"";
    
    //[_currentData addObject:newItem];
    //[_gmGridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
    
    _gmGridView.editing = NO;
    
    _delegate.editorViewController.cell = nil;
    [_delegate.editorViewController resetController];
    [self presentViewController:_editorNav animated:YES completion:nil];
    
    //[self refreshItem];
}

- (void)addItem:(NSString*)itemText withImagePath:(NSString*)imagePath
{
    Cell *c = [_delegate.coreDataStack createCell:itemText withImagePath:imagePath];
    [_currentData addObject: c];
    [_gmGridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
}

- (void)updateItem:(Cell*)cell withText:(NSString*)text withImagePath:(NSString*)imagePath
{
    cell.text = text;
    cell.image = imagePath;
    [_delegate.coreDataStack saveContext];
    [_gmGridView reloadObjectAtIndex:[_currentData indexOfObject:cell] withAnimation:GMGridViewItemAnimationNone];
}

- (void)enableEditMode
{
    /*
    // Example: removing last item
    if ([_currentData count] > 0)
    {
        NSInteger index = [_currentData count] - 1;
        
        [_gmGridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        [_currentData removeObjectAtIndex:index];
    }
    */
    
    _gmGridView.editing = !_gmGridView.editing;
    [_gmGridView layoutSubviewsWithAnimation:GMGridViewItemAnimationFade];
}

- (void)refreshItem
{
    // Example: reloading last item
    if ([_currentData count] > 0)
    {
        int index = [_currentData count] - 2;
        
        [_gmGridView reloadObjectAtIndex:index withAnimation:GMGridViewItemAnimationNone];
    }
}

- (void)setSelectedItem:(NSString*)text
{
    if ([_currentData count] > 0)
    {
        int index = [_currentData count] - 1;
        [_currentData replaceObjectAtIndex:index withObject:text];
        [_gmGridView reloadObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
    }
}

- (void)presentInfo
{
    NSString *info = @"Long-press an item and its color will change; letting you know that you can now move it around. \n\nUsing two fingers, pinch/drag/rotate an item; zoom it enough and you will enter the fullsize mode";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:info
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [alertView show];
}

- (int)getCurrentDataCount
{
    return (int)_currentData.count;
}

- (void)removeImage:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (!success) {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

@end
