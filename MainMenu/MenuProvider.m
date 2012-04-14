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

#import "MenuProvider.h"

@implementation MenuProvider

@synthesize navigator = _navigator;

- (NSString *)title {
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		navigationCellWithText:(NSString *)text
					detailText:(NSString *)detailText
				   destination:(NSString *)destination
{
    static NSString *CellIdentifier = @"MenuNavigationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
									  reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	cell.textLabel.text = text;
	cell.detailTextLabel.text = detailText;
	cell.cookie = destination;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
			actionCellWithText:(NSString *)text
				 textAlignment:(UITextAlignment)textAlignment
				selectionStyle:(UITableViewCellSelectionStyle)selectionStyle
{
    static NSString *CellIdentifier = @"MenuActionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									  reuseIdentifier:CellIdentifier];
	}
	cell.textLabel.text = text;
	cell.textLabel.textAlignment = textAlignment;
	cell.selectionStyle = selectionStyle;
    return cell;
}

- (BAEditableCell *)tableView:(UITableView *)tableView
		 textEntryCellWithText:(NSString *)text
{
    static NSString *CellIdentifier = @"MenuTextEntryCell";
    BAEditableCell *cell = (BAEditableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[BAEditableCell alloc] initWithStyle:UITableViewCellStyleValue1
									 reuseIdentifier:CellIdentifier];
	}
	cell.textLabel.text = text;
	cell.detailTextLabel.text = nil;
	cell.textField.delegate = self;
	[cell.textField removeTarget:nil action:NULL forControlEvents:UIControlEventEditingChanged];
	[cell.textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if ([cell.cookie isKindOfClass:[NSString class]] && self.navigator) {
		self.navigator(cell.cookie);
	} else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

+ (BOOL)validEmail:(NSString *)email {
	NSRegularExpression *regexpObject = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
																				  options:0
																					error:NULL];
	NSRange range = [regexpObject rangeOfFirstMatchInString:email
													options:0
													  range:NSMakeRange(0, [email length])];
	if (range.location == NSNotFound || range.length != [email length]) {
		return NO;
	}
	return YES;
}

@end
