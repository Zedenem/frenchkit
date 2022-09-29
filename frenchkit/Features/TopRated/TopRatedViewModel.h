#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol API_ObjcBridging;
@class Joke;

@interface TopRatedViewModel : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAPI:(id<API_ObjcBridging>)api NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSInteger numberOfJokes;

- (void)reset;
- (void)fetchNextPageWithCompletion:(void (^)(NSArray<Joke *> * _Nullable newJokes, NSError * _Nullable error))completion;

- (nullable Joke *)jokeAtIndex:(NSInteger)index;
- (void)toggleFavoriteJokeAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
