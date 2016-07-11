//
//  DYCodingTests.m
//  DYCodingTests
//
//  Created by Kun Chen on 7/11/16.
//  Copyright © 2016 KunChen. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <DYCoding/DYCoding.h>

@interface DYTestObject : DYCodingObject

@property (nonatomic, readonly, copy) NSArray *arrayVal;
@property (nonatomic, readonly, copy) NSString *stringVal;
@property (nonatomic, readonly, assign) char charVal;
@property (nonatomic, readonly, assign) unsigned char uCharVal;
@property (nonatomic, readonly, assign) short shortVal;
@property (nonatomic, readonly, assign) unsigned short uShortVal;
@property (nonatomic, readonly, assign) int intVal;
@property (nonatomic, readonly, assign) unsigned int uIntVal;
@property (nonatomic, readonly, assign) long longVal;
@property (nonatomic, readonly, assign) unsigned long uLongVal;
@property (nonatomic, readonly, assign) long long longlongVal;
@property (nonatomic, readonly, assign) unsigned int uLonglongVal;
@property (nonatomic, readonly, assign) float floatVal;
@property (nonatomic, readonly, assign) double doubleVal;
@property (nonatomic, readonly, assign) BOOL boolVal;
@property (nonatomic, readonly, assign) CGPoint point;
@property (nonatomic, readonly, assign) CGSize size;
@property (nonatomic, readonly, assign) CGRect rect;
@property (nonatomic, readonly, assign) NSRange range;
@property (nonatomic, readonly, assign) UIOffset offset;
@property (nonatomic, readonly, assign) UIEdgeInsets edgeInsets;

- (instancetype)initWithArrayVal:(NSArray *)arrayVal
                       StringVal:(NSString *)stringVal
                         charVal:(char)charVal
                        uCharVal:(unsigned char)uCharVal
                        shortVal:(short)shortVal
                       uShortVal:(unsigned short)uShortVal
                          intVal:(int)intVal
                         uIntVal:(unsigned int)uIntVal
                         longVal:(long)longVal
                        uLongVal:(unsigned long)uLongVal
                     longlongVal:(long long)longlongVal
                    uLonglongVal:(unsigned long long)uLonglongVal
                        floatVal:(float)floatVal
                       doubleVal:(double)doubleVal
                         boolVal:(BOOL)boolVal
                           point:(CGPoint)point
                            size:(CGSize)size
                            rect:(CGRect)rect
                           range:(NSRange)range
                          offset:(UIOffset)offset
                      edgeInsets:(UIEdgeInsets)edgeInsets;

@end

@implementation DYTestObject

- (instancetype)initWithArrayVal:(NSArray *)arrayVal
                       StringVal:(NSString *)stringVal
                         charVal:(char)charVal
                        uCharVal:(unsigned char)uCharVal
                        shortVal:(short)shortVal
                       uShortVal:(unsigned short)uShortVal
                          intVal:(int)intVal
                         uIntVal:(unsigned int)uIntVal
                         longVal:(long)longVal
                        uLongVal:(unsigned long)uLongVal
                     longlongVal:(long long)longlongVal
                    uLonglongVal:(unsigned long long)uLonglongVal
                        floatVal:(float)floatVal
                       doubleVal:(double)doubleVal
                         boolVal:(BOOL)boolVal
                           point:(CGPoint)point
                            size:(CGSize)size
                            rect:(CGRect)rect
                           range:(NSRange)range
                          offset:(UIOffset)offset
                      edgeInsets:(UIEdgeInsets)edgeInsets
{
  if (self = [super init]) {
    _arrayVal = [arrayVal copy];
    _stringVal = [stringVal copy];
    _charVal = charVal;
    _uCharVal = uCharVal;
    _shortVal = shortVal;
    _uShortVal = uShortVal;
    _intVal = intVal;
    _uIntVal = uIntVal;
    _longVal = longVal;
    _uLongVal = uLongVal;
    _longlongVal = longlongVal;
    _uLonglongVal = uLonglongVal;
    _floatVal = floatVal;
    _doubleVal = doubleVal;
    _boolVal = boolVal;
    _point = point;
    _size = size;
    _rect = rect;
    _range = range;
    _offset = offset;
    _edgeInsets = edgeInsets;
  }
  return self;
}

