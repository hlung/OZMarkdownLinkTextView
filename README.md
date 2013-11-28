OZMarkdownLinkTextView
======================

A UITextView subclass that detects markdown-style links, underline the text and make it tappable.

Note: There are still bugs and it needs a lot more improvements. Contributions are welcomed!

####Input:

```
NSString *input = @"    Welcome!\r\n\r\n[Contact us](call:1234)\r\n[Google me](http://www.google.com)\r\n[Google me no http](www.google.com)\r\nhttp://www.google.com\r\n\r\nLorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
```
####Output:

![ss](/README/ss.png)