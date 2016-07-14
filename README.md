# DYCoding
Have you got tried of implementing methods `initWithCoder:` and `encodeWithCoder:` by yourself? With **DYCoding**, you don't need to implement those anymore, the encoding/decoding works dynamically in the runtime.

# How To Use
### Subclass from `DYCodingObject`
If a class is subclass from `DYCodingObject`, it will get the dyanmically encoding/decoding for free.
```
@interface MyModelObject : DYCodingObject

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, assign) NSInteger age;

@end
```

### Use macro `DY_CLASS_IMPL`
Since objective-c class can only have one super class, if your class can't subclass from `DYCodingObject`, you can put the macro `DY_CLASS_IMPL` in your class's implemention section, then your class will get the dyanmically encoding/decoding for free.
```
@implementation MyModelObject

DY_CLASS_IMPL

...

@end
```

# Example

You can refer the unit tests in [DYCodingTests.m](https://github.com/flexme/DYCoding/blob/master/DYCodingTests/DYCodingTests.m) for the examples. 

# Installation
There are three ways to use DYCoding in your project:

* Importing the project to your workspace, add the corresponding target to your project as a static library
* Copying all the files into your project
* ~~Using CocoaPods (Will be Supported Soon)~~

# Supported Platforms
* iOS
* OS X
* watchOS
* tvOS

# Supported Property Types

This library supports dynamically encode/decode the object which contains the following property types, assertion will throw if it contains an unsupported property type.
* All primitive types.
* Objects which conforms to `NSCoding` protocol.
* Some pre-defined structs: CGPoint, CGSize, CGRect, NSRange, UIOffset, UIEdgeInsets.

# Performance

Although the encoding/decoding happens dynamically, it's performance should be **as fast as** the precompiled code due to the optimizations we have done. We are not doing the expensive reflection operation (`class_copyIvarList`) everytime, instead we only do it once per class, then use `imp_implementationWithBlock` and `class_addMethod` to add the implementation to the class. 

# Licenses

All source code is licensed under the [MIT License](https://github.com/flexme/DYCoding/blob/master/LICENSE).