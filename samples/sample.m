// Line comment
/*
 * Block comment
 */
/**
 * Documentation comment
 * @param value the input value
 */

#import <Foundation/Foundation.h>
#import "MyHeader.h"

#define MAX_COUNT 100
#pragma mark - Constants

extern NSString * const kMyNotificationName;

typedef NS_ENUM(NSInteger, MyStatus) {
    MyStatusUnknown = 0,
    MyStatusActive,
    MyStatusInactive
};

typedef struct {
    CGFloat width;
    CGFloat height;
} MySize;

@protocol MyDelegate <NSObject>
- (void)didUpdateValue:(NSInteger)value;
@optional
- (void)didFail:(NSError *)error;
@end

@interface MyClass : NSObject <MyDelegate, NSCopying>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, weak) id<MyDelegate> delegate;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, copy) NSArray<NSString *> *items;
@property (nonatomic, readonly) NSInteger count;

- (instancetype)initWithName:(NSString *)name;
+ (instancetype)sharedInstance;

@end

@implementation MyClass {
    NSInteger _internalCounter;
}

@synthesize count = _count;

+ (instancetype)sharedInstance {
    static MyClass *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = [name copy];
        _internalCounter = 0;
        self.isEnabled = YES;
    }
    return self;
}

- (void)processItems:(NSArray *)items completion:(void (^)(BOOL success, NSError *error))completion {
    if (items.count == 0 || items == nil) {
        NSLog(@"No items to process: %@", @(items.count));
        return;
    }

    for (NSString *item in items) {
        @try {
            NSInteger index = [items indexOfObject:item];
            float ratio = (float)index / (float)items.count;
            NSLog(@"Processing '%@' at %.2f%%", item, ratio * 100);
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception.reason);
        }
        @finally {
            _internalCounter++;
        }
    }

    SEL selector = @selector(didUpdateValue:);
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate didUpdateValue:_internalCounter];
    }

    if (completion) {
        completion(YES, nil);
    }
}

- (void)dealloc {
    NSLog(@"%@ deallocated", self.name);
}

@end
