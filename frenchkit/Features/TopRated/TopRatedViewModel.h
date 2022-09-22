#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol APIServicing;
@class Joke;

@interface TopRatedViewModel : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAPI:(id<APIServicing>)api NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSInteger numberOfJokes;

- (void)reset;
- (void)fetchNextPageWithCompletion:(void (^)(NSArray<Joke *> *newJokes, NSError *error))completion;

- (Joke *)jokeAtIndex:(NSInteger)index;
- (void)toggleFavoriteJokeAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
