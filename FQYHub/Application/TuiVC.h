//
//  TuiVC.h
//  ZhangABus
//
//  Created by 616 on 2019/5/17.
//  Copyright © 2019 5616. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface TuiVC : UIViewController

@property (nonatomic, copy)NSString *nameStr;

@property (nonatomic, copy)NSString *typeStr;
+(void)appkey:(NSString *)appkey vc:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
