//
//  VoteModel.h
//  JmrbNews
//
//  Created by dean on 12-12-5.
//
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"


@interface VoteModel : NSObject


@property (nonatomic, retain) NSString *votersName;
@property (nonatomic, retain) NSString *votersIsim;
@property (nonatomic, retain) NSString *votersPhone;
@property (nonatomic, retain) NSString *voteId;
@property (nonatomic, retain) NSString *voteType;
@property (nonatomic, retain) NSString *voteoptionId;
@property (nonatomic, retain) NSString *votersUserId;


-(void)sendTaoPiao;
-(void)getVideoLive;


@end
