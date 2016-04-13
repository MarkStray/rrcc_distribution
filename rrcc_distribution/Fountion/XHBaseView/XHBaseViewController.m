

#import "XHBaseViewController.h"

@interface XHBaseViewController ()

@property (nonatomic, copy) XHBarButtonItemActionBlock barbuttonItemAction;

@property (nonatomic, copy) XHBarButtonItemActionBlock backbuttonItemAction;

@end


@implementation XHBaseViewController

- (void)clickedBarButtonItemAction {
    if (self.barbuttonItemAction) {
        self.barbuttonItemAction();
    }
}

#pragma mark - Public Method

- (void)configureBarbuttonItemStyle:(XHBarbuttonItemStyle)style action:(XHBarButtonItemActionBlock)action {
    switch (style) {
        case XHBarbuttonItemStyleSetting: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonicon_set"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case XHBarbuttonItemStyleMore: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonicon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case XHBarbuttonItemStyleCamera: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"album_add_photo"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case XHBarbuttonItemStyleAdd: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
            
        default:
            break;
    }
    self.barbuttonItemAction = action;
}

- (void)configureBackBarbuttonAction:(XHBarButtonItemActionBlock)action {
    
    UIButton *barBtn = [[Utility Share] createBackButton];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:barBtn];
    self.navigationItem.leftBarButtonItem = barItem;
    [barBtn addTarget:self action:@selector(clickedBackButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.backbuttonItemAction = action;
}


- (void)clickedBackButtonItemAction{
    
    if (self.barbuttonItemAction) {
        self.barbuttonItemAction();
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupBackgroundImage:(UIImage *)backgroundImage {
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

- (void)pushNewViewController:(UIViewController *)newViewController{
    
    [self.navigationController pushViewController:newViewController animated:YES];
}

- (void)pushReplaceViewController:(UIViewController *)newViewController {
    NSArray *arr = self.navigationController.viewControllers;
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:arr];
    NSInteger nn = arr.count;
    mArr[nn-1] = newViewController;
    [self.navigationController setViewControllers:[NSArray arrayWithArray:mArr]];
}

- (void)pushRootViewController:(UIViewController *)newViewController {
    NSArray *arr = self.navigationController.viewControllers;
    NSMutableArray *mArr = [NSMutableArray arrayWithObjects:arr[0],newViewController,nil];
    [self.navigationController setViewControllers:[NSArray arrayWithArray:mArr]];
}

#pragma mark - Loading

- (void)showLoading {
    [self showLoadingWithText:nil];
}

- (void)showLoadingWithText:(NSString *)text {
    [self showLoadingWithText:text onView:self.view];
}

- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view {
    
}

- (void)showSuccess {
    
}
- (void)showError {
    
}

- (void)hideLoading {
    
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View rotation

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}



@end
