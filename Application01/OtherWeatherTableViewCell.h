//
//  OtherWeatherTableViewCell.h
//  Application01
//
//  Created by Tran Trung Tuyen on 11/4/16.
//  Copyright (c) 2016 Tran Trung Tuyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherWeatherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *Icon;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;

@end
