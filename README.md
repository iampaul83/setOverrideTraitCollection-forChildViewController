
#強制切換SizeClass

SizeClass很好用，這個範例將使用SizeClass設定兩組layout，並用成程式手動強制切換預設的SizeClass*（在regular height的環境切換成compact height）*

##Storyboard
設定好AutoLayout與SizeClass，由於要使用[setOverrideTraitCollection:forChildViewController:]，代表必須由一個上層的**UIViewController**去控制下面的**ChildViewController**，我的設定如下：
> * wAny hAny
>![wAny hAny][]

----------

> * wAny hCompact
>![wAny hCompact][]

<!--more-->

----------

##切換SizeClass

###在Regular的SizeClass使用Compact的layout
```objc
//duration不管設多少好像都一樣，不知道為什麼？
[UIView animateWithDuration:22 animations:
^{
	UIUserInterfaceSizeClass sizeClass = UIUserInterfaceSizeClassCompact;
	UITraitCollection *horicontalCompact = [UITraitCollection traitCollectionWithVerticalSizeClass:sizeClass];
	[self setOverrideTraitCollection:horicontalCompact
			  forChildViewController:self.childViewController];
	self.bottomConstraint.constant = space;
	//少了這行會沒動畫
	[self.view layoutIfNeeded];
}];
```
###回復預設
強制切換之後要回復預設，則使用相同方式，把SizeClass指定為**UIUserInterfaceSizeClassUnspecified**


----------


##關於範例程式中的一些...

###NSNotificationCenter

####1. UIKeyboardWillShowNotification: 切換到Compact
#####使用**UIKeyboardFrameEndUserInfoKey**取得鍵盤高度
```objc
NSValue *rectValue = keyboardNotification.userInfo[UIKeyboardFrameEndUserInfoKey];
CGRect keyboardFrame = rectValue.CGRectValue;
CGFloat keyboardHeight = keyboardFrame.size.height;
```
#####用鍵盤高度設定container view的constraint
```objc
self.bottomConstraint.constant = keyboardHeight;
```

####2. UIKeyboardWillHideNotification: 切換到預設


----------


###Container View

1. 將**Container View**拉到view上
2. 預設會自動附帶一個**embed segue**與一個**UIViewController**
3. 設定**embed segue**的**identifier**
4. 在ViewController裡
```objc
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"container"]) {
        self.childViewController = segue.destinationViewController;
    }
}
```

> Written with [StackEdit](https://stackedit.io/).

<!--IMAGE-->
[wAny hAny]: https://lh3.googleusercontent.com/-4uIln4FswX8/VTtZu1FFNxI/AAAAAAAALjY/sJWgicXV8Kc/s0/Screen+Shot+2015-04-25+at+17.06.21.png "wAny hAny"
[wAny hCompact]: https://lh3.googleusercontent.com/-0tq2ur3HiX0/VTtZ8KYoaYI/AAAAAAAALjk/6IjjQl4gks0/s0/Screen+Shot+2015-04-25+at+17.06.42.png "wAny hCompact"

<!--LINK-->
[setOverrideTraitCollection:forChildViewController:]: https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/#//apple_ref/occ/instm/UIViewController/setOverrideTraitCollection:forChildViewController:
