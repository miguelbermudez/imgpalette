//
//  MBAppDelegate.h
//  ImgPalette
//
//  Created by Miguel Bermudez on 10/14/13.
//  Copyright (c) 2013 Miguel Bermudez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)doesCameraSupportTakingPhotos;
- (BOOL)isPhotoLibraryAvailable;
- (BOOL) canUserPickPhotosFromPhotoLibrary;
@end
