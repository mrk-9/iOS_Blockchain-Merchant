//
//  ATMCell.m
//  Merchant
//
//  Created by Alex on 6/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ATMCell.h"


@implementation ATMCell
@synthesize img;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [Utils RoundAvatarImageView:img];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
