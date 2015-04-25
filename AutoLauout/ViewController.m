//
//  ViewController.m
//  AutoLauout
//
//  Created by Paul on 4/23/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottonConstraint;
@property (weak, nonatomic) UIViewController *childViewController;
@end

@implementation ViewController

#pragma mark - Life cycle

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self startObserve];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopObserve];
}

#pragma mark - Event Handlers
#pragma mark button

- (IBAction)cancelButton:(id)sender {
    [self.view endEditing:true];
}

#pragma mark keyboard
-(void)keyboardWillShowHandler:(NSNotification *)keyboardNotification {
    NSValue *rectValue = keyboardNotification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = rectValue.CGRectValue;
    CGFloat keyboardHeight = keyboardFrame.size.height;
    [self changeVerticalSizeClassTo: UIUserInterfaceSizeClassCompact buttonSpace:keyboardHeight];
}

-(void)keyboardWillHideHandler:(NSNotification *)keyboardNotification {
    [self changeVerticalSizeClassTo:UIUserInterfaceSizeClassUnspecified buttonSpace:0];
}

#pragma mark - override size class

-(void)changeVerticalSizeClassTo:(UIUserInterfaceSizeClass)sizeClass buttonSpace:(CGFloat)space {
    [UIView animateWithDuration:22 animations:
     ^{
        UITraitCollection *horicontalCompact =
        [UITraitCollection traitCollectionWithVerticalSizeClass:sizeClass];
        [self setOverrideTraitCollection:horicontalCompact
                  forChildViewController:self.childViewController];
        self.bottonConstraint.constant = space;
        [self.view layoutIfNeeded];
     }];
}

#pragma mark - NSNotificationCenter

-(void)startObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowHandler:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)stopObserve {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"container"]) {
        self.childViewController = segue.destinationViewController;
    }
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
