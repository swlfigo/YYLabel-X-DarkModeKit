# DarkMode For YYLabel

As we all know `YYLabel` is no longer update. If your project is using YYLabel and has to adapt iOS13 DarkMode, it's a hard thing to do now.

This repo is using [FluentDarkModeKit](https://github.com/swlfigo/FluentDarkModeKit) for it's core code, all you need to do is just initialize `YYLabel+DarkModeKit` .

You can initialize in `Appdelegate.m`

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [YYLabel config];
 .... 
}
```



## How To Use

1. If you are using `YYTextLayout`, just config Dynamic Color in  `NSMutableAttributedString`

```objective-c
    NSMutableAttributedString *demoStr = [[NSMutableAttributedString alloc] initWithString:@"lalala"];
    [demoStr addAttribute:NSForegroundColorAttributeName value:[UIColor dm_colorWithLightColor:[UIColor redColor] darkColor:[UIColor blueColor]] range:NSMakeRange(0, demoStr.length)];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX)];
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:demoStr];
```



2. If you are using  `NSMutableAttributedString` , you can code like above tips too



## How it work

I'm using runtime swizzle method to monitor the textlayout and attributestring . When it is setted , find if there is Dynamic Color in `AttributeString` and mark it.

Adopted [FluentDarkModeKit](https://github.com/swlfigo/FluentDarkModeKit) Delegate . When DarkMode change , reset AttributeString's `NSForegroundColorAttributeName` if it has Dynamic Color Mark



## What can not be Done

As we know , iOS `CGColor` is not support Darkmode . If you set AttributeString like this:

```objective-c
attributeString.color = [xxxx]
//NSAttributeString+YYText.m
```

it won't work because it using CGColor

If you Modify source code , delete CGColor in .m , it can work Again!

