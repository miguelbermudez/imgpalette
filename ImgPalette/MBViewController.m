//
//  MBViewController.m
//  ImgPalette
//
//  Created by Miguel Bermudez on 10/14/13.
//  Copyright (c) 2013 Miguel Bermudez. All rights reserved.
//

#import "MBViewController.h"
#import "MBAppDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface MBViewController ()

@end

@implementation MBViewController
{
    MBAppDelegate *_delegate;
}

- (void)awakeFromNib
{
    _delegate = (MBAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(handleTaps:)];
    
    /* The number of fingers that must be on the screen */
    self.tapGestureRecognizer.numberOfTouchesRequired = 1;
    
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static BOOL beenHereBefore = NO;
    
    if (beenHereBefore) {
        /* Only display the picker once as the viewDidAppear: method gets called
         * whenever the view of our view controller get displayed
         */
        return;
    } else {
        beenHereBefore = YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture Methods

- (void)handleTaps:(UITapGestureRecognizer *)paramSender
{
    NSUInteger touchCounter = 0;
    for (touchCounter = 0; touchCounter < paramSender.numberOfTouchesRequired; touchCounter++) {
        CGPoint touchPoint = [paramSender locationOfTouch:touchCounter inView:paramSender.view];
        NSLog(@"Touch #%lu: %@", (unsigned long)touchCounter+1, NSStringFromCGPoint(touchPoint));
    }
    
    [self choseAction];
}

#pragma mark - Camera Methods
- (void)doPhotoWithCamera
{
    if ([_delegate doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSString *requiredMediaType = (__bridge NSString *)kUTTypeImage;
        controller.mediaTypes = [[NSArray alloc] initWithObjects:requiredMediaType, nil];
        controller.allowsEditing = YES;
        controller.delegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        NSLog(@"Camera is not available");
    }
}

- (void)doPhotoWithLibrary
{
    if ([_delegate isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        
        if ([_delegate canUserPickPhotosFromPhotoLibrary]) {
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        }
        
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        NSLog(@"Photo Library is not available");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Picker returned successfullly.");
    NSLog(@"%@", info);
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        NSDictionary *metadata = info[UIImagePickerControllerMediaMetadata];
        UIImage *theImage = info[UIImagePickerControllerOriginalImage];
        
        //set mainimage to picker's images
        self.mainImageView.image = theImage;
        self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        NSLog(@"Image Metadata = %@", metadata);
        NSLog(@"Image = %@", theImage);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Action Sheet Methods

- (void)choseAction
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"Choose Source"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Photo Library", @"Take a Photo", nil];
    
    [actionsheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)as clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == as.cancelButtonIndex)
        return;
    
    if (buttonIndex == 0) {
        [self doPhotoWithLibrary];
    }
    if (buttonIndex == 1) {
        [self doPhotoWithCamera];
    }
    
}

@end
