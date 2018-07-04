//
//  ViewController.m
//  CompressedPictureDemo
//
//  Created by 毛织网 on 2018/6/25.
//  Copyright © 2018年 CDY. All rights reserved.
//

#define Beginning_Head @"http://new.taoshamall.com/ios/"//通用前缀
#import "ViewController.h"
#import "WPhotoViewController.h"
#import "ResetSizeImage.h"
#import "AFNetworking.h"
#import "PureCamera.h"
#import "CDYPictureUploading.h"
#import "LQPhotoViewCell.h"
#define phoneScale [UIScreen mainScreen].bounds.size.width/720.0

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIButton *_addBut;
    UITableView *_tableView;
    NSMutableArray *_photosArr;
    NSString *pushImgName;
    //添加图片提示
    UILabel *addImgStrLabel;
}
@property(nonatomic,strong)NSMutableArray *imagearr;
@property(nonatomic,strong) UICollectionView *pickerCollectionView;
@property(nonatomic,assign) CGFloat collectionFrameY;
@end

@implementation ViewController
static NSString * const reuseIdentifier = @"LQPhotoViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createTableView];
    
    _addBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBut.frame = CGRectMake(0, self.view.frame.size.height-(60+160)*phoneScale, [UIScreen mainScreen].bounds.size.width, 160*phoneScale);
    _addBut.layer.masksToBounds = YES;
//    [_addBut setImage:[UIImage imageNamed:@"1.2.1-CreateNew"] forState:UIControlStateNormal];
    [_addBut setBackgroundColor:[UIColor redColor]];
    [_addBut setTitle:@"添加" forState:UIControlStateNormal];
    [_addBut addTarget:self action:@selector(addButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addBut];
    
}

-(void)addButClick
{
    //弹出警告框
    //1.创建 警告框 实例
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //2.创建 收集用户意图的按键
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self paizhao];
        
    }];
    //2.创建 收集用户意图的按键
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"系统相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self xiangce];
        
    }];
    //2.创建 收集用户意图的按键
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    //3.将 action 添加到 alertController 身上
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    //4.让警告框呈现出来
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)paizhao{
    if (_photosArr.count==0) {
        _photosArr = [[NSMutableArray alloc]init];
    }
    if (_imagearr.count==0) {
        self.imagearr =[[NSMutableArray alloc]init];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        PureCamera *homec = [[PureCamera alloc] init];
        __weak typeof(self) myself = self;
        homec.fininshcapture = ^(UIImage *ss) {
            if (ss) {
                NSLog(@"照片存在");
                
                ss= ss.fixOrientation;
                [_photosArr addObject:[self createDicImage:ss]];
                NSLog(@"asd %@ %@",_photosArr,[self createDicImage:ss]);
//
//                NSData *data =[[ResetSizeImage alloc]resetSizeOfImageDataMethodTwo:ss maxSize:80];//maxSize等比例压缩 后面填你需要压缩这张图片剩下多少KB之内
//                NSString *urlstring =[NSString stringWithFormat:@""];
//                NSDictionary *dic = @{@"":@""};//需要穿的参数 如果不需要穿就在parems:nil
//                [CDYPictureUploading postimageWithURL:urlstring//请求链接
//                                    postParems:dic//字典
//                                    imagedata:data//图片 我这个是单张上传 如果需要多张就去改成数组即可
//                                    picFileName:@"file" //这个是关键  一定要和后台一致
//                                    andCallback:^(id data) {
//                    NSLog(@"返回值%@,%@,%@",data,data[@"info"],data[@"status"]);
//                     [self.imagearr addObject:data[@"info"]];
//                }];

                
                [_pickerCollectionView reloadData];
            }
        };
        [myself presentViewController:homec
                             animated:NO
                           completion:^{
                           }];
    } else {
        NSLog(@"相机调用失败");
    }
}
-(void)xiangce{
    if (_photosArr.count==0) {
        _photosArr = [[NSMutableArray alloc]init];
    }
    if (_imagearr.count==0) {
        self.imagearr =[[NSMutableArray alloc]init];
    }
    
    WPhotoViewController *WphotoVC = [[WPhotoViewController alloc] init];
    //选择图片的最大数
    WphotoVC.selectPhotoOfMax = 5;
    [WphotoVC setSelectPhotosBack:^(NSMutableArray *phostsArr) {
        
        for (int i =0; i<phostsArr.count; i++) {
            [_photosArr addObject:phostsArr[i]];
            NSLog(@"asd %@",_photosArr);
//            NSData *data =[[ResetSizeImage alloc]resetSizeOfImageDataMethodTwo:_photosArr[i][@"image"] maxSize:80];//maxSize等比例压缩 后面填你需要压缩这张图片剩下多少KB之内
//            NSString *urlstring =[NSString stringWithFormat:@""];
//            NSDictionary *dic = @{@"":@""};//需要穿的参数 如果不需要穿就在parems:nil
//            [CDYPictureUploading postimageWithURL:urlstring//请求链接
//                                postParems:dic//字典
//                                imagedata:data//图片 我这个是单张上传 如果需要多张就去改成数组即可
//                                picFileName:@"file" //这个是关键  一定要和后台一致
//                                andCallback:^(id data) {
//                NSLog(@"返回值%@,%@,%@",data,data[@"info"],data[@"status"]);
//                 [self.imagearr addObject:data[@"info"]];
//            }];

            
            
        }
        
        
        [_pickerCollectionView reloadData];
        
    }];
    [self presentViewController:WphotoVC animated:YES completion:nil];
}
-(void)createTableView
{
    
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
    self.pickerCollectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.view addSubview:self.pickerCollectionView];
    self.pickerCollectionView.delegate=self;
    self.pickerCollectionView.dataSource=self;
    self.pickerCollectionView.backgroundColor = [UIColor whiteColor];
    pushImgName = @"login_upload_pictures";
    
    //添加图片提示
    addImgStrLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 63, 20)];
    [self.pickerCollectionView addSubview:addImgStrLabel];
    addImgStrLabel.text = @"上传凭证";
    addImgStrLabel.font = [UIFont systemFontOfSize:15];
    addImgStrLabel.textColor = [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1.0];
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(addImgStrLabel.frame.origin.x+addImgStrLabel.frame.size.width+1, 0, 100, 20)];
    label1.text = @"(最多5张)";
    label1.font = [UIFont systemFontOfSize:13];
    label1.textAlignment=NSTextAlignmentLeft;
    label1.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    [self.pickerCollectionView addSubview:label1];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photosArr.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Register nib file for the cell
    UINib *nib = [UINib nibWithNibName:@"LQPhotoViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"LQPhotoViewCell"];
    // Set up the reuse identifier
    LQPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"LQPhotoViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == _photosArr.count) {
        [cell.profilePhoto setImage:[UIImage imageNamed:pushImgName]];
        cell.closeButton.hidden = YES;
        
    }
    else{
        NSData * data =  [[ResetSizeImage alloc]resetSizeOfImageDataMethodTwo:[[_photosArr objectAtIndex:indexPath.row] objectForKey:@"image"] maxSize:200];
        cell.profilePhoto.image =[UIImage imageWithData:data];
        cell.closeButton.hidden = NO;
    }
    [cell setBigImgViewWithImage:nil];
    cell.profilePhoto.tag = [indexPath item];
    
    //添加图片cell点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    cell.profilePhoto .userInteractionEnabled = YES;
    [cell.profilePhoto  addGestureRecognizer:singleTap];
    cell.closeButton.tag = [indexPath item];
    [cell.closeButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    [self changeCollectionViewHeight];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-64) /4 ,([UIScreen mainScreen].bounds.size.width-64) /4);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(30, 8, 20, 8);
}

