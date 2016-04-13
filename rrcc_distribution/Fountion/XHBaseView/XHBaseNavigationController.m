

#import "XHBaseNavigationController.h"
@interface XHBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation XHBaseNavigationController
#pragma mark 一个类只会调用一次
+ (void)initialize{

    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"NavBar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
   [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:20], NSFontAttributeName, nil]];
    
}


#pragma mark - Life cycle
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return NO;
        
    }else{

        return YES;
    }
}
- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        Class cla = NSClassFromString(@"DiscoverSearchView");
        if ([viewController isKindOfClass:cla])
        {
            
        }else{
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self creatBackButton]];
        }
    }
    [super pushViewController:viewController animated:animated];
    
}
-(UIButton*) creatBackButton
{
    UIImage* image= [UIImage imageNamed:@"BackArrow"];
    UIImage* imagef = [UIImage imageNamed:@"Arrow_press"];
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:imagef forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(onNavBack) forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}
-(void)onNavBack
{
    [self popViewControllerAnimated:YES];
}
#pragma mark - View rotation

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}



@end
