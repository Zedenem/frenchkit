#import "frenchkit-Swift.h"
#import "TopRatedViewModel.h"

@interface TopRatedViewModel ()

@property (nonatomic, strong) APIService *api;
@property (nonatomic, strong) NSMutableArray<Joke *> *jokes;
@property (nonatomic, assign) NSInteger nextPage;

@end

@implementation TopRatedViewModel

- (instancetype)initWithAPI:(APIService *)api {
  if (self = [super init]) {
    self.api = api;
    self.jokes = [NSMutableArray array];
    self.nextPage = 1;
  }
  return self;
}

- (NSInteger)numberOfJokes {
  return self.jokes.count;
}

- (void)reset {
  self.nextPage = 1;
  [self.jokes removeAllObjects];
}

- (void)fetchNextPageWithCompletion:(void (^)(NSArray<Joke *> *newJokes, NSError *error))completion {
  __weak typeof(self) weakSelf = self;
  [self.api objc_fetchTopRatedWithPage:self.nextPage
                            completion:^(TopRatedResponse *topRatedResponse, NSError *error) {
    if (error != nil) {
      completion(nil, error);
    } else if (topRatedResponse != nil) {
      __strong typeof(weakSelf) strongSelf = weakSelf;
      strongSelf.nextPage = topRatedResponse.nextPage;
      [strongSelf.jokes addObjectsFromArray:topRatedResponse.results];
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(topRatedResponse.results, nil);
      });
    }
  }];
}

- (Joke *)jokeAtIndex:(NSInteger)index {
  if (index < 0 && index >= self.jokes.count) {
    return nil;
  }
  return self.jokes[index];
}

@end
