//
//  SettingsViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/10.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "SettingsViewController.h"
#import "BasicAccountInterFace.h"
#import "BasicChangePasswordOldPwdView.h"
#import "UIWindow+NSSViewCell.h"
#import "BasicViewCellAdmin.h"
#import "UIColor+Hex.h"
#import "UserMoneyAccountUpdater.h"
#import "BasicMoneyAccountDef.h"
#import "BasicUserDef.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "GlobleData.h"
#import "UIImageView+WebCache.h"

@interface SettingsViewController ()
{
    NSString *_codeUrl;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
    [doubleTap setNumberOfTapsRequired:3];
    [self.view addGestureRecognizer:doubleTap];
    
    self.title = @"账户设置";
    [self get2dCodeImage];
}
#pragma mark - 重写或继承base中的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MainZhongJin"])
    {
        id seg = segue.destinationViewController;
        
        [seg setValue:sender forKey:@"ipsAccount"];
    }
}

#pragma mark -- 自己的方法
- (void)get2dCodeImage
{
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    //请求参数
    //readStateType
    //pageNo
    //pageSize
    //ownerId
    
    NSMutableDictionary *params = [@{@"memberId":accountInfo.userId} mutableCopy];

    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Settings_App2DCodeURL];
    
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         NSLog(@"%@",respData);
         
         VerifyVipCodeReceiveInfo *codeEntity = [[VerifyVipCodeReceiveInfo alloc] init];
         if (![codeEntity setJsonDataWithDic:respData] || !codeEntity.state || ![codeEntity.state isEqualToString:@"1"])
         {
             return;
         }
         
         _codeUrl = codeEntity.msg;
         [_tableView reloadData];
     } failure:^(NSError *error)
     {
         NSLog(@"%@",[error description]);
         
         [_tableView reloadData];
     }];
}

- (void)handleDoubleTap
{
    //    if([_act isAnimating])
    //    {
    //        [_act stopAnimating];
    //    }
}

#pragma mark -- UITableViewDataSource
//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        return 150;
    }
    return 0;
}


//tableview的section设定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != 4)
    {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 150)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    UIImageView *codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width/2 - 50, 25, 100, 100)];
    
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 3. 将字符串转换成NSData
    NSData *data = [_codeUrl dataUsingEncoding:NSUTF8StringEncoding];
    
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 6. 将CIImage转换成UIImage，并放大显示
    codeImageView.image = [UIImage imageWithCIImage:outputImage scale:20.0 orientation:UIImageOrientationUp];
    
    [view addSubview:codeImageView];
    
    NSString *urlPath = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Settings_Get2DCodeURL(_codeUrl)];
 
    [codeImageView sd_setImageWithURL:[NSURL URLWithString:urlPath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         NSLog(@"这里可以在图片加载完成之后做些事情");
     }];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#686868"];
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    
    if (indexPath.section == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        cell.imageView.image = [UIImage imageNamed:@"ico_smrz"];
        cell.textLabel.text = @"实名认证";
    }
    else if (indexPath.section == 1)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        cell.imageView.image = [UIImage imageNamed:@"ico_ggmm"];
        cell.textLabel.text = @"更改密码";
    }
    
    else if (indexPath.section == 2)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.imageView.image = [UIImage imageNamed:@"ico_pencil"];
        cell.textLabel.text = @"支付账户签约";
        
        if([cell viewWithTag:1000])
        {
            [[cell viewWithTag:1000] removeFromSuperview];
        }
        MyAccountDetail *myAccountDetail = [UserMoneyAccountUpdater fetchUserMoneyAccountDetail];
        if([myAccountDetail.isRealNameVerify isEqualToString:@"yq"])
        {
            UILabel *yqLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 40, 15, 30, 15)];
            yqLabel.textColor = [UIColor redColor];
            yqLabel.text = @"已签";
            yqLabel.font = [UIFont systemFontOfSize:14.f];
            [cell addSubview:yqLabel];
            yqLabel.tag = 1000;
        }
    }
    else if (indexPath.section == 3)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        cell.imageView.image = [UIImage imageNamed:@"ico_smrz"];
        cell.textLabel.text = @"邀请人员列表";
    }
    else if (indexPath.section == 4)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.imageView.image = [UIImage imageNamed:@"ico_wdyqm"];
        //        cell.textLabel.text = [NSString stringWithFormat:@"我的邀请码:%@", [BasicAccountInterFace getUserNameWithAccountName:[BasicAccountInterFace getCurAccountName]]];
        
        NSMutableAttributedString *codeStr1 = [[NSMutableAttributedString alloc] initWithString:@"我的邀请码:"];
        [codeStr1 addAttribute:NSForegroundColorAttributeName
                         value:[UIColor blackColor]
                         range:NSMakeRange(0, codeStr1.length)];
        
        NSMutableAttributedString *codeStr2 = [[NSMutableAttributedString alloc] initWithString:[BasicAccountInterFace getUserNameWithAccountName:[BasicAccountInterFace getCurAccountName]]];
        
        [codeStr2 addAttribute:NSForegroundColorAttributeName
                         value:[UIColor redColor]
                         range:NSMakeRange(0, codeStr2.length)];
        
        [codeStr1 appendAttributedString:codeStr2];
        cell.textLabel.attributedText = codeStr1;
    }
    
    return cell;
}


#pragma mark -- UITableViewDelegate

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        MyAccountDetail *myAccountDetail = [UserMoneyAccountUpdater fetchUserMoneyAccountDetail];
    if (indexPath.section == 0)
    {
        if(!myAccountDetail.ipsAccount || myAccountDetail.ipsAccount.length == 0)
        {
            [self performSegueWithIdentifier:@"settingToCertificate" sender:nil];
            return;
        }
        [self performSegueWithIdentifier:@"hasCertificated" sender:nil];
        return;
    }
    
    if (indexPath.section == 1)
    {
        [self.view endEditing:NO];
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"BasicChangePassword" owner:self options:nil]; //通过这个方法,取得我们的视图
        BasicChangePasswordOldPwdView *subView = [nibViews objectAtIndex:0];
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addViewCellToManger:subView animated:[BasicViewCellAdmin class]];
    }
    

    
    if (indexPath.section == 2)
    {
        if(!myAccountDetail.ipsAccount || myAccountDetail.ipsAccount.length == 0)
        {
            [self performSegueWithIdentifier:@"settingToCertificate" sender:nil];
            return;
        }
        if([myAccountDetail.isRealNameVerify isEqualToString:@"yq"])
        {
            return;
        }
        else if([myAccountDetail.isRealNameVerify isEqualToString:@"yes"])
        {
            [self performSegueWithIdentifier:@"MainZhongJin" sender:myAccountDetail.ipsAccount];
            return;
        }
        else
        {
            [self performSegueWithIdentifier:@"settingToCertificate" sender:nil];
        }

        return;
    }

    if (indexPath.section == 3)
    {
        [self performSegueWithIdentifier:@"toInvitorList" sender:nil];
        return;
    }

}


@end
