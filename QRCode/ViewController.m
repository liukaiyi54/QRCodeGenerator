//
//  ViewController.m
//  QRCode
//
//  Created by Michael on 2/14/16.
//  Copyright © 2016 Michael. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+DismissKeyboard.h"

//#import "QRCodeUtils.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupForDismissKeyboard];
    
    [self.createButton addTarget:self action:@selector(didTapCreateButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapCreateButton:(UIButton *)sender {
    NSLog(@"%@", self.textField.text);
    
    UIImage *image = [self generateQRCodeImageFromString:self.textField.text imageSize:CGSizeMake(200, 200)];
    [self.qrcodeImageView setImage:image];
}

- (UIImage *)generateQRCodeImageFromString:(NSString *)string imageSize:(CGSize)size {
    if (string.length == 0) {
        return nil;
    }
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

    CIImage *ciImg = [self createQRCodeCIImageWithData:data];
    UIImage *uiImg = [self createNonInterpolatedUIImageFromCIImage:ciImg withSize:size];
    return uiImg;
}

- (CIImage *)createQRCodeCIImageWithData:(NSData *)data {
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:data forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withSize:(CGSize)size {
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage *uiImg = [UIImage imageWithCGImage:cgImage
                                         scale:scale
                                   orientation:UIImageOrientationUp];
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    [uiImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    uiImg = UIGraphicsGetImageFromCurrentImageContext();
    
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return uiImg;
}

@end
