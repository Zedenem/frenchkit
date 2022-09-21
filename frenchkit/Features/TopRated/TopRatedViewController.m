#import "TopRatedViewController.h"
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
  [self fetchNextPage];
}

- (void)fetchNextPage {
  __weak typeof(self) weakSelf = self;
  [self.api objc_fetchTopRatedWithPage:self.nextPage
                        completion:^(TopRatedResponse *topRatedResponse, NSError *error) {
    if (topRatedResponse != nil) {
      __strong typeof(weakSelf) strongSelf = weakSelf;
      [strongSelf.jokes addObjectsFromArray:topRatedResponse.results];
      strongSelf.nextPage = topRatedResponse.nextPage;
      dispatch_async(dispatch_get_main_queue(), ^{
        [strongSelf reloadData];
      });
    }
  }];
}

- (void)reloadData {
  [self.tableView.refreshControl endRefreshing];
  [self.tableView reloadData];
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
  return cell;
}

@end
