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

#import "MenuRegistrationProvider.h"
#import "AppDelegate.h"

@interface MenuRegistrationProvider ()

@property(nonatomic) NSString *name;
@property(nonatomic) NSString *password;
@property(nonatomic) NSString *passwordAgain;
@property(nonatomic) NSString *email;

@end


@implementation MenuRegistrationProvider

@synthesize name = _name;
@synthesize password = _password;
@synthesize passwordAgain = _passwordAgain;
@synthesize email = _email;

- (NSString *)title {
	return @"Register";
}

- (void)textDidChange:(UITextField *)textField {
	if (textField.tag == 0) {
		self.name = textField.text;
	} else if (textField.tag == 1) {
		self.password = textField.text;
	} else if (textField.tag == 2) {
		self.passwordAgain = textField.text;
	} else if (textField.tag == 3) {
		self.email = textField.text;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"Create a new account";
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 4;
	} else if (section == 1) {
		return 1;
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			BAEditableCell *cell = [self tableView:tableView textEntryCellWithText:@"User name"];
			cell.textField.placeholder = @"Your Name";
			cell.textField.text = self.name;
			cell.textField.secureTextEntry = NO;
			cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
			cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			cell.textField.keyboardType = UIKeyboardTypeDefault;
			cell.textField.tag = indexPath.row;
			return cell;
		} else if (indexPath.row == 1) {
			BAEditableCell *cell = [self tableView:tableView textEntryCellWithText:@"Password"];
			cell.textField.placeholder = @"Your Password";
			cell.textField.text = self.password;
			cell.textField.secureTextEntry = YES;
			cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
			cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			cell.textField.keyboardType = UIKeyboardTypeDefault;
			cell.textField.tag = indexPath.row;
			return cell;
		} else if (indexPath.row == 2) {
			BAEditableCell *cell = [self tableView:tableView textEntryCellWithText:@"Password"];
			cell.textField.placeholder = @"Password Again";
			cell.textField.text = self.passwordAgain;
			cell.textField.secureTextEntry = YES;
			cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
			cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			cell.textField.keyboardType = UIKeyboardTypeDefault;
			cell.textField.tag = indexPath.row;
			return cell;
		} else if (indexPath.row == 3) {
			BAEditableCell *cell = [self tableView:tableView textEntryCellWithText:@"Email"];
			cell.textField.placeholder = @"Your Email";
			cell.textField.text = self.email;
			cell.textField.secureTextEntry = NO;
			cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
			cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
			cell.textField.tag = indexPath.row;
			return cell;
		}
	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			return [self tableView:tableView
				actionCellWithText:@"Create new account"
					 textAlignment:UITextAlignmentCenter
					selectionStyle:UITableViewCellSelectionStyleBlue];
		}
	}
	return nil;
}

- (BOOL)validateForm {
	if (!self.name || [self.name length] == 0) {
		MenuAlert(@"Error", @"User name is not specified.");
		return NO;
	}
	if (!self.password || [self.password length] == 0) {
		MenuAlert(@"Error", @"Password is not specified.");
		return NO;
	}
	if (!self.passwordAgain || [self.passwordAgain length] == 0) {
		MenuAlert(@"Error", @"Password copy is not specified.");
		return NO;
	}
	if (![self.password isEqualToString:self.passwordAgain]) {
		MenuAlert(@"Error", @"Passwords do not match.");
		return NO;
	}
	if (!self.email || [self.email length] == 0) {
		MenuAlert(@"Error", @"Email is not specified.");
		return NO;
	}
	if (![[self class] validEmail:self.email]) {
		MenuAlert(@"Error", @"Email is not valid.");
		return NO;
	}
	return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			if ([self validateForm]) {
				AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
				[appd registerWithName:self.name password:self.password email:self.email];
				self.navigator(@"back");
			}
		}
	}
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
