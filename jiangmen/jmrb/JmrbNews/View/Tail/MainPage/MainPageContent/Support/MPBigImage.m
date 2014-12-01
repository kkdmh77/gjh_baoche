//
//  MPBigImage.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MPBigImage.h"
#define ActivityTag    100

@interface MPBigImage ()

@end

@implementation MPBigImage
@synthesize delegate;

- (void)dealloc {
    [readPictureView release];
    [imageURLArray release];
    [imageQueue prepareRelease];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    readPictureView = [[YReadPictureView alloc] initWithFrame:self.view.bounds];
    [readPictureView setDelegate:self];
    [self.view addSubview:readPictureView];
    imageURLArray = [[NSMutableArray alloc] initWithCapacity:0];
    titlelaber =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, self.view.bounds.size.height)];
    titlelaber.numberOfLines = 0;
    titlelaber.textColor=[UIColor whiteColor];
    titlelaber.font=[UIFont systemFontOfSize:12];
    [titlelaber setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:titlelaber];
    

}

- (void)setImageArray:(NSArray *)imageArray {
    [imageURLArray removeAllObjects];
    [imageURLArray addObjectsFromArray:imageArray];
    [readPictureView setImageNumber:[imageArray count]];
    [readPictureView setCurrentIndex:0];
    [readPictureView reloadData];
}
    
#pragma mark - ImageQueueDelegate
- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    [readPictureView setImage:_image ForIndex:_index];
}

#pragma mark - YReadPictureViewDelegate
- (void)YReadPictureView:(YReadPictureView *)in_readPictureView requestImageForIndex:(NSInteger)in_index {
    
    NSString *urlString =[NSString stringWithFormat:@"%@%@",Web_URL ,[[imageURLArray objectAtIndex:in_index] objectForKey:@"newspic"]];
    
    [titlelaber setText:[NSString stringWithFormat:@"(%i/%i)        %@",in_index,imageURLArray.count,[[imageURLArray objectAtIndex:in_index] objectForKey:@"newsdescribe"]]];
    
    titlelaber.sizeToFit;
    CGRect titleframe = titlelaber.frame;
    
    [titlelaber setFrame:CGRectMake(10, self.view.bounds.size.height-titleframe.size.height-30, 300, titleframe.size.height)];
    
   
    
  
    UIImage *image = [imageQueue getImageForURL:urlString];
    if (image) {
        [readPictureView setImage:image ForIndex:in_index];
    }
    else {
        [imageQueue addOperationToQueueWithURL:urlString atIndex:in_index];
    }
}

- (void)YReadPictureView:(YReadPictureView *)in_readPictureView clickImageForIndex:(NSInteger)in_index {
    if (delegate && [delegate respondsToSelector:@selector(MPBigImageCloseBigImageView)]) {
        [delegate MPBigImageCloseBigImageView];
    }    
}

@end
