/*
 Copyright 2012 Dmitry Stadnik. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are
 permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of
 conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list
 of conditions and the following disclaimer in the documentation and/or other materials
 provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY DMITRY STADNIK ``AS IS'' AND ANY EXPRESS OR IMPLIED
 WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL DMITRY STADNIK OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 The views and conclusions contained in the software and documentation are those of the
 authors and should not be interpreted as representing official policies, either expressed
 or implied, of Dmitry Stadnik.
 */

#import "MenuSystem.h"
#import "MenuHomeProvider.h"
#import "MenuLoginProvider.h"
#import "MenuRegistrationProvider.h"
#import "MenuHelpProvider.h"
#import "MenuTextViewController.h"

#define kContentSize CGSizeMake(320, 400)

@implementation MenuSystem

+ (MenuProvider *)makeProviderForDestination:(NSString *)destination {
	if ([@"home" isEqualToString:destination]) {
		return [[MenuHomeProvider alloc] init];
	} else if ([@"login" isEqualToString:destination]) {
		return [[MenuLoginProvider alloc] init];
	} else if ([@"register" isEqualToString:destination]) {
		return [[MenuRegistrationProvider alloc] init];
	} else if ([@"help" isEqualToString:destination]) {
		return [[MenuHelpProvider alloc] init];
	}
	return nil;
}

+ (MenuTextViewController *)makeTextControllerForFile:(NSString *)fileName {
	if (!fileName) {
		return nil;
	}
	NSURL *contentURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"html"];
	if (!contentURL) {
		return nil;
	}
	MenuTextViewController *textController = [[MenuTextViewController alloc] init];
	textController.view.backgroundColor = [UIColor lightGrayColor];
	textController.contentSizeForViewInPopover = kContentSize;
	textController.contentURL = contentURL;
	return textController;
}

+ (MenuViewController *)makeMenuControllerForDestination:(NSString *)destination {
	MenuProvider *provider = [self makeProviderForDestination:destination];
	if (!provider) {
		return nil;
	}
	MenuViewController *menuController = [[MenuViewController alloc] init];
	menuController.contentSizeForViewInPopover = kContentSize;
	menuController.provider = provider;
	__unsafe_unretained MenuViewController *weakMenuController = menuController;
	provider.navigator = ^(NSString *destination) {
		if ([@"back" isEqualToString:destination]) {
			[weakMenuController.navigationController popViewControllerAnimated:YES];
			return;
		}
		MenuViewController *menuController = [self makeMenuControllerForDestination:destination];
		if (menuController) {
			[weakMenuController.navigationController pushViewController:menuController animated:YES];
		} else {
			MenuTextViewController *textController = [self makeTextControllerForFile:destination];
			if (textController) {
				[weakMenuController.navigationController pushViewController:textController animated:YES];
			}
		}
	};
	return menuController;
}

+ (MenuViewController *)makeHomeController {
	return [self makeMenuControllerForDestination:@"home"];
}

+ (UIPopoverController *)makePopover:(UIViewController *)sourceController {
	MenuViewController *menuController = [self makeHomeController];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:menuController];
	navController.contentSizeForViewInPopover = kContentSize;
	UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:navController];
	return popoverController;
}

@end
