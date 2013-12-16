#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:self.cellIdentifier];
    self.refreshControl = ({
        UIRefreshControl *rc = [UIRefreshControl new];
        [rc addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        self.maskLayer = ({
            CAShapeLayer *ml = [CAShapeLayer layer];
            ml.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
            ml.strokeColor = [UIColor whiteColor].CGColor;
            ml.lineWidth = 10.0;
            ml.fillColor = [UIColor clearColor].CGColor;
            ml.frame = ({
                CGRect f = CGRectZero;
                f.size.width = f.size.height = 32;
                f.origin.x = floorf((rc.bounds.size.width - f.size.width) / 2.0);
                f.origin.y = 14.0;
                f;
            });
            ml.path = ({
                CGPoint pathCenter = { .x = ml.frame.size.width / 2.0, .y = ml.frame.size.height / 2.0 };
                CGFloat (^degreesToRadians)(CGFloat) = ^CGFloat(CGFloat deg) { return deg * M_PI / 180; };
                CGFloat startAngle = degreesToRadians(-100);
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathAddArc(path, NULL, pathCenter.x, pathCenter.y, ml.lineWidth, startAngle, startAngle + degreesToRadians(360), false);
                path;
            });
            ml;
        });
        [rc.layer addSublayer:self.maskLayer];
        rc;
    });
    [self addKVO];
}

#pragma mark Actions

- (void)refresh:(UIRefreshControl *)sender
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.maskLayer.opacity = 0.0;
    [CATransaction commit];

    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [sender endRefreshing];
        self.maskLayer.opacity = 1.0;
    });
}

#pragma mark KVO

- (void)addKVO
{
    [self addObserver:self
           forKeyPath:@"tableView.contentOffset"
              options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
              context:self.contentOffsetContext];
}

- (void)removeKVO
{
    [self removeObserver:self forKeyPath:@"tableView.contentOffset" context:self.contentOffsetContext];
}

- (void *)contentOffsetContext { static void *kContentOffsetCtx = &kContentOffsetCtx; return kContentOffsetCtx; }

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == self.contentOffsetContext) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.maskLayer.strokeStart = (offset.y - -80) / -105;;
        [CATransaction commit];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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

#pragma mark Object lifecycle

- (void)dealloc
{
    [self removeKVO];
}

@end
