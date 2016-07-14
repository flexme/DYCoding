//
//  NSObject+DYCoding.m
//  DYCoding
//
//  Created by Kun Chen on 7/11/16.
//  Copyright © 2016 KunChen. All rights reserved.
//

#import "NSObject+DYCoding.h"

#import <objc/runtime.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#define IVAR_KEY(ivar) ([NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding])
#define IVAR_PRIMITIVE_POINTER(object, ivar, type) ((type *)(((char *)((__bridge void *)object)) + ivar_getOffset(ivar)))
#define IVAR_PRIMITIVE_VAL(object, ivar, type) (*IVAR_PRIMITIVE_POINTER(object, ivar, type))

typedef void(*encode_func)(NSCoder *aCoder, id object, Ivar ivar);
typedef void(*decode_func)(NSCoder *aDecoder, id object, Ivar ivar);

#define DEF_PRIMITIVE_ENCODE_FUNC(primitiveType, encodeMethod)\
template <>\
void Encode<primitiveType>(NSCoder *aCoder, id object, Ivar ivar)\
{\
[aCoder encodeMethod:IVAR_PRIMITIVE_VAL(object, ivar, primitiveType) forKey:IVAR_KEY(ivar)];\
}

#define DEF_STRUCT_ENCODE_FUNC(structType, toStringFunc)\
template <>\
void Encode<structType>(NSCoder *aCoder, id object, Ivar ivar)\
{\
[aCoder encodeObject:toStringFunc(IVAR_PRIMITIVE_VAL(object, ivar, structType)) forKey:IVAR_KEY(ivar)];\
}

#define DEF_PRIMITIVE_DECODE_FUNC(primitiveType, decodeMethod)\
template <>\
void Decode<primitiveType>(NSCoder *aDecoder, id object, Ivar ivar)\
{\
IVAR_PRIMITIVE_VAL(object, ivar, primitiveType) = [aDecoder decodeMethod:IVAR_KEY(ivar)];\
}

#define DEF_STRUCT_DECODE_FUNC(structType, fromStringFunc)\
template <>\
void Decode<structType>(NSCoder *aDecoder, id object, Ivar ivar)\
{\
IVAR_PRIMITIVE_VAL(object, ivar, structType) = fromStringFunc([aDecoder decodeObjectForKey:IVAR_KEY(ivar)]);\
}

template <typename T>
void Encode(NSCoder *aCoder, id object, Ivar ivar)
{
  id value = object_getIvar(object, ivar);
  if (value) {
    NSCAssert([value conformsToProtocol:@protocol(NSCoding)], @"Class %@ must conform to protocol NSCoding", NSStringFromClass([object class]));
    [aCoder encodeObject:value forKey:IVAR_KEY(ivar)];
  }
}

DEF_PRIMITIVE_ENCODE_FUNC(char, encodeInt)
DEF_PRIMITIVE_ENCODE_FUNC(int, encodeInt)
DEF_PRIMITIVE_ENCODE_FUNC(short, encodeInt)
DEF_PRIMITIVE_ENCODE_FUNC(long, encodeInteger)
DEF_PRIMITIVE_ENCODE_FUNC(long long, encodeInt64)
DEF_PRIMITIVE_ENCODE_FUNC(float, encodeFloat)
DEF_PRIMITIVE_ENCODE_FUNC(double, encodeDouble)
DEF_PRIMITIVE_ENCODE_FUNC(BOOL, encodeBool)
DEF_STRUCT_ENCODE_FUNC(NSRange, NSStringFromRange)

#if TARGET_OS_IPHONE
DEF_STRUCT_ENCODE_FUNC(CGPoint, NSStringFromCGPoint)
DEF_STRUCT_ENCODE_FUNC(CGSize, NSStringFromCGSize)
DEF_STRUCT_ENCODE_FUNC(CGRect, NSStringFromCGRect)
DEF_STRUCT_ENCODE_FUNC(UIEdgeInsets, NSStringFromUIEdgeInsets)
DEF_STRUCT_ENCODE_FUNC(UIOffset, NSStringFromUIOffset)
#else
DEF_STRUCT_ENCODE_FUNC(CGPoint, NSStringFromPoint)
DEF_STRUCT_ENCODE_FUNC(CGSize, NSStringFromSize)
DEF_STRUCT_ENCODE_FUNC(CGRect, NSStringFromRect)
#endif

template <typename T>
void Decode(NSCoder *aDecoder, id object, Ivar ivar)
{
  id value = [aDecoder decodeObjectForKey:IVAR_KEY(ivar)];
  if (value) {
    object_setIvar(object, ivar, value);
  }
}

DEF_PRIMITIVE_DECODE_FUNC(char, decodeIntForKey)
DEF_PRIMITIVE_DECODE_FUNC(int, decodeIntForKey)
DEF_PRIMITIVE_DECODE_FUNC(short, decodeIntForKey)
DEF_PRIMITIVE_DECODE_FUNC(long, decodeIntegerForKey)
DEF_PRIMITIVE_DECODE_FUNC(long long, decodeInt64ForKey)
DEF_PRIMITIVE_DECODE_FUNC(float, decodeFloatForKey)
DEF_PRIMITIVE_DECODE_FUNC(double, decodeDoubleForKey)
DEF_PRIMITIVE_DECODE_FUNC(BOOL, decodeBoolForKey)
DEF_STRUCT_DECODE_FUNC(NSRange, NSRangeFromString)

