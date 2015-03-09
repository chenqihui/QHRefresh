//
//  CustomUIButton.m
//  KGKit
//
//  Created by chen on 14-5-27.
//  Copyright (c) 2014年 14zynr. All rights reserved.
//

#import "CustomUIButton.h"

@implementation CustomUIButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if (self.mwidth > 0 && self.mheight > 0)
    {
		CGRect imageRect = CGRectMake((contentRect.origin.x + contentRect.size.width - _mwidth)/2,
									  (contentRect.origin.y + contentRect.size.height - _mheight)/2,
									  _mwidth,
									  _mheight);
		return imageRect;
    }
    
	return contentRect;
}

@end
