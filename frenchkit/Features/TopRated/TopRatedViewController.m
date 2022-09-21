#import "frenchkit-Swift.h"
#import "TopRatedViewController.h"
#import "TopRatedViewModel.h"
#import "UIColor+DesignSystem.h"

@interface TopRatedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TopRatedViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TopRatedViewController

- (instancetype)initWithAPI:(APIService *)api {
  if (self = [super initWithNibName:nil bundle:nil]) {
    self.viewModel = [[TopRatedViewModel alloc] initWithAPI:api];

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
  [self.tableView.refreshControl endRefreshing];
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
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
  cell.textLabel.text = [self.viewModel jokeAtIndex:indexPath.row].text;
  cell.textLabel.numberOfLines = 0;
  cell.backgroundColor = indexPath.row % 2 == 1 ? [UIColor listItemOddBackgroundColor] : [UIColor listItemEvenBackgroundColor];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row > self.viewModel.numberOfJokes - 3) {
    [self fetchNextPage];
  }
}

@end
