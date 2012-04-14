//
//  ViewController.m
//  MenuSystem
//
//  Created by Stadnik Dmitry on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "MenuSystem.h"

@interface ViewController ()

@end

@implementation ViewController {
@private
	UIPopoverController *_mainMenuPopoverController;
}

- (void)hideMainMenuPopover:(BOOL)animated {
	if (_mainMenuPopoverController) {
		[_mainMenuPopoverController dismissPopoverAnimated:animated];
		_mainMenuPopoverController = nil;
	}
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[self hideMainMenuPopover:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self hideMainMenuPopover:animated];
}

- (IBAction)showMainMenu:(UIButton *)sender {
	if (!_mainMenuPopoverController) {
		_mainMenuPopoverController = [MenuSystem makePopover:self];
		_mainMenuPopoverController.delegate = self;
	}
	[_mainMenuPopoverController presentPopoverFromRect:sender.bounds
												inView:sender
							  permittedArrowDirections:UIPopoverArrowDirectionUp
											  animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	[self hideMainMenuPopover:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[self hideMainMenuPopover:NO];
}

@end
