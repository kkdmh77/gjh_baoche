//
//  PicListCell.h
//  JmrbNews
//
//  Created by dean on 12-11-9.
//
//

#import <UIKit/UIKit.h>

@interface PicListCell : UITableViewCell



@property (nonatomic, assign) IBOutlet UILabel *newsTitle;
@property (nonatomic, assign) IBOutlet UILabel *newsImageNum;
@property (nonatomic, assign) IBOutlet UILabel *newsReplayView;
@property (nonatomic, assign) IBOutlet UIImageView *newsImageView1;
@property (nonatomic, assign) IBOutlet UIImageView *newsImageView2;
@property (nonatomic, assign) IBOutlet UIImageView *newsImageView3;

@end
