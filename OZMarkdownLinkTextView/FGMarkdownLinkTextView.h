//
//  FGMarkdownLinkTextView.h
//  FGMarkdownLinkTextView
//
//  Created by Hlung on 11/26/13.
//  Copyright (c) 2013 Oozou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FGMarkdownLinkTextView;

@protocol FGMarkdownLinkTextViewDelegate <NSObject>
@optional
- (void)markdownLinkTextView:(FGMarkdownLinkTextView*)textView didSelectLinkTitle:(NSString*)title URL:(NSString*)URLString;
@end

// NOTE: need to set font programmatically before set text to make link buttons appear correctly
@interface FGMarkdownLinkTextView : UITextView
@property (nonatomic,strong) UIColor *linkColor;
@property (nonatomic,assign) IBOutlet NSObject <FGMarkdownLinkTextViewDelegate> *markdownLinkTextViewDelegate;
@end
