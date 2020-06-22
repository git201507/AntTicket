//
//  UploadPhotoViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "UploadPhotoViewController.h"
#import "BasicUserDef.h"
#import "UITableView+Cell.h"
//#import "GlobleURL.h"
//#import "AFNRequestData.h"
//#import "BasicMoneyAccountDef.h"
#import "BasicToastInterFace.h"
#import "BasicUserInterFace.h"
//#import "BasicMessageInterFace.h"
//#import "UserMoneyAccountUpdater.h"
#import "UIColor+Hex.h"
//#import "GlobleData.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>

@interface UploadPhotoViewController ()
{
@private
    NSString *TMP_UPLOAD_IMG_PATH;

}

@end

@implementation UploadPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TMP_UPLOAD_IMG_PATH = @"";  //上传图片的路径初期化
    
    UIImage *img = [UIImage imageNamed:@"pic_jchd"];
    float scale = (self.view.bounds.size.width - 20.f) / 400;
    
    _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20.f, 331 * scale)];
    
    UIImage *newImg = [self imageWithImageSimple:img scaledToSize:CGSizeMake(400, 331)];
    [newImg setAccessibilityIdentifier:@"pic_jchd"];
    _photoImageView.image = newImg;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if ([[_photoImageView.image accessibilityIdentifier] isEqualToString:@"pic_jchd"])
//    {
//        UIImage *img = [UIImage imageNamed:@"pic_jchd"];
//        float scale = (self.view.bounds.size.width - 20.f) / 400;
//        
//        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20.f, 331 * scale)];
//        
//        UIImage *newImg = [self imageWithImageSimple:img scaledToSize:CGSizeMake(400, 331)];
//        [newImg setAccessibilityIdentifier:@"pic_jchd"];
//        _photoImageView.image = newImg;
//        [_tableView reloadData];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写或继承base中的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

#pragma mark - 与xib关联的方法
- (IBAction)showPhotoMenu
{
    [self.view endEditing:NO];
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [actionsheet showInView:self.view];
}
#pragma mark - 自己的方法
- (void)uploadPhotoImage
{
    if ([[_photoImageView.image accessibilityIdentifier] isEqualToString:@"pic_jchd"])
    {
        [BasicToastInterFace showToast:@"上传图片不能为空!  "];
        return;
    }
    [BasicToastInterFace showToast:@"上传图片成功!  "];
//    NSString *taskNameStr =@"UploadPhoto";

//    NSData *photoData = UIImageJPEGRepresentation(_photoImageView.image, 0.8);
//    [self callNetTaskWithName:taskNameStr lastURL:AccountManage_UploadPhoto fileName:@"file" reqData:photoData finishCallbackBlock:^(NSDictionary *infoDic, BOOL isSuccess)
//     {
//         [NSSLoadingInterFace hideLoadingWithNameID:taskNameStr];
//         
//         if (!isSuccess)
//         {
//             return;
//         }
//         
//         _comMemberInfoRec.data.avatar = [infoDic objectForKeyByNSS:@"data"];
//         [NSSToastInterFace showToast:@"您的头像修改成功! "];
//         
//         [_tableView reloadData];
//     }];
//
}

- (void)cancelUpload
{
    UIImage *img = [UIImage imageNamed:@"pic_jchd"];
    float scale = (self.view.bounds.size.width - 20.f) / 400;
    
    _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20.f, 331 * scale)];
    
    UIImage *newImg = [self imageWithImageSimple:img scaledToSize:CGSizeMake(400, 331)];
    [newImg setAccessibilityIdentifier:@"pic_jchd"];
    _photoImageView.image = newImg;
    [_tableView reloadData];
}

- (UIImage *)imageWithImageSimple:(UIImage *) image scaledToSize:(CGSize) newSize
{
    newSize.height = image.size.height * (newSize.width / image.size.width);
    
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return  newImage;
}

- (NSString *)generateUuidString
{
    // 创建自己的uuid
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    //创建字符串
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSLog(@"===TMP_UPLOAD_IMG_PATH===%@",TMP_UPLOAD_IMG_PATH);
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    // and then we write it out
    TMP_UPLOAD_IMG_PATH = fullPathToFile;
    NSArray *nameAry = [TMP_UPLOAD_IMG_PATH componentsSeparatedByString:@"/"];
    NSLog(@"==new fullPathToFile==%@", fullPathToFile);
    NSLog(@"==new FileName==%@", [nameAry objectAtIndex:[nameAry count]-1]);
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:fullPathToFile forKey:@"photohasloaded"];
}


