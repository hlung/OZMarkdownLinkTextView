//
//  OZViewController.m
//  FGMarkdownLinkTextViewTextView
//
//  Created by Hlung on 11/26/13.
//  Copyright (c) 2013 Oozou. All rights reserved.
//

#import "OZViewController.h"

@interface OZViewController () <FGMarkdownLinkTextViewDelegate>

@end

@implementation OZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *input = @"    Welcome!\r\n\r\n[Contact us](call:1234)\r\n[Google me](http://www.google.com)\r\n[Google me no http](www.google.com)\r\nhttp://www.google.com\r\n\r\nLorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";

    self.linkTextView.font = [UIFont systemFontOfSize:16];
    self.linkTextView.text = input;
    self.linkTextView.markdownLinkTextViewDelegate = self;
}

- (void)markdownLinkTextView:(FGMarkdownLinkTextView *)textView didSelectLinkTitle:(NSString *)title URL:(NSString *)URLString {
    
    NSLog(@"Tapped \"%@\" %@", title, URLString);

    NSURL *URL = [NSURL URLWithString:URLString];
    
    // optional: if no scheme, use http to make the URL work
    NSString *urlScheme = URL.scheme;
    if (urlScheme.length == 0) {
        URLString = [NSString stringWithFormat:@"http://%@",URLString];
        URL = [NSURL URLWithString:URLString];
    }
    
    /*
    // Open URL in Mobile Safari
    if ([[UIApplication sharedApplication] openURL:URL] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot open URL"
                                                        message:URL.absoluteString
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
     */
}

@end
