//
//  NSObject+DYCoding.h
//  DYCoding
//
//  Created by Kun Chen on 7/11/16.
//  Copyright © 2016 KunChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DYCoding)

- (void)dy_encodeWithCoder:(NSCoder *)aCoder;
- (void)dy_decodeWithCoder:(NSCoder *)aDecoder;

@end

#ifdef __cplusplus
extern "C" {
#endif
  
  BOOL DYAddEncodeMethod(id object);
  BOOL DYAddDecodeMethod(id object);
  
#ifdef __cplusplus
}
#endif

#define DY_CLASS_IMPL \
- (instancetype)initWithCoder:(NSCoder *)aDecoder\
{\
  if (self = [super init]) {\
    [self dy_decodeWithCoder:aDecoder];\
  }\
  return self;\
}\
\
- (void)encodeWithCoder:(NSCoder *)aCoder\
{\
  [self dy_encodeWithCoder:aCoder];\
}\
\
+ (BOOL)resolveInstanceMethod:(SEL)sel\
{\
  if (sel == @selector(dy_encodeWithCoder:)) {\
    return DYAddEncodeMethod(self);\
  } else if (sel == @selector(dy_decodeWithCoder:)) {\
    return DYAddDecodeMethod(self);\
  }\
\
  return [super resolveInstanceMethod:sel];\
}