#pragma mark - 图片cell点击事件
- (void) tapProfileImage:(UITapGestureRecognizer *)gestureRecognizer{
    UIImageView *tableGridImage = (UIImageView*)gestureRecognizer.view;
    NSInteger index = tableGridImage.tag;
    
    if (index == (_photosArr.count)) {
        [self.view endEditing:YES];
        //添加新图片
        [self addButClick];
    }
    
}
#pragma mark - 删除照片
- (void)deletePhoto:(UIButton *)sender{
    
    [_photosArr removeObjectAtIndex:sender.tag];
    
    
    
    [self.pickerCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:sender.tag inSection:0]]];
    
    for (NSInteger item = sender.tag; item <= _photosArr.count; item++) {
        LQPhotoViewCell *cell = (LQPhotoViewCell*)[self.pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
        cell.closeButton.tag--;
        cell.profilePhoto.tag--;
    }
    
    [self changeCollectionViewHeight];
}
#pragma mark - 改变view，collectionView高度
- (void)changeCollectionViewHeight{
    
    if (_collectionFrameY) {
        _pickerCollectionView.frame = CGRectMake(0, _collectionFrameY, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /4.0 +20.0)* ((int)(_photosArr.count)/4 +1)+20.0);
    }
    else{
        _pickerCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /4.0 +20.0)* ((int)(_photosArr.count)/4 +1)+20.0);
    }
    //    if (_LQPhotoPicker_delegate && [_LQPhotoPicker_delegate respondsToSelector:@selector(LQPhotoPicker_pickerViewFrameChanged)]) {
    //        [_LQPhotoPicker_delegate LQPhotoPicker_pickerViewFrameChanged];
    //    }
}
- (void)LQPhotoPicker_updatePickerViewFrameY:(CGFloat)Y{
    
    _collectionFrameY = Y;
    _pickerCollectionView.frame = CGRectMake(0, Y, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /4.0 +20.0)* ((int)(_photosArr.count)/4 +1)+20.0);
    
}



-(NSDictionary *)createDicImage:(UIImage *)image
{
    NSString*imgSize = NSStringFromCGSize(image.size);
    NSArray *allArr = [imgSize componentsSeparatedByString:@","];
    NSArray *firstArr = [allArr[0] componentsSeparatedByString:@"{"];
    NSArray *secondArr = [allArr[1] componentsSeparatedByString:@"}"];
    //宽
    CGFloat width = [firstArr[1] floatValue];
    //高
    CGFloat height = [secondArr[0] floatValue];
    if (width>720.0) {
        height = height*720.0/width;
        width = 720.0;
    }
    NSDictionary *dic = @{@"image":image};
    return dic;
}
@end
