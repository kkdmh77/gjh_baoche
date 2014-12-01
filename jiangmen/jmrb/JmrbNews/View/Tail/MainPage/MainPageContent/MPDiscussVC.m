//
//  MPDiscussVC.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MPDiscussVC.h"
#import "ZSCommunicateModel.h"
#import "ZSSourceModel.h"
#import "MPDiscussCellV.h"
#import "ImageContant.h"
#import "MPDiscussVCCell.h"

@interface MPDiscussVC ()

- (void)hideKeyBoard;
- (void)reFreshDiscuss;
- (void)publishDiscuss;
- (void)finishAddCommit;

@end

@implementation MPDiscussVC
@synthesize discussScrollView;
@synthesize lblAccountName, lineView;

- (void)dealloc {
    [btnSendDiscuss release];
    [_hideKeyBoardGesture release];
    [_discussTextView release];
    [_discussView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if (iPhone5) {
        self = [super initWithNibName:@"MPDiscussVC-5" bundle:nibBundleOrNil];
    }
    else
    {
        self = [super initWithNibName:@"MPDiscussVC" bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainbeijing.png"]];
    UIImage *image, *image1;
    UIImageView *imageView;
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_Discuss_LogIn_Account];
    if (account) {
        [lblAccountName setText:account];
        CGSize size = [lblAccountName.text sizeWithFont:lblAccountName.font];
        CGRect frame = [lineView frame];
        [lineView setFrame:CGRectMake(frame.origin.x, frame.origin.y, size.width, frame.size.height)];
    }
    
    _discussView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
    [_discussView setBackgroundColor:[UIColor clearColor]];
    image = [UIImage imageByName:@"discuss_background" withExtend:@"png"];
    imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(0,0,320,image.size.height)];
    [_discussView addSubview:imageView];
    [_discussView setClipsToBounds:YES];
    [imageView release];
    
    _discussTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, -200, 240, 20)];
    [_discussTextView setDelegate:self];
    [_discussTextView resignFirstResponder];
    [_discussTextView setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:_discussTextView];
    
    btnSendDiscuss = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    image = [UIImage imageByName:@"discuss_submit" withExtend:@"png"];
    image1 = [UIImage imageByName:@"discuss_submit_tapped" withExtend:@"png"];
    [btnSendDiscuss setImage:image forState:UIControlStateNormal];
    [btnSendDiscuss setImage:image1 forState:UIControlStateHighlighted];
    [btnSendDiscuss setFrame:CGRectMake(258, 5, image.size.width, image.size.height)];
    [btnSendDiscuss setTitle:@"发表" forState:UIControlStateNormal];
    [btnSendDiscuss addTarget:self action:@selector(publishDiscuss) forControlEvents:UIControlEventTouchUpInside];
    [_discussTextView setInputAccessoryView:_discussView];
    [_discussTextView.inputAccessoryView addSubview:btnSendDiscuss];
    
    _hideKeyBoardGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [_hideKeyBoardGesture setMinimumPressDuration:0.01];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFreshDiscuss) name:notification_getComment object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAddCommit) name:notification_addComment object:nil];
}

#pragma mark - Private
- (void)hideKeyBoard {
    [self.discussScrollView removeGestureRecognizer:_hideKeyBoardGesture];
    [_discussTextView setFrame:CGRectMake(10, -200, 240, 20)];
    [_discussTextView resignFirstResponder];
    [self.view addSubview:_discussTextView];
}

- (void)finishAddCommit {
    [self setNewsIdDiscuss:_newsId];
}

- (void)publishDiscuss {
    if (_discussTextView.text.length==0) {
        return;
    }
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_Discuss_LogIn_Account];
    if (account == nil || [account length] == 0) {
        account = @"手机用户";
    }
    if (_discussTextView.text.length>40) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@" 长度不能大于40个字" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    [self.discussScrollView removeGestureRecognizer:_hideKeyBoardGesture];
    [_discussTextView setFrame:CGRectMake(10, -200, 240, 20)];
    [_discussTextView resignFirstResponder];
    [self.view addSubview:_discussTextView];
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_addComment forKey:Web_Key_urlString];
    [dic setObject:[NSString stringWithFormat:@"%i", _newsId] forKey:Key_Discuss_News_Id];
    [dic setObject:account forKey:Key_Discuss_Phone];
    [dic setObject:_discussTextView.text forKey:Key_Discuss_Text];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
    [_discussTextView setText:@""];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"评论已提交" message:@"请耐心等待审核" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)reFreshDiscuss {
    for (UIView *view in [discussScrollView subviews]) {
        [view removeFromSuperview];
    }
    CGFloat start = 10;
    NSMutableDictionary *newsDiscussDic = [[ZSSourceModel defaultSource] commentDataDic];
    NSDictionary *responseDic = [newsDiscussDic objectForKey:@"response"];
    NSArray *itemArray = [responseDic objectForKey:@"item"];
    for (int i = 0; i < [itemArray count]; i++) {
        NSDictionary *item = [itemArray objectAtIndex:i];
        NSMutableString *titleString = [[NSMutableString alloc] initWithString:@"  "];
        MPDiscussVCCell *discussCell = [[MPDiscussVCCell alloc] init];
        [discussCell.view setFrame:CGRectMake(0, start, 320, 90)];
        if ([[item objectForKey:@"commentNickname"] isKindOfClass:[NSString class]] && [item objectForKey:@"commentNickname"] && [[item objectForKey:@"commentNickname"] length] > 0) {
            [titleString appendString:[item objectForKey:@"commentNickname"]];
        }
        else {
            [titleString appendString:@"手机用户"];
        }
        [titleString appendString:@"说："];
        
//        NSString *dateString = [item objectForKey:@"commentCreatetime"];
//        if ([dateString isKindOfClass:[NSString class]]) {
//            if ([dateString length] > 16) {
//                [titleString appendString:@" ("];
//                NSString *datePre = [dateString substringToIndex:9];
//                NSString *dateTail = [dateString substringWithRange:NSMakeRange(11, 5)];
//                [titleString appendString:[NSString stringWithFormat:@"%@ %@",datePre, dateTail]];
//                [titleString appendString:@")"];
//            }
//        }
        [discussCell.lblAccountName setText:titleString];
        [discussCell.lblData setText:[item objectForKey:@"commentCreatetime"]];
        [discussCell.lblInfo setText:[item objectForKey:@"commentContent"]];
        //[discussCell setText:titleString Text:[item objectForKey:@"commentContent"]];
        [titleString release];
        //[discussCell setFrame:CGRectMake(0, start, 320, discussCell.height+10)];
        start += discussCell.view.frame.size.height+10;
        [discussScrollView addSubview:discussCell.view];
        [discussCell release];
        UIView *lView = [[UIView alloc] initWithFrame:CGRectMake(5, start-10, 300, 1)];
        [lView setBackgroundColor:[UIColor grayColor]];
        [discussScrollView addSubview:lView];
        [lView release];
    }
    [discussScrollView setContentSize:CGSizeMake(320, start)];
}

