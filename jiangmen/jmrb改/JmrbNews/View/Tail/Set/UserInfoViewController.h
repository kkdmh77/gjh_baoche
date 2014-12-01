//
//  UserInfoViewController.h
//  JmrbNews
//
//  Created by dean on 12-11-28.
//
//

#import <UIKit/UIKit.h>
#import "ImageLoaderQueue.h"
#import "CheckPhoneViewController.h"

@interface UserInfoViewController : UIViewController<ImageLoaderQueueDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
     ImageLoaderQueue *imageQueue;
}


@property (nonatomic, assign) IBOutlet UILabel *usertext;
@property (nonatomic, assign) IBOutlet UILabel *phonetext;
@property (nonatomic, assign) IBOutlet UILabel *sextext;
@property (nonatomic, assign) IBOutlet UIButton *uploadbut;
@property (nonatomic, assign) IBOutlet UIButton *checkphonebut;
@property (nonatomic, assign) IBOutlet UIImageView *userimage;


- (IBAction)clickBack:(id)sender;
- (IBAction)clickCamera:(id)sender;
- (IBAction)clickUpload:(id)sender;
- (IBAction)clickCheckphone:(id)sender;

@end
