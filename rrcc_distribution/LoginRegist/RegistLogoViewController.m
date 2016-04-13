//
//  RegistLogoViewController.m
//  rrcc_sj
//
//  Created by lawwilte on 15-5-20.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "RegistLogoViewController.h"
#import "CheckUserInfoViewController.h"

@interface RegistLogoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSInteger ButtTag ;
    NSString *EndBase64Str;
    NSString *UrlStr;
    NSString *endStr;
    UIImagePickerController  *ImgPic;//图片上传的
    __weak IBOutlet UIImageView *UserCardImgFront;
    __weak IBOutlet UIImageView *UserCardImgBack;
    __weak IBOutlet UIImageView *UserLogoImg;
}
@end

@implementation RegistLogoViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"注册";
    UserCardImgFront.image = [UIImage imageNamed:@"HumnImg1.png"];
    UserCardImgBack.image  = [UIImage imageNamed:@"HumnImg2.png"];
    UserLogoImg.image = [UIImage imageNamed:@"HumnImg3.png"];
}


-(IBAction)PhotoGraph:(id)sender{
    NSInteger tag = [sender tag];
    ButtTag = tag;
    if (ButtTag == 101){
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选取", nil];
        action.delegate=self;
        [action showInView:self.view];
    }
    if (ButtTag == 102){
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选取", nil];
        action.delegate=self;
        [action showInView:self.view];
    }
    if (ButtTag == 103){
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选取", nil];
        action.delegate=self;
        [action showInView:self.view];
    }
}


-(IBAction)SubmitClicked:(id)sender{
    //提交图片
    if ([UserCardImgFront.image isEqual:[UIImage imageNamed:@"HumnImg1.png"]] ||  [UserCardImgBack.image isEqual:[UIImage imageNamed:@"HumnImg2.png"]] || [UserLogoImg.image isEqual:[UIImage imageNamed:@"HumnImg3.png"]]){
        [[Utility Share] alertTitle:@"请添加图片"];
    }else{
        NSString *Frontbas64 =  [[Utility Share] image2DataURL:UserCardImgFront.image];
        NSString *BackBase64 =  [[Utility Share] image2DataURL:UserCardImgBack.image];
        NSString *UserLogoBase64 = [[Utility Share] image2DataURL:UserLogoImg.image];
        NSString *PayLoad = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"card1=",Frontbas64,@"&",@"card2=",BackBase64,@"&",@"logo=",UserLogoBase64];
        NSString *PayLoadStr  = [[Utility Share] base64Encode:PayLoad];
        
        //私钥是验证码的Md5
        NSString *priviteKeyStr =  [[Utility Share] captchCode].md5;
        NSString *TimeStamp     =  [[Utility Share] GetUnixTime];
        NSString *PublicKey     =  [NSString stringWithFormat:@"%@%@%@%@",priviteKeyStr,[[Utility Share] userId],TimeStamp,PayLoadStr].md5;
        //配置URl
        NSString *baseUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",BASEURL,Photo,[[Utility Share] userId],@"?t=",TimeStamp,@"&uid=",[[Utility Share] userId],@"&k=",PublicKey];
        NSString *bodyStr = [[RestHttpRequest SharHttpRequest] GetHttpBody:PayLoadStr];
        //获得URl 并发送网络请求
        [[Utility Share] showHud];
        NSURL *url = [NSURL URLWithString:baseUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:50];
        [request setHTTPMethod:@"PUT"];
        [request setHTTPBody: [bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
            if ([[responseObject objectForJSONKey:@"Success"] isEqualToString:@"1"]){
                [[Utility Share] alertTitle:@"注册成功,请等待审核!"];
                CheckUserInfoViewController *ChecView = [[CheckUserInfoViewController alloc] init];
                [self pushNewViewController:ChecView];
            }else{
                [[Utility Share] alertTitle:@"注册失败,请重新注册!"];
            }
            [[Utility Share] hideHud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [[Utility Share] hideHud];
        }];
        [op start];
    }
}

//相机

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!ImgPic){
        
        ImgPic=[[UIImagePickerController alloc]init];
    }
    if (buttonIndex==0) {
        //判断当前相机是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){// 打开相机
            ImgPic.sourceType = UIImagePickerControllerSourceTypeCamera;
            //设置是否可编辑
            ImgPic.allowsEditing = YES;
            ImgPic.delegate=self;
            //打开
            [self presentViewController:ImgPic animated:YES completion:^{
                
            }];
        }else{
            //如果不可用
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"设备不可用..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            [alert show];
        }
    }else if(buttonIndex==1){
        // [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
        //打开相册
        ImgPic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置是否可编辑
        ImgPic.allowsEditing = YES;
        ImgPic.delegate=self;
        [self presentViewController:ImgPic animated:YES completion:^{
        }];
    }
}
//设备协议
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获得编辑过的图片
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    //处理图片
    UIImage *logo = [self imageCompressForWidth:image targetWidth:150.0];
    NSData *imageData = UIImageJPEGRepresentation(logo,0.5);
    if (ButtTag == 101){
        UserCardImgFront.image = [UIImage imageWithData:imageData];
        //logo;
    }
    if (ButtTag == 102){
        UserCardImgBack.image = [UIImage imageWithData:imageData];
    }
    if (ButtTag == 103){
        UserLogoImg.image = [UIImage imageWithData:imageData];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
//压缩图片


-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
