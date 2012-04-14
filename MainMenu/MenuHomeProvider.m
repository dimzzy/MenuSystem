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

#import "MenuHomeProvider.h"
#import "AppDelegate.h"

@implementation MenuHomeProvider

- (NSString *)title {
	return @"Settings";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	} else if (section == 1) {
		return 1;
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
		const BOOL validSession = !!appd.sessionId;
		if (indexPath.row == 0) {
			if (validSession) {
				return [self tableView:tableView
					actionCellWithText:@"You are logged in"
						 textAlignment:UITextAlignmentLeft
						selectionStyle:UITableViewCellSelectionStyleNone];
			} else {
				return [self tableView:tableView
				navigationCellWithText:@"Existing user"
							detailText:@"Login"
						   destination:@"login"];
			}
		} else if (indexPath.row == 1) {
			if (validSession) {
				return [self tableView:tableView
					actionCellWithText:@"Logout"
						 textAlignment:UITextAlignmentLeft
						selectionStyle:UITableViewCellSelectionStyleBlue];
			} else {
				return [self tableView:tableView
				navigationCellWithText:@"New user"
							detailText:@"Register"
						   destination:@"register"];
			}
		}
	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			return [self tableView:tableView
			navigationCellWithText:@"Help"
						detailText:nil
					   destination:@"help"];
		}
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
		const BOOL validSession = !!appd.sessionId;
		if (indexPath.row == 1) {
			if (validSession) {
				[appd logout];
				[tableView reloadData];
				return;
			}
		}
	}
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
