//
//  AboutViewController.m
//  JmrbNews
//
//  Created by dean on 13-6-8.
//
//

#import "AboutViewController.h"

@interface AboutViewController (){
    NSString *cellText;
}

@end


@implementation AboutViewController
@synthesize newsWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    cellText=@"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp《江门日报》是中共广东省江门市市委机关报。前身为《江门报》，1985年12月1日试刊，1986年8月5日正式创刊，四开四版，周报。1990年12月1日改为日报。1993年1月1日正式出版对开四版日报。1997年9月1日起扩为对开八版日报。从2002年10月18日起，扩版为周一至周五每天对开十二版，周六、周日对开四版。2003年9月1日起，扩版为周一至周五每天对开十六版，周六、周日对开八版。是中国第一侨乡江门五邑地区最具权威性和影响力的报纸。<br/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp《江门日报》立足江门五邑地区，以近400万江门五邑人为主要对象，宣传党的路线、方针、政策，及时报道市委、市政府的中心工作和各项决策；及时报道人民群众身边的新闻人物和新闻事件，突出社会生活中的热点、难点，反映海外近400万五邑籍海外乡亲的重要动态；注重反映群众的呼声，发挥党同群众联系的桥梁作用；关注国内外重要领域的重大事件，传播各类信息、科学文化知识、提供文化体育消息。注意将舆论导向性、党报权威性、政策指导性、时效迅捷性、地域贴近性、信息密集性、可读可亲性、传播广泛性融为一体，内容丰富，版面新颖活泼，成为扎根五邑、放眼全国、展望世界的地方性强势媒体。";
    
    NSString *htmlString=[NSString stringWithFormat:@"<html> \n<head> \n<style type=\"text/css\"> \n body {text-align:justify; font-size: 18px; line-height: 26px}\n</style> \n</head> \n <body>%@</body> \n </html>",cellText];
    
     [newsWebView loadHTMLString:htmlString baseURL:nil];
    
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)clickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
