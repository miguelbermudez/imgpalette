//
//  MBViewController.h
//  ImgPalette
//
//  Created by Miguel Bermudez on 10/14/13.
//  Copyright (c) 2013 Miguel Bermudez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBViewController : UIViewController  <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;


@end
