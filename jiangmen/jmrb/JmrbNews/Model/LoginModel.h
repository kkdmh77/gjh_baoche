//
//  LoginModel.h
//  JmrbNews
//
//  Created by dean on 12-11-23.
//
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"

@interface LoginModel : NSObject


@property (nonatomic, retain) NSString *loginuser;
@property (nonatomic, retain) NSString *loginpassword;
@property (nonatomic, retain) NSString *loginphone;
@property (nonatomic, retain) NSString *loginsex;
@property (nonatomic, retain) NSString *userimageurl;



+ (id)defaultSource;

//登陆
-(void)getLogin;
-(void)getRegister;

-(void)uploadImage;
-(void)sendsms:(NSString *) phone vcode:(NSString *) vicode;
-(void)updateUser:(NSString *) userId userName:(NSString *) userName userPassword:(NSString *) userPassword userPhone:(NSString *) userPhone userSex:(NSString *) userSex userVerification:(NSString *) userVerification;

@end