#if TARGET_OS_IPHONE
DEF_STRUCT_DECODE_FUNC(CGPoint, CGPointFromString)
DEF_STRUCT_DECODE_FUNC(CGSize, CGSizeFromString)
DEF_STRUCT_DECODE_FUNC(CGRect, CGRectFromString)
DEF_STRUCT_DECODE_FUNC(UIOffset, UIOffsetFromString)
DEF_STRUCT_DECODE_FUNC(UIEdgeInsets, UIEdgeInsetsFromString)
#else
DEF_STRUCT_DECODE_FUNC(CGPoint, NSPointFromString)
DEF_STRUCT_DECODE_FUNC(CGSize, NSSizeFromString)
DEF_STRUCT_DECODE_FUNC(CGRect, NSRectFromString)
#endif


inline encode_func GetEncodeFuncForIvar(Ivar ivar)
{
#define RETURN_FOR_STRUCT(structEncodeType, structType)\
else if (strncmp(type, "{"#structEncodeType"=", strlen("{"#structEncodeType"=")) == 0) {\
return &Encode<structType>;\
}
  
  const char *type = ivar_getTypeEncoding(ivar);
  if (type[0] == 'c' || type[0] == 'C') {
    return &Encode<char>;
  } else if (type[0] == 'i' || type[0] == 'I') {
    return &Encode<int>;
  } else if (type[0] == 's' || type[0] == 'S') {
    return &Encode<short>;
  } else if (type[0] == 'l' || type[0] == 'L') {
    return &Encode<long>;
  } else if (type[0] == 'q' || type[0] == 'Q') {
    return &Encode<long long>;
  } else if (type[0] == 'f') {
    return &Encode<float>;
  } else if (type[0] == 'd') {
    return &Encode<double>;
  } else if (type[0] == 'B') {
    return &Encode<BOOL>;
  } else if (type[0] == '@') {
    return &Encode<id>;
  }
  RETURN_FOR_STRUCT(CGPoint, CGPoint)
  RETURN_FOR_STRUCT(CGSize, CGSize)
  RETURN_FOR_STRUCT(CGRect, CGRect)
#if TARGET_OS_IPHONE
  RETURN_FOR_STRUCT(UIOffset, UIOffset)
  RETURN_FOR_STRUCT(UIEdgeInsets, UIEdgeInsets)
#endif
  RETURN_FOR_STRUCT(_NSRange, NSRange)
  
  NSCAssert(NO, @"The type %s is not supported", type);
  return NULL;
  
#undef RETURN_FOR_STRUCT
}

inline decode_func GetDecodeFuncForIvar(Ivar ivar)
{
#define RETURN_FOR_STRUCT(structEncodeType, structType)\
else if (strncmp(type, "{"#structEncodeType"=", strlen("{"#structEncodeType"=")) == 0) {\
return &Decode<structType>;\
}
  const char *type = ivar_getTypeEncoding(ivar);
  if (type[0] == 'c' || type[0] == 'C') {
    return &Decode<char>;
  } else if (type[0] == 'i' || type[0] == 'I') {
    return &Decode<int>;
  } else if (type[0] == 's' || type[0] == 'S') {
    return &Decode<short>;
  } else if (type[0] == 'l' || type[0] == 'L') {
    return &Decode<long>;
  } else if (type[0] == 'q' || type[0] == 'Q') {
    return &Decode<long long>;
  } else if (type[0] == 'f') {
    return &Decode<float>;
  } else if (type[0] == 'd') {
    return &Decode<double>;
  } else if (type[0] == 'B') {
    return &Decode<BOOL>;
  } else if (type[0] == '@') {
    return &Decode<id>;
  }
  RETURN_FOR_STRUCT(CGPoint, CGPoint)
  RETURN_FOR_STRUCT(CGSize, CGSize)
  RETURN_FOR_STRUCT(CGRect, CGRect)
#if TARGET_OS_IPHONE
  RETURN_FOR_STRUCT(UIOffset, UIOffset)
  RETURN_FOR_STRUCT(UIEdgeInsets, UIEdgeInsets)
#endif
  RETURN_FOR_STRUCT(_NSRange, NSRange)
  
  NSCAssert(NO, @"The type %s is not supported", type);
  return NULL;
  
#undef RETURN_FOR_STRUCT
}

template <typename func>
BOOL AddEncodeOrDecodeMethod(id self, SEL sel, func fn)
{
  unsigned int ivarsCount = 0;
  Ivar *ivars = class_copyIvarList([self class], &ivarsCount);
  encode_func *funcs = (encode_func *)malloc(sizeof(encode_func) * ivarsCount);
  for (unsigned int i = 0; i < ivarsCount; ++i) {
    funcs[i] = fn(ivars[i]);
  }
  
  IMP imp = imp_implementationWithBlock(^(id aSelf, NSCoder *aCoder) {
    for (unsigned int i = 0; i < ivarsCount; ++i) {
      (funcs[i])(aCoder, aSelf, ivars[i]);
    }
  });
  if (!class_addMethod([self class], sel, imp, "v@:@")) {
    // Cleanup
    free(ivars);
    free(funcs);
    imp_removeBlock(imp);
    return NO;
  }
  return YES;
}

BOOL DYAddEncodeMethod(id object)
{
  return AddEncodeOrDecodeMethod(object, @selector(dy_encodeWithCoder:), &GetEncodeFuncForIvar);
}

BOOL DYAddDecodeMethod(id object)
{
  return AddEncodeOrDecodeMethod(object, @selector(dy_decodeWithCoder:), &GetDecodeFuncForIvar);
}

#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation NSObject (DYCoding)

@end