- (void)photograp
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if (![self canUseCamera]) {
            return;
        }
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;  //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //        [self presentModalViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    else
    {
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有摄像头" delegate:nil cancelButtonTitle:@"取消!" otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)canUseCamera
{
    //判断相机是否能够使用
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
        // authorized
        return YES;
    } else if(status == AVAuthorizationStatusDenied){
        // denied
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"此应用没有权限访问您的相机。您可以在“隐私设置“中启用访问。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    } else if(status == AVAuthorizationStatusRestricted){
        // restricted
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"此应用没有权限访问您的相机。您可以在“隐私设置“中启用访问。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    } else if(status == AVAuthorizationStatusNotDetermined)
    {
        // not determined
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
         {
             if(granted){
                 UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                 picker.delegate = self;
                 picker.allowsEditing = YES;  //是否可编辑
                 //摄像头
                 picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                 //        [self presentModalViewController:picker animated:YES];
                 [self presentViewController:picker animated:YES completion:nil];
             }
             else {
                 
             }
         }];
        return NO;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"此应用没有权限访问您的相机。您可以在“隐私设置“中启用访问。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    return NO;
}

// 相册
- (void)toPhotoAlbum
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    //    [self presentModalViewController:imagePicker animated:YES];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - 代理方法

//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 55;
    }
    if (indexPath.row == 1)
    {
        return 55;
    }
    if (indexPath.row == 2)
    {
        return 55;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return _photoImageView.bounds.size.height + 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, _photoImageView.bounds.size.height + 100)];
    [view addSubview:_photoImageView];
    
    UIButton *confirmBtn= [[UIButton alloc] initWithFrame:CGRectMake(10, _photoImageView.bounds.size.height + 20, (self.view.bounds.size.width - 40) / 2, 50)];
    [confirmBtn setBackgroundColor:[UIColor redColor]];
    [confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(uploadPhotoImage) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.cornerRadius = 5.f;
    [view addSubview:confirmBtn];
    UIButton *cancelBtn= [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 + 10, _photoImageView.bounds.size.height + 20, (self.view.bounds.size.width - 40) / 2, 50)];
    [cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"#acacac"]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelUpload) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.cornerRadius = 5.f;
    [view addSubview:cancelBtn];
    return view;
}

//tableview的section设定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell = nil;


    if (indexPath.row == 0)
    {
        cell = [tableView makeCellByIdentifier:@"UploadLabelCell"];
        UIImageView *img = [cell viewWithTag:10];
        img.image = [UIImage imageNamed:@"ico_smrz"];
        
        UITextField *tField = [cell viewWithTag:20];
        tField.keyboardType = UIKeyboardTypeDefault;
        
        AccountInfo *accountInfo = [[AccountInfo alloc] init];
        [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
        tField.text = accountInfo.name;
    }
    else if (indexPath.row == 1)
    {
        cell = [tableView makeCellByIdentifier:@"UploadLabelCell"];
        UIImageView *img = [cell viewWithTag:10];
        img.image = [UIImage imageNamed:@"ico_phone"];
        
        UITextField *tField = [cell viewWithTag:20];
        tField.keyboardType = UIKeyboardTypeNumberPad;
        
        AccountInfo *accountInfo = [[AccountInfo alloc] init];
        [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
        tField.text = accountInfo.mobile;
    }
    else if (indexPath.row == 2)
    {
        cell = [tableView makeCellByIdentifier:@"UploadButtonCell"];
    }
    
    return cell;
}

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 2)
    {
        [self showPhotoMenu];
    }
}


#pragma mark ActionSheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    switch (buttonIndex)
    {
        case 0:
        {
            [self photograp];
            break;
        }
        case 1:
        {
            [self toPhotoAlbum];
            break;
        }
        default:
            break;
    }
}

#pragma mark UIImagePickerController Delegate Methods
//返回选取的图片
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    
    UIImage *img = [editingInfo objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(img, nil, nil,nil);
    }
    
    float scale = (self.view.bounds.size.width - 20.f) / img.size.width;
    
    _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20.f, img.size.height * scale)];
    
    UIImage *newImg = [self imageWithImageSimple:img scaledToSize:CGSizeMake(self.view.bounds.size.width - 20.f, img.size.height * scale)];
    [newImg setAccessibilityIdentifier:@"customed"];
    _photoImageView.image = newImg;

    [_tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//选取结束时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self  dismissViewControllerAnimated:YES completion:nil];
}

@end
