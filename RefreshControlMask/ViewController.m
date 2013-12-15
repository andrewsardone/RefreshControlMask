#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CALayer *maskLayer;
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
        self.maskLayer = ({
            CALayer *ml = [CALayer layer];
            ml.frame = ({
                CGRect f = CGRectZero;
                f.size.width = f.size.height = 32;
                f.origin.x = floorf((rc.bounds.size.width - f.size.width) / 2.0);
                f.origin.y = 12.0;
                f;
            });
            ml.cornerRadius = ml.frame.size.width / 2.0;
            ml.backgroundColor = [UIColor redColor].CGColor;
            ml;
        });
        [rc.layer addSublayer:self.maskLayer];
        rc;
    });
}

#pragma mark Actions

- (void)refresh:(UIRefreshControl *)sender
{
    self.maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [sender endRefreshing];
        self.maskLayer.backgroundColor = [UIColor redColor].CGColor;
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
