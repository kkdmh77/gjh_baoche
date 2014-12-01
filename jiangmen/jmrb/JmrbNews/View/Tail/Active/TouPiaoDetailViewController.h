//
//  TouPiaoDetailViewController.h
//  JmrbNews
//
//  Created by dean on 12-12-5.
//
//

#import <UIKit/UIKit.h>
#import "ImageLoaderQueue.h"

@interface TouPiaoDetailViewController : UIViewController<UIScrollViewDelegate,ImageLoaderQueueDelegate>{
    ImageLoaderQueue *imageQueue;
    NSMutableArray *checkboxes;
    NSDictionary *dicD;
    NSString *nsVoteMode;
    int votemodeint;
}


@property (nonatomic, assign) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, assign) IBOutlet UIButton *sendbut;
@property (nonatomic, assign) IBOutlet UILabel *titlelable;
@property (nonatomic, assign) IBOutlet UIImageView *userimage;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickSend:(id)sender;
- (void)loadNewsContent:(NSDictionary *) itemDic;

@end
