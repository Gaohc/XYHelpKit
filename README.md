# XYHelpKit

[![CI Status](https://img.shields.io/travis/gaohongcheng/XYHelpKit.svg?style=flat)](https://travis-ci.org/gaohongcheng/XYHelpKit)
[![Version](https://img.shields.io/cocoapods/v/XYHelpKit.svg?style=flat)](https://cocoapods.org/pods/XYHelpKit)
[![License](https://img.shields.io/cocoapods/l/XYHelpKit.svg?style=flat)](https://cocoapods.org/pods/XYHelpKit)
[![Platform](https://img.shields.io/cocoapods/p/XYHelpKit.svg?style=flat)](https://cocoapods.org/pods/XYHelpKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

XYHelpKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XYHelpKit'
```

## Author

gaohongcheng, gaohongcheng@58.com

## License

XYHelpKit is available under the MIT license. See the LICENSE file for more info.


              
##    APP Crash 原因以及自动防护

Crash产生原因

一般是由 Mach异常或 Objective-C 异常（NSException）引起的。我们可以针对这两种情况抓取对应的 Crash 事件。


1、Mach异常是最底层的内核级异常，如EXC_BAD_ACCESS（内存访问异常)
2、Unix Signal是Unix系统中的一种异步通知机制，Mach异常在host层被ux_exception转换为相应的Unix Signal，并通过threadsignal将信号投递到出错的线程
3、 NSException是OC层，由iOS库或者各种第三方库或Runtime验证出错误而抛出的异常。如NSRangeException（数组越界异常）
4、当错误发生时候，先在最底层产生Mach异常；Mach异常在host层被转换为相应的Unix Signal; 在OC层如果有对应的NSException（OC异常），就转换成OC异常，OC异常可以在OC层得到处理；如果OC异常一直得不到处理，程序会强行发送SIGABRT信号中断程序。在OC层如果没有对应的NSException，就只能让Unix标准的signal机制来处理了。
5、在捕获Crash事件时，优选Mach异常。因为Mach异常处理会先于Unix信号处理发生，如果Mach异常的handler让程序exit了，那么Unix信号就永远不会到达这个进程了。而转换Unix信号是为了兼容更为流行的POSIX标准(SUS规范)，这样就不必了解Mach内核也可以通过Unix信号的方式来兼容开发


处理signal

当错误发生时候，先在最底层产生Mach异常；Mach异常在host层被转换为相应的Unix Signal; 在OC层如果有对应的NSException（OC异常），就转换成OC异常，OC异常可以在OC层得到处理；如果OC异常一直得不到处理，程序会强行发送SIGABRT信号中断程序。在OC层如果没有对应的NSException，就只能让Unix标准的signal机制来处理了。

在signal.h中声明了32种异常信号，常见的有以下几种

1、SIGILL 执行了非法指令，一般是可执行文件出现了错误
2、SIGTRAP 断点指令或者其他trap指令产生
3、SIGABRT 调用abort产生
4、SIGBUS 非法地址。比如错误的内存类型访问、内存地址对齐等
5、SIGSEGV 非法地址。访问未分配内存、写入没有写权限的内存等     这个野指针最难查找问题。
6、SIGFPE 致命的算术运算。比如数值溢出、NaN数值等


NSException异常

常见的NSException异常有 8种 

1、unrecognized selector crash
2、KVO crash
3、NSNotification crash
4、NSTimer crash
5、Container crash（数组越界，插nil等）
6、NSString crash （字符串操作的crash）
7、Bad Access crash （野指针）
8、UI not on Main Thread Crash (非主线程刷UI(机制待改善))



crash自动防护 - 实现原理

1     Unrecognized Selector类型crash防护
unrecognized selector类型的crash在app众多的crash类型中占着比较大的成分，通常是因为一个对象调用了一个不属于它方法的方法导致的。

在一个函数找不到时，runtime提供了三种方式去补救：
调用resolveInstanceMethod给个机会让类添加这个实现这个函数
调用forwardingTargetForSelector让别的对象去执行这个函数
调用forwardInvocation（函数执行器）灵活的将目标函数以其他形式执行。
如果都不中，调用doesNotRecognizeSelector抛出异常。

2  KVO crash 产生原因

KVO,即：Key-Value Observing，它提供一种机制，当指定的对象的属性被修改后，则对象就会接受收到通知。简单的说就是每次指定的被观察的对象的属性被修改后，KVO就会自动通知相应的观察者了。
KVO机制在iOS的很多开发场景中都会被使用到。不过如果一不小心使用不当的话，会导致大量的crash问题

通过会导致KVO Crash的两种情形

1、KVO的被观察者dealloc时仍然注册着KVO导致的crash
2、添加KVO重复添加观察者或重复移除观察者（KVO注册观察者与移除观察者不匹配）导致的crash
解决方法：可以让被观察对象持有一个KVO的delegate，所有和KVO相关的操作均通过delegate来进行管理，delegate通过建立一张map来维护KVO整个关系。具体就是使用runTime的交换方法重写KVO的一些方法。

3 NSNotification类型crash防护

当一个对象添加了notification之后，如果dealloc的时候，仍然持有notification，就会出现NSNotification类型的crash。 NSNotification类型的crash多产生于程序员写代码时候犯疏忽，在NSNotificationCenter添加一个对象为observer之后，忘记了在对象dealloc的时候移除它。 所幸的是，苹果在iOS9之后专门针对于这种情况做了处理，所以在iOS9之后，即使开发者没有移除observer，Notification crash也不会再产生了。 不过针对于iOS9之前的用户，我们还是有必要做一下NSNotification Crash的防护的。
NSNotification Crash的防护原理很简单， 利用method swizzling hook NSObject的dealloc函数，再对象真正dealloc之前先调用一下[[NSNotificationCenter defaultCenter] removeObserver:self]即可。

4 NSTimer crash 产生原因 NSTimer类型crash防护

在程序开发过程中，大家会经常使用定时任务，但使用NSTimer的 scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:接口做重复性的定时任务时存在一个问题：NSTimer会强引用target实例，所以需要在合适的时机invalidate定时器，否则就会由于定时器timer强引用target的关系导致target不能被释放，造成内存泄露，甚至在定时任务触发时导致crash。 crash的展现形式和具体的target执行的selector有关。
与此同时，如果NSTimer是无限重复的执行一个任务的话，也有可能导致target的selector一直被重复调用且处于无效状态，对app的CPU，内存等性能方面均是没有必要的浪费。


5 Container crash 产生原因 防护方案
 指的是容器类的crash，常见的有NSArray／NSMutableArray／NSDictionary／NSMutableDictionary／NSCache的crash。 一些常见的越界、插入nil等错误操作均会导致此类crash发生。 由于产生的原因比较简单，就不展开来描述了。
该类crash虽然比较容易排查，但是其在app crash概率总比还是挺高，所以有必要对其进行防护。

 类型的防护方案也比较简单，针对于NSArray／NSMutableArray／NSDictionary／NSMutableDictionary／NSCache的一些常用的会导致崩溃的API进行method swizzling，然后在swizzle的新方法中加入一些条件限制和判断，从而让这些API变的安全。
 
 6  NSString类型crash防护
 NSString／NSMutableString 类型的crash的产生原因和防护方案与Container crash很相像。
 
  7 野指针类型crash防护
在App的所有Crash中，访问野指针导致的Crash占了很大一部分，野指针类型crash的表现为：Exception Type:SIGSEGV，Exception Codes: SEGV_ACCERR 

野指针问题的解决思路方向其实很容易确定，XCode提供了Zombie的机制来排查野指针的问题，那么我们这边可以实现一个类似于Zombie的机制，加上对zombie实例的全部方法拦截机制 和 消息转发机制，那么就可以做到在野指针访问时不Crash而只是crash时相关的信息。

同时还需要注意一点：因为zombie的机制需要在对象释放时保留其指针和相关内存占用，随着app的进行，越来越多的对象被创建和释放，这会导致内存占用越来越大，这样显然对于一个正常运行的app的性能有影响。所以需要一个合适的zombie对象释放机制，确定zombie机制对内存的影响是有限度的。


8 非主线程刷UI类型crash防护（UI not on Main Thread）

目前初步的处理方案是swizzle UIView类的以下三个方法
- (void)setNeedsLayout;
- (void)setNeedsDisplay;
- (void)setNeedsDisplayInRect:(CGRect)rect;

在这三个方法调用的时候判断一下当前的线程，如果不是主线程的话，直接利用 dispatch_async(dispatch_get_main_queue(), ^{ //调用原本方法 });



# 切记  切记  切记!!!
#### `[XYSafeProtector openSafeProtectorWithIsDebug]`一定要在其他SDK之前调用

- 通过如下方式开启防止闪退功能（不包含KVO防护，想要开启KVO防护可以使用下面的方法）,debug模式会打印crash日志，同时会利用断言来让程序闪退，也会回调block,达到测试环境及时发现及时修改，Release模式既不打印也不会断言闪退，会回调block，自己可以上传exception到bugly(注意线上环境isDebug一定要设置为NO)


# 注意
-  最近好多人问我为什么线上环境崩溃位置定位不到，这是因为导出ipa包安装，崩溃位置是定位不到的，即使Debug模式导出ipa也是定位不到，和正式测试没关系，是由于ipa包安装的crash日志是非源码，无法直接分析定位，必须符号化。xcode安装是源码安装。具体符号化步骤可以参照网上，这里不做过多说明，本框架的主旨是防止crash，而不是定位crash




### 目前支持以下类型crash
-  1、XYSafeProtectorCrashTypeSelector
```
1.捕获到未实现方法时，自动将消息转发，避免crash
```
-  2、XYSafeProtectorCrashTypeKVO
```
1.移除未注册的观察者 会crash
2.重复移除观察者 会crash
3.添加了观察者但没有实现observeValueForKeyPath:ofObject:change:context:方法
4.添加移除keypath=nil;
5.添加移除observer=nil;
6.dealloc时自动移除观察者，俗称自释放KVO
```
- 3、XYSafeProtectorCrashTypeNSArray
```
1. NSArray的快速创建方式 NSArray *array = @[@"chenfanfang", @"AvoidCrash"];//调用的是3的方法
2. + (instancetype)arrayWithObjects:(const ObjectType _Nonnull [_Nonnull])objects count:(NSUInteger)cnt;调用的也是3的方法
3. - (instancetype)initWithObjects:(const ObjectType _Nonnull [_Nullable])objects count
4. - (id)objectAtIndex:(NSUInteger)index
******  注意 *****
[__NSCFArray objectAtIndex]不能防止crash，如果交换了会导致其他crash，所以这里不做交换

```

- 4、XYSafeProtectorCrashTypeNSMutableArray
```
1. - (void)addObject:(ObjectType)anObject(实际调用insertObject:)
2. - (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;
3. - (id)objectAtIndex:(NSUInteger)index( 包含   array[index] 形式)
4. - (void)removeObjectAtIndex:(NSUInteger)index
5. - (void)replaceObjectAtIndex:(NSUInteger)index
6. - (void)removeObjectsInRange:(NSRange)range
7. - (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray*)otherArray;
```
- 5、XYSafeProtectorCrashTypeNSDictionary
```
1.+ (instancetype)dictionaryWithObjects:(const ObjectType _Nonnull [_Nullable])objects forKeys:(const KeyType <NSCopying> _Nonnull [_Nullable])keys count:(NSUInteger)cnt会调用2中的方法
2.- (instancetype)initWithObjects:(const ObjectType _Nonnull [_Nullable])objects forKeys:(const KeyType _Nonnull [_Nullable])keys count:(NSUInteger)cnt;
3. @{@"key1":@"value1",@"key2":@"value2"}也会调用2中的方法
4. - (instancetype)initWithObjects:(NSArray<ObjectType> *)objects forKeys:(NSArray<KeyType <NSCopying>> *)keys;
```
- 6、XYSafeProtectorCrashTypeNSMutableDictionary
```
1.直接调用 setObject:forKey
2.通过下标方式赋值的时候，value为nil不会崩溃
iOS11之前会调用 setObject:forKey
iOS11之后（含11)  setObject:forKeyedSubscript:
3.removeObjectForKey
```
- 7、XYSafeProtectorCrashTypeNSStirng
```
1. initWithString
2. hasPrefix
3. hasSuffix
4. substringFromIndex:(NSUInteger)from
5. substringToIndex:(NSUInteger)to {
6. substringWithRange:(NSRange)range {
7. characterAtIndex:(NSUInteger)index
8. stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement 实际上调用的是9方法
9. stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
10. stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement
```

- 8、XYSafeProtectorCrashTypeNSMutableString
```
//除NSString的一些方法外又额外避免了一些方法crash
1.- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString;
2.- (NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange;
3.- (void)insertString:(NSString *)aString atIndex:(NSUInteger)loc;
4.- (void)deleteCharactersInRange:(NSRange)range;
5.- (void)appendString:(NSString *)aString;
6.- (void)setString:(NSString *)aString;
```
- 9、XYSafeProtectorCrashTypeNSAttributedString
```
1.- (instancetype)initWithString:(NSString *)str;
2.- (instancetype)initWithString:(NSString *)str attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attrs;
3.- (instancetype)initWithAttributedString:(NSAttributedString *)attrStr;
```
- 10、XYSafeProtectorCrashTypeNSMutableAttributedString
```
1.- (instancetype)initWithString:(NSString *)str;
2.- (instancetype)initWithString:(NSString *)str attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attrs;
3.- (instancetype)initWithAttributedString:(NSAttributedString *)attrStr;

4. - (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str;
5.- (void)setAttributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attrs range:(NSRange)range;

6.- (void)addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range;
7.- (void)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs range:(NSRange)range;
8.- (void)removeAttribute:(NSAttributedStringKey)name range:(NSRange)range;

9.- (void)replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attrString;
10.- (void)insertAttributedString:(NSAttributedString *)attrString atIndex:(NSUInteger)loc;
11.- (void)appendAttributedString:(NSAttributedString *)attrString;
12.- (void)deleteCharactersInRange:(NSRange)range;
13.- (void)setAttributedString:(NSAttributedString *)attrString;

```
- 11、XYSafeProtectorCrashTypeNSNotificationCenter
```
1. dealloc时自动将self从通知中心移除

```


- 12、XYSafeProtectorCrashTypeNSUserDefaults
```
可避免以下方法  key=nil时的crash
1.objectForKey:
2.stringForKey:
3.arrayForKey:
4.dataForKey:
5.URLForKey:
6.stringArrayForKey:
7.floatForKey:
8.doubleForKey:
9.integerForKey:
10.boolForKey:
11.setObject:forKey:

```

- 13、XYSafeProtectorCrashTypeNSCache
```
1.setObject:forKey:
2.setObject:forKey:cost:

```
- 14、XYSafeProtectorCrashTypeNSSet
```
1.setWithObject:
2.(instancetype)initWithObjects:(ObjectType)firstObj
3.setWithObjects:(ObjectType)firstObj

```
- 15、XYSafeProtectorCrashTypeNSMutableSet
```
1.setWithObject:
2.(instancetype)initWithObjects:(ObjectType)firstObj
3.setWithObjects:(ObjectType)firstObj
4.addObject:
5.removeObject:

```

- 16、XYSafeProtectorCrashTypeNSData
```
1.subdataWithRange:
2.rangeOfData:options:range:

```

- 17、XYSafeProtectorCrashTypeNSMutableData
```
1.subdataWithRange:
2.rangeOfData:options:range:
3.resetBytesInRange:
4.replaceBytesInRange:withBytes:
5.replaceBytesInRange:withBytes:length:

```


- 18、XYSafeProtectorCrashTypeNSOrderedSet
```
1.orderedSetWithSet
2.initWithObjects:count:
3.objectAtIndex:

```

- 19、XYSafeProtectorCrashTypeNSMutableOrderedSet
```
1. - (void)addObject:(ObjectType)anObject
2. - (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;
3. - (id)objectAtIndex:(NSUInteger)index( 包含  set[index]  形式  )
4. - (void)removeObjectAtIndex:(NSUInteger)index
5. - (void)replaceObjectAtIndex:(NSUInteger)index

1. - (void)addObject:(ObjectType)anObject
2. - (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;
3. - (id)objectAtIndex:(NSUInteger)index( 包含  set[index]  形式  )
4. - (void)removeObjectAtIndex:(NSUInteger)index
5. - (void)replaceObjectAtIndex:(NSUInteger)index

```

20 定时器内存泄漏 #import "XYYProxy.h"
self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[XYYProxy proxyWithTarget:self] selector:@selector(doTask) userInfo:nil repeats:YES];



















