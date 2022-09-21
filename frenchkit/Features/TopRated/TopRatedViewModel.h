#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class APIService;
@class Joke;

@interface TopRatedViewModel : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAPI:(APIService *)api NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSInteger numberOfJokes;

- (void)reset;
- (void)fetchNextPageWithCompletion:(void (^)(NSArray<Joke *> *newJokes, NSError *error))completion;

- (Joke *)jokeAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
