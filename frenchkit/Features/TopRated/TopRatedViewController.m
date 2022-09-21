#import "TopRatedViewController.h"
#import "UIColor+DesignSystem.h"
#import "frenchkit-Swift.h"

@interface TopRatedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<Joke *> *jokes;
@property (nonatomic, assign) NSInteger nextPage;
@property (nonatomic, strong) APIService *api;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TopRatedViewController

- (instancetype)initWithAPI:(APIService *)api {
  if (self = [super initWithNibName:nil bundle:nil]) {
    self.api = api;
    self.jokes = [NSMutableArray array];
    self.nextPage = 1;

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.view addSubview:self.tableView];
  self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
  [NSLayoutConstraint activateConstraints:@[
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
  ]];
  
  [self fetchNextPage];
}

- (void)refresh {
  self.nextPage = 1;
  [self.jokes removeAllObjects];
  [self.tableView reloadData];
  [self fetchNextPage];
}

- (void)fetchNextPage {
  __weak typeof(self) weakSelf = self;
  [self.api objc_fetchTopRatedWithPage:self.nextPage
                        completion:^(TopRatedResponse *topRatedResponse, NSError *error) {
    if (topRatedResponse != nil) {
      __strong typeof(weakSelf) strongSelf = weakSelf;
      strongSelf.nextPage = topRatedResponse.nextPage;
      dispatch_async(dispatch_get_main_queue(), ^{
        [strongSelf reloadDataWithJokes:topRatedResponse.results];
      });
    }
  }];
}

- (void)reloadDataWithJokes:(NSArray<Joke *> *)newJokes {
  [self.tableView.refreshControl endRefreshing];
  NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:newJokes.count];
  for (int i = (int)self.jokes.count; i < self.jokes.count + newJokes.count; i++) {
    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
  }
  [self.tableView beginUpdates];
  [self.jokes addObjectsFromArray:newJokes];
  [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.tableView endUpdates];
}

// MARK: - UITableViewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.jokes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
  cell.textLabel.text = self.jokes[indexPath.row].text;
  cell.textLabel.numberOfLines = 0;
  cell.backgroundColor = indexPath.row % 2 == 1 ? [UIColor listItemOddBackgroundColor] : [UIColor listItemEvenBackgroundColor];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row > self.jokes.count - 3) {
    [self fetchNextPage];
  }
}

@end
