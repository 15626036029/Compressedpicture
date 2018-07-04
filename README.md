# Compressedpicture
从选择图片-压缩-上传  简单容易上手   注释清晰

通过拍照或从相册里提取图片  然后进行压缩 随后就上传到后台
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
            NSData *data =[[ResetSizeImage alloc]resetSizeOfImageDataMethodTwo:_photosArr[i][@"image"] maxSize:80];//maxSize等比例压缩 后面填你需要压缩这张图片剩下多少KB之内
            NSString *urlstring =[NSString stringWithFormat:@""];
            NSDictionary *dic = @{@"":@""};//需要传的参数 如果不需要传就在parems:nil
            [CDYPictureUploading postimageWithURL:urlstring//请求链接
                                postParems:dic//字典
                                imagedata:data//图片 我这个是单张上传 如果需要多张就去改成数组即可
                                picFileName:@"file" //这个是关键  一定要和后台一致
                                andCallback:^(id data) {
                NSLog(@"返回值%@,%@,%@",data,data[@"info"],data[@"status"]);
                 [self.imagearr addObject:data[@"info"]];
            }];

            
            
        }
        
        
        [_pickerCollectionView reloadData];
        
    }];
    [self presentViewController:WphotoVC animated:YES completion:nil];
    
    

 