#pragma mark - Xib Function
- (void)clickChangeAccount:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入昵称" message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确认", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
    [alert release];
}

- (IBAction)clickBack:(id)sender {
    [self.discussScrollView removeGestureRecognizer:_hideKeyBoardGesture];
    [_discussTextView setFrame:CGRectMake(10, -200, 240, 20)];
    [_discussTextView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickDiscuss:(id)sender {
    [self.discussScrollView addGestureRecognizer:_hideKeyBoardGesture];
    [_discussTextView setFrame:CGRectMake(10, 5, 240, 20)];
    [_discussTextView becomeFirstResponder];
    [_discussTextView.inputAccessoryView addSubview:_discussTextView];
    
    CGSize size = [_discussTextView contentSize];
    if (size.height > 20) {
        if (size.height < 100) {
            [_discussTextView setFrame:CGRectMake(10, 5, size.width, size.height)];
            [_discussView setFrame:CGRectMake(0, 0, 320, size.height+10)];
        }
        else {
            [_discussTextView setFrame:CGRectMake(10, 5, size.width, 100)];
            [_discussView setFrame:CGRectMake(0, 0, 320, 110)];
        }
    }
}

-(void)otherDiscuss{
    [self.discussScrollView addGestureRecognizer:_hideKeyBoardGesture];
    [_discussTextView setFrame:CGRectMake(10, 5, 240, 20)];
    [_discussTextView becomeFirstResponder];
    [_discussTextView.inputAccessoryView addSubview:_discussTextView];
    
    CGSize size = [_discussTextView contentSize];
    if (size.height > 20) {
        if (size.height < 100) {
            [_discussTextView setFrame:CGRectMake(10, 5, size.width, size.height)];
            [_discussView setFrame:CGRectMake(0, 0, 320, size.height+10)];
        }
        else {
            [_discussTextView setFrame:CGRectMake(10, 5, size.width, 100)];
            [_discussView setFrame:CGRectMake(0, 0, 320, 110)];
        }
    }
    //_discussTextView.selectedRange = NSMakeRange(0,0);
}

#pragma mark - Public
- (void)setNewsIdDiscuss:(NSInteger )newsId {
    _newsId = newsId;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getComment forKey:Web_Key_urlString];
    [dic setObject:[NSString stringWithFormat:@"%i",newsId] forKey:Key_Discuss_News_Id];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
}

#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:UserDefault_Discuss_LogIn_Account];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [lblAccountName setText:textField.text];
        [lblAccountName setAdjustsFontSizeToFitWidth:YES];
        CGSize size = [lblAccountName.text sizeWithFont:lblAccountName.font];
        CGRect frame = [lineView frame];
        [lineView setFrame:CGRectMake(frame.origin.x, frame.origin.y, size.width, frame.size.height)];
//        [_discussTextField setFrame:CGRectMake(10, -200, 250, 25)];
//        [_discussTextField resignFirstResponder];
//        [self.view addSubview:_discussTextField];
//        
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//        [dic setObject:Web_addComment forKey:Web_Key_urlString];
//        [dic setObject:[NSNumber numberWithInt:_newsId] forKey:Key_Discuss_News_Id];
//        [dic setObject:textField.text forKey:Key_Discuss_Phone];
//        [dic setObject:_discussTextField.text forKey:Key_Discuss_Text];
//        [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
//        [dic release];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    CGSize size = [_discussTextView contentSize];
    CGRect btnFrame = btnSendDiscuss.frame;
    if (size.height > 20) {
        if (size.height < 100) {
            [_discussTextView setFrame:CGRectMake(10, 5, size.width, size.height)];
            [_discussView setFrame:CGRectMake(0, 0, 320, size.height+10)];
            [btnSendDiscuss setFrame:CGRectMake(btnFrame.origin.x, size.height+10-btnFrame.size.height-2, btnFrame.size.width, btnFrame.size.height)];
        }
        else {
            [_discussTextView setFrame:CGRectMake(10, 5, size.width, 100)];
            [_discussView setFrame:CGRectMake(0, 0, 320, 110)];
            [btnSendDiscuss setFrame:CGRectMake(btnFrame.origin.x, 110-btnFrame.size.height-2, btnFrame.size.width, btnFrame.size.height)];
        }
    }
}

@end
