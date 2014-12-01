//
//  BaoLiaoActiveModel.h
//  JmrbNews
//
//  Created by dean on 12-12-3.
//
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"

@interface BaoLiaoActiveModel : NSObject


@property (nonatomic, retain) NSString *txtBaoliaoPeople;
@property (nonatomic, retain) NSString *txtTitel;
@property (nonatomic, retain) NSString *txtTelephone;
@property (nonatomic, retain) NSString *txtHappenTime;
@property (nonatomic, retain) NSString *txtHappenAddress;
@property (nonatomic, retain) NSString *contentTextView;
@property (nonatomic, retain) NSString *userimageurl;
@property (nonatomic, retain) NSData *filedata;


-(void)sendBaoliao;


@end
