//
//  FGMarkdownLinkTextView.m
//  FGMarkdownLinkTextView
//
//  Created by Hlung on 11/26/13.
//  Copyright (c) 2013 Oozou. All rights reserved.
//

#import "FGMarkdownLinkTextView.h"
#import <QuartzCore/QuartzCore.h>

@interface FGMarkdownLink : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *URLString;
@property (nonatomic,assign) NSRange range;
@property (nonatomic,assign) int tag;
@end

@implementation FGMarkdownLink
- (NSString*)description {
    return [NSString stringWithFormat:@"[<%@> title:%@ URLString:%@", NSStringFromClass(self.class), self.title, self.URLString];
}
@end


@interface FGMarkdownLinkTextViewButton : UIButton
@property (nonatomic,strong) CALayer *overlayLayer;
@end

@implementation FGMarkdownLinkTextViewButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

// subclass should call super
- (void)setup {
    self.overlayLayer = [CALayer layer];
    self.overlayLayer.frame = self.bounds;

    UIColor *shadowColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    self.overlayLayer.backgroundColor = shadowColor.CGColor;
    self.overlayLayer.hidden = !self.highlighted;
    self.overlayLayer.cornerRadius = 2*[UIScreen mainScreen].scale;
    [self.layer insertSublayer:self.overlayLayer below:self.imageView.layer];
    [self.layer insertSublayer:self.imageView.layer below:self.titleLabel.layer]; // just in case titleLabel ever goes down
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setHighlighted:(BOOL)highlighted {
    // this is automatically animated for some reason...
    self.overlayLayer.hidden = !highlighted;
}

@end


@implementation FGMarkdownLinkTextView {
    NSMutableArray *links, *buttons;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.linkColor = [UIColor colorWithRed:15/255.0 green:115/255.0 blue:1 alpha:1];
    self.editable = NO;
    //self.dataDetectorTypes = UIDataDetectorTypeLink;
}

- (void)setText:(NSString *)text {
    
    NSMutableString *m = [NSMutableString stringWithString:text];
    links = [NSMutableArray array];

    NSTextCheckingResult *result = [self findFirstMarkdownLinkInString:m];
    while (result) {
        NSString *string = [m substringWithRange:result.range];
        NSString *title = [self contentInSquareBrackets:string];
        NSString *urlString = [self contentInParentheses:string];
        
        FGMarkdownLink *link = [[FGMarkdownLink alloc] init];
        link.range = NSMakeRange(result.range.location, title.length);
        link.title = title;
        link.URLString = urlString;
        link.tag = links.count;
        [links addObject:link];
        
        // replace string and start over
        [m replaceCharactersInRange:result.range withString:title];
        result = [self findFirstMarkdownLinkInString:m];
    }
    
    NSMutableAttributedString *atbs = [[NSMutableAttributedString alloc] initWithString:m];
    
    // set link font
    for (FGMarkdownLink *l in links) {
        NSRange r = l.range;
        //[atbs addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:r];
        [atbs addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, m.length)];
        [atbs addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:r];
        [atbs addAttribute:NSForegroundColorAttributeName value:self.linkColor range:l.range];
    }

    [super setAttributedText:atbs];

    // make link tapable
    for (FGMarkdownLinkTextViewButton *b in buttons) {
        [b removeFromSuperview];
    }
    for (FGMarkdownLink *link in links) {
        NSRange r = link.range;
        CGRect rect = [self frameOfTextRange:r inTextView:self];
        FGMarkdownLinkTextViewButton *b = [[FGMarkdownLinkTextViewButton alloc] initWithFrame:rect];
        b.tag = link.tag;
        [b addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:b];
        [self addSubview:b];
    }
}

- (void)onButton:(FGMarkdownLinkTextViewButton*)sender {
    FGMarkdownLink *link = [self linkForTag:sender.tag];
    if ([self.markdownLinkTextViewDelegate respondsToSelector:@selector(markdownLinkTextView:didSelectLinkTitle:URL:)]) {
        [self.markdownLinkTextViewDelegate markdownLinkTextView:self didSelectLinkTitle:link.title URL:link.URLString];
    }
}

#pragma mark - helpers

- (FGMarkdownLink*)linkForTag:(int)tag {
    for (FGMarkdownLink *link in links) {
        if (link.tag == tag) return link;
    }
    return nil;
}

- (CGRect)frameOfTextRange:(NSRange)range inTextView:(UITextView *)textView
{
    UITextPosition *beginning = textView.beginningOfDocument;
    UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textView positionFromPosition:start offset:range.length];
    UITextRange *textRange = [textView textRangeFromPosition:start toPosition:end];
    CGRect rect = [textView firstRectForRange:textRange];
    return [textView convertRect:rect fromView:textView.textInputView];
}

-(NSString*)contentInSquareBrackets:(NSString *)str
{
    NSString *subString = nil;
    NSRange range1 = [str rangeOfString:@"["];
    NSRange range2 = [str rangeOfString:@"]" options:NSBackwardsSearch];
    if ((range1.length == 1) && (range2.length == 1) && (range2.location > range1.location))
    {
        NSRange range3;
        range3.location = range1.location+1;
        range3.length = (range2.location - range1.location)-1;
        subString = [str substringWithRange:range3];
    }
    return subString;
}

-(NSString*)contentInParentheses:(NSString *)str
{
    NSString *subString = nil;
    NSRange range1 = [str rangeOfString:@"("];
    NSRange range2 = [str rangeOfString:@")" options:NSBackwardsSearch];
    if ((range1.length == 1) && (range2.length == 1) && (range2.location > range1.location))
    {
        NSRange range3;
        range3.location = range1.location+1;
        range3.length = (range2.location - range1.location)-1;
        subString = [str substringWithRange:range3];
    }
    return subString;
}

// find range of the first occurance of "[title](url)" string
- (NSTextCheckingResult*)findFirstMarkdownLinkInString:(NSString*)input {
    NSError  *error  = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\[.+\\]\\(.+\\)"
                                  options:0
                                  error:&error];
    
    return [regex firstMatchInString:input
                             options:0
                               range:NSMakeRange(0, [input length])];
}

@end
