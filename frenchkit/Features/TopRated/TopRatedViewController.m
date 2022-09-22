#import "frenchkit-Swift.h"
#import "TopRatedViewController.h"
#import "TopRatedViewModel.h"
#import "UIColor+DesignSystem.h"

@interface TopRatedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TopRatedViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TopRatedViewController

- (instancetype)initWithAPI:(id<APIServicing>)api {
  if (self = [super initWithNibName:nil bundle:nil]) {
    self.viewModel = [[TopRatedViewModel alloc] initWithAPI:api];

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JokeTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([JokeTableViewCell class])];
    
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
  [self.tableView.refreshControl endRefreshing];
  [self.viewModel reset];
  [self.tableView reloadData];
  [self fetchNextPage];
}

- (void)fetchNextPage {
  __weak typeof(self) weakSelf = self;
  [self.viewModel fetchNextPageWithCompletion:^(NSArray<Joke *> *newJokes, NSError *error) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (error == nil) {
      [strongSelf reloadData];
    }
  }];
}

- (void)reloadData {
  [self.tableView reloadData];
}

// MARK: - UITableViewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.viewModel.numberOfJokes;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  JokeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JokeTableViewCell class])];
  
  Joke *joke = [self.viewModel jokeAtIndex:indexPath.row];
  
  [cell updateWith:joke.text isFavorite:[FavoritesService.shared isFavoriteWithJokeWithId:joke.id]];
  
  __weak typeof(self) weakSelf = self;
  [cell setDidTapFavoritesButton:^{
    __strong typeof(weakSelf) strongSelf = weakSelf;
    [strongSelf.viewModel toggleFavoriteJokeAtIndex:indexPath.row];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }];
  
  cell.backgroundColor = indexPath.row % 2 == 1 ? [UIColor listItemOddBackgroundColor] : [UIColor listItemEvenBackgroundColor];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

@end
