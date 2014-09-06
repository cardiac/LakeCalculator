//
//  LakeViewController.m
//  LakeCalculator
//
//  Created by Ryan Strug on 9/5/14.
//  Copyright (c) 2014 Ryan Strug. All rights reserved.
//

#import "LakeViewController.h"
#import "LakeCalculator.h"

@interface LakeViewController () <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray  *heights;
    
    NSString        *lakeCellReuseIdentifier;
    UITextField     *editTextField;
    
    UIBarButtonItem *editButton;
    UIBarButtonItem *doneButton;
}


@property (weak, nonatomic) IBOutlet UILabel     *areaTotalLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LakeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        heights = [self generateHeights];
        lakeCellReuseIdentifier = @"LakeTableViewCell";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Lake Calculator";
    
    editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTable:)];
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editTable:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addHeight:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    dismissButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 120.0f, 5.0f, 100.0f, 30.0f);
    dismissButton.layer.borderColor = [[UIColor blueColor] CGColor];
    dismissButton.layer.borderWidth = 1.0f;
    [dismissButton setTitle:@"Update" forState:UIControlStateNormal];
    [dismissButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [dismissButton setTitle:@"Update" forState:UIControlStateHighlighted];
    [dismissButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 40.0f)];
    accessoryView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    [accessoryView addSubview:dismissButton];
    
    editTextField = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, 0.0f, _tableView.frame.size.width, 43.5f)];
    editTextField.inputAccessoryView = accessoryView;
    editTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    // fixes a weird ios issue with nibs/autolayout/etc
    _tableView.contentInset = UIEdgeInsetsMake(-64.0f, 0.0f, 0.0f, 0.0f);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateAreaCalculation];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - LakeViewController

- (NSMutableArray *)generateHeights
{
    return [NSMutableArray arrayWithObjects:@1.0f, @2.0f, @1.5f, @2.5f, @2.0f, @1.5f, @3.0f, @2.5f, @2.0f, nil];
}

- (void)editTable:(id)sender
{
    self.navigationItem.rightBarButtonItem = [self.navigationItem.rightBarButtonItem isEqual:editButton] ? doneButton : editButton;
    _tableView.editing = !_tableView.editing;
}

- (void)addHeight:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add Height" message:@"Create a new height." delegate:self cancelButtonTitle:@"Create" otherButtonTitles:nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeDecimalPad;
    [alertView show];
}

- (void)dismissKeyboard:(id)sender
{
    if ([editTextField.text length] > 0) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        nf.numberStyle = NSNumberFormatterDecimalStyle;
        heights[editTextField.tag] = [nf numberFromString:editTextField.text];
        
        [self updateAreaCalculation];
    }
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[_tableView indexPathForSelectedRow]];
    cell.textLabel.text = [NSString stringWithFormat:@"%.2f", [heights[editTextField.tag] floatValue]];
    
    _tableView.scrollEnabled = YES;
    _tableView.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:NO];
    
    [editTextField resignFirstResponder];
    [editTextField removeFromSuperview];
    
    _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (void)updateAreaCalculation
{
    dispatch_queue_t queue = dispatch_queue_create("calculateLakeArea", 0);
    dispatch_async(queue, ^(void) {
        CGFloat area = [[LakeCalculator calculateLakeAreaForHeights:heights] floatValue];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            _areaTotalLabel.text = [NSString stringWithFormat:@"Area: %.2f", area];
        });
    });
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *input = [alertView textFieldAtIndex:0].text;
    
    if ([input length] > 0) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        nf.numberStyle = NSNumberFormatterDecimalStyle;
        [heights addObject:[nf numberFromString:input]];
        
        [self updateAreaCalculation];
        [_tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [heights count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lakeCellReuseIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%.2f", [heights[indexPath.row] floatValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [heights removeObjectAtIndex:indexPath.row];
        [self updateAreaCalculation];
        
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSNumber *number = heights[sourceIndexPath.row];
    [heights removeObjectAtIndex:sourceIndexPath.row];
    [heights insertObject:number atIndex:destinationIndexPath.row];
    
    [self updateAreaCalculation];
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        return nil;
    
    if (indexPath.row > 2)
        _tableView.contentInset = UIEdgeInsetsMake(-64.0f, 0.0f, 265.0f, 0.0f);
    
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    _tableView.scrollEnabled = NO;
    _tableView.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    editTextField.tag = indexPath.row;
    editTextField.text = cell.textLabel.text;
    cell.textLabel.text = nil;
    [cell addSubview:editTextField];
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [editTextField becomeFirstResponder];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

@end
