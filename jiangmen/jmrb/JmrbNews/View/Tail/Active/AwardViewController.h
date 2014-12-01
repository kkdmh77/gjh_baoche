//
//  AwardViewController.h
//  JmrbNews
//
//  Created by dean on 13-6-2.
//
//

#import <UIKit/UIKit.h>

@interface AwardViewController : UIViewController<UIWebViewDelegate>{
    
}

@property (retain, nonatomic) IBOutlet UIWebView *newsWebView;


- (IBAction)clickBack:(id)sender;
@end
