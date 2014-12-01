//
//  AboutViewController.h
//  JmrbNews
//
//  Created by dean on 13-6-8.
//
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController<UIWebViewDelegate>



@property (retain, nonatomic) IBOutlet UIWebView *newsWebView;

- (IBAction)clickBack:(id)sender;

@end