- (BOOL)isEqual:(DYTestObject *)object
{
  return (_arrayVal == object.arrayVal || [_arrayVal isEqual:object.arrayVal]) &&
  (_stringVal == object.stringVal || [_stringVal isEqual:object.stringVal]) &&
  _charVal == object.charVal && _uCharVal == object.uCharVal &&
  _shortVal == object.shortVal && _uShortVal == object.uShortVal &&
  _intVal == object.intVal && _uIntVal == object.uIntVal &&
  _longVal == object.longVal && _uLonglongVal == object.uLongVal &&
  _longlongVal == object.longlongVal && _uLonglongVal == object.uLonglongVal &&
  _floatVal == object.floatVal && _doubleVal == object.doubleVal && _boolVal == object.boolVal &&
  CGPointEqualToPoint(_point, object.point) &&
  CGSizeEqualToSize(_size, object.size) &&
  CGRectEqualToRect(_rect, object.rect) &&
  NSEqualRanges(_range, object.range) &&
  UIOffsetEqualToOffset(_offset, object.offset) &&
  UIEdgeInsetsEqualToEdgeInsets(_edgeInsets, object.edgeInsets);
}

@end

@interface TestNoneCodingObject : NSObject
@end

@implementation TestNoneCodingObject
@end

@interface DYTestInvalidObject : DYCodingObject

@property (nonatomic, readonly, strong) TestNoneCodingObject *object;

- (instancetype)initWithObject:(TestNoneCodingObject *)object;

@end

@implementation DYTestInvalidObject

- (instancetype)initWithObject:(TestNoneCodingObject *)object
{
  if (self = [super init]) {
    _object = object;
  }
  return self;
}

@end

@interface DYCodingTests : XCTestCase
@end

@implementation DYCodingTests

- (void)setUp
{
  [super setUp];
}

- (void)tearDown
{
  [super tearDown];
}

- (void)testEncodeDecodeForAllTypes
{
  DYTestObject *originalObject = [[DYTestObject alloc] initWithArrayVal:nil
                                                              StringVal:@"string"
                                                                charVal:128
                                                               uCharVal:255
                                                               shortVal:128
                                                              uShortVal:255
                                                                 intVal:1
                                                                uIntVal:2
                                                                longVal:1
                                                               uLongVal:2
                                                            longlongVal:1
                                                           uLonglongVal:2
                                                               floatVal:123.456
                                                              doubleVal:789.012
                                                                boolVal:YES
                                                                  point:CGPointMake(1, 2)
                                                                   size:CGSizeMake(3, 4)
                                                                   rect:CGRectMake(1, 2, 3, 4)
                                                                  range:NSMakeRange(0, 10)
                                                                 offset:UIOffsetMake(0, -120)
                                                             edgeInsets:UIEdgeInsetsMake(1, 2, 3, 4)];
  NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:originalObject];
  XCTAssertNotNil(encodedData);
  
  DYTestObject *decodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
  XCTAssertNotNil(decodedObject);
  XCTAssertTrue([decodedObject isKindOfClass:[DYTestObject class]]);
  XCTAssertEqualObjects(originalObject, decodedObject);
}

- (void)testObjectContainsNoneCodingObject
{
  DYTestInvalidObject *invalidObject = [[DYTestInvalidObject alloc] initWithObject:[TestNoneCodingObject new]];
  XCTAssertThrowsSpecificNamed([NSKeyedArchiver archivedDataWithRootObject:invalidObject], NSException, NSInternalInconsistencyException);
}

@end
