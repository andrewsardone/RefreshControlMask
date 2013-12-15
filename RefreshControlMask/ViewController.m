#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:self.cellIdentifier];
    self.refreshControl = ({
        UIRefreshControl *rc = [UIRefreshControl new];
        [rc addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        rc;
    });
}

#pragma mark Actions

- (void)refresh:(UIRefreshControl *)sender
{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [sender endRefreshing];
    });
}

#pragma mark UITableViewDataSource

- (NSString *)cellIdentifier { return @"Cell"; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];

    return cell;
}

@end
