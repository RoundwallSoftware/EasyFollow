//
//  UIImage+TreatedImage.m
//  EasyFollow
//
//  Created by Samuel Goodwin on 5/1/13.
//  Copyright (c) 2013 Goodwinlabs LLC. All rights reserved.
//

#import "UIImage+TreatedImage.h"

@implementation UIImage (TreatedImage)

- (UIImage *)treatedImage
{
    UIImage *image = self;
    
    CGFloat padding = 6.0f;
    CGFloat scale = image.scale;
    
    CGRect frame = CGRectMake(0.0f+(padding/2.0f), 0.0f+(padding/2.0f), image.size.width*scale, image.size.height*scale);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width*scale+(padding*scale), image.size.height*scale+(padding*scale)), NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Color Declarations
    UIColor* outerBorder = [UIColor colorWithRed: 0.082 green: 0.082 blue: 0.082 alpha: 1];
    UIColor* avatarShadowColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.75];
    UIColor* color = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.35];
    
    //// Shadow Declarations
    UIColor* avatarShadow = avatarShadowColor;
    CGSize avatarShadowOffset = CGSizeMake(0.0f, 1.0f*scale);
    CGFloat avatarShadowBlurRadius = 1.0f*scale;
    
    //// Avatar Drawing
    UIBezierPath* avatarPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(frame, 1.0f*scale, 1.0f*scale)];
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, avatarShadowOffset, avatarShadowBlurRadius, avatarShadow.CGColor);
    
    [outerBorder setStroke];
    avatarPath.lineWidth = 2.0f*scale;
    [avatarPath stroke];
    
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    [avatarPath addClip];
    
    [image drawInRect:CGRectMake(0.0f+(padding*0.5f*scale), 0.0f+(padding*0.5f*scale), image.size.width*scale, image.size.height*scale)];
    
    //// Inner Highlight Drawing
    UIBezierPath* innerHighlightPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(frame, 1.0f*scale, 1.0f*scale)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, avatarShadowOffset, avatarShadowBlurRadius, avatarShadow.CGColor);
    CGContextRestoreGState(context);
    
    [color setStroke];
    innerHighlightPath.lineWidth = 2.0f*scale;
    [innerHighlightPath stroke];
    
    // Get the image, here setting the UIImageView image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
