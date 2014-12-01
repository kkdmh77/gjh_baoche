//
//  TouPiaoDetailViewController.m
//  JmrbNews
//
//  Created by dean on 12-12-5.
//
//

#import "TouPiaoDetailViewController.h"
#import "SSCheckBoxView.h"
#import "UIHelpers.h"
#import "ZSSourceModel.h"
#import "AppDelegate.h"
#import "VoteModel.h"

@interface TouPiaoDetailViewController (){
    VoteModel *votemodle;
    NSMutableArray * itmelistArray;
}

- (void)notificationTouPiaoSuccess;

@end

@implementation TouPiaoDetailViewController
@synthesize contentScrollView,sendbut,titlelable,userimage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) dealloc
{
    [imageQueue prepareRelease];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [checkboxes release];
    [dicD release];
    [nsVoteMode release];
    [votemodle release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainbeijing.png"]];
    
    checkboxes = [[NSMutableArray alloc] init];
    votemodeint=0;
    
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    [titlelable setNumberOfLines:2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationTouPiaoSuccess) name:Notification_SendTouPiaoSuccess object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadNewsContent:(NSDictionary *) itemDic{
    dicD = [[NSDictionary alloc] initWithDictionary:itemDic];
    nsVoteMode = [[dicD objectForKey:@"voteMode"] stringValue];
    if([nsVoteMode isEqualToString:@"0"]){
        votemodeint = 0;
    }else{
        votemodeint = 1;
    }
    
    [titlelable setText:[dicD objectForKey:@"voteTitle"]];
    
    UIImage *image = nil;
    NSString *urlString =[NSString stringWithFormat:@"%@%@",Web_URL ,[itemDic objectForKey:@"votePicture"]];
    if (urlString && [urlString isKindOfClass:[NSString class]] && [urlString length] > 0) {
        image = [imageQueue getImageForURL:urlString];
        if (!image) {
            image = [UIImage imageNamed:@"nouserpic.png"];
            [imageQueue addOperationToQueueWithURL:urlString atIndex:94494];
        }
    }
    else {
        image = [UIImage imageNamed:@"nouserpic.png"];
    }
    
    [userimage setImage:image];
    [image release];
    
    
    
    itmelistArray=[[NSMutableArray alloc] init];
    itmelistArray = [itemDic objectForKey:@"voteOptionList"];
    
    SSCheckBoxView *cbv = nil;
    CGRect frame = CGRectMake(20, 0, 240, 30);
    for (int i = 0; i < itmelistArray.count; i++) {
        cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                              style:kSSCheckBoxViewStyleGlossy
                                            checked:NO];
        [cbv setText:[NSString stringWithFormat:@"%@", [[itmelistArray objectAtIndex:i] objectForKey:@"voteoptionContent"]]];
        [cbv setTag:i];
        [cbv setStateChangedTarget:self
                          selector:@selector(checkBoxViewChangedState:)];
        [contentScrollView addSubview:cbv];
        [checkboxes addObject:cbv];
        [cbv release];
        frame.origin.y += 36;
    }
    frame.origin.y += 24;
    [sendbut setFrame:CGRectMake(100, frame.origin.y, 104, 23)];
    [contentScrollView setContentSize:CGSizeMake(320, 38*itmelistArray.count+30)];
    [contentScrollView setDelegate:self];
    //[itmelistArray release];
}


- (void) checkBoxViewChangedState:(SSCheckBoxView *)cbv
{
    if(votemodeint==0){
        for (SSCheckBoxView *cbv in checkboxes) {
            [cbv setChecked:false];
        }
        [cbv setChecked:!cbv.checked];
    }
    
}

- (IBAction)clickSend:(id)sender{
    NSString *stringVoteoption = @"";
    for (int i = 0; i < itmelistArray.count; i++) {
       SSCheckBoxView *cbv = [checkboxes objectAtIndex:i];
        if(cbv.checked){
            stringVoteoption=[NSString stringWithFormat:@"%@,%@",stringVoteoption,[[itmelistArray objectAtIndex:i] objectForKey:@"voteoptionId"]];
            
        }
    }
    
    
    if(stringVoteoption.length<1){
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate alertTishi:@"请选择" detail:@""];
        return;
    }else{
      stringVoteoption =  [stringVoteoption stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:@""];
    }
   votemodle =[[VoteModel alloc] init];
    
  // NSString *nsdd = [[dicD objectForKey:@"votePower"] stringValue];
    if([[[dicD objectForKey:@"votePower"] stringValue] isEqualToString:@"0"]){
        //NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
       // NSString * key_deviceid = [standardUserDefault objectForKey: Key_deviceId];
        [votemodle setVotersName:@""];
        [votemodle setVotersPhone:@""];
        [votemodle setVotersUserId:@""];
        [votemodle setVoteType:@"0"];
        [votemodle setVotersIsim:[[NSUserDefaults standardUserDefaults] objectForKey: Key_deviceId]];
        [votemodle setVoteId:[[dicD objectForKey:@"voteId"] stringValue]];
        [votemodle setVoteoptionId:stringVoteoption];
        [votemodle sendTaoPiao];
    
    }else{
        if([[ZSSourceModel defaultSource] succLoginDic]!=nil){
            [votemodle setVotersName:[[[ZSSourceModel defaultSource] succLoginDic] objectForKey:@"userName"]];
            [votemodle setVotersPhone:[[[ZSSourceModel defaultSource] succLoginDic] objectForKey:@"userPhone"]];
            [votemodle setVotersUserId:[[[ZSSourceModel defaultSource] succLoginDic] objectForKey:@"userId"]];
            [votemodle setVoteType:@"1"];
            [votemodle setVoteId:[[dicD objectForKey:@"voteId"] stringValue]];
            [votemodle setVoteoptionId:stringVoteoption];
            [votemodle sendTaoPiao];
        }else{
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate alertTishi:@"请登陆后投票" detail:@""];
        }
    }
   // [stringVoteoption release];
    //[standardUserDefault release];
    
}

- (IBAction)clickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)notificationTouPiaoSuccess{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"投票成功" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
//    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - ImageQueueDelegate
- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    [userimage setImage:_image];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
