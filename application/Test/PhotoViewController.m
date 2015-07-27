//
//  PhotoViewController.m
//  Test
//
//  Created by Pavel Deminov on 16/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    IBOutlet UIImageView *_imageView;
    IBOutlet UISlider *_sliderB;
    IBOutlet UISlider *_sliderC;
    IBOutlet UISlider *_sliderS;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIButton *btnSave;
    IBOutlet UIButton *btnOpen;
    float brightness;
    float contrast;
    float saturation;
    bool isProcessingNow;
}

@property (nonatomic,strong) UIImage *savedImage;

@end

@implementation PhotoViewController

#pragma mark ViewController Base Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Photo Filter";
    
    self.savedImage= _imageView.image;
    
    _sliderB.value = 0.9f;
    _sliderS.value = 0.6f;
    _sliderC.value = 0.4f;
    [self sliderValueChnaged:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions

-(IBAction)btnOpenPressed:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
        
    }];
    
    
}

-(IBAction)btnSavePressed:(id)sender {
    
    UIImageWriteToSavedPhotosAlbum(_imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
}

-(IBAction)sliderValueChnaged:(id)sender {
    
    brightness = 1-_sliderB.value;
    saturation = _sliderS.value;
    contrast = _sliderC.value*5;
    
    //[self performSelectorInBackground:@selector(applyFilter) withObject:nil];
    [self applyFilter];
    
    
}

#pragma mark UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    

    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.savedImage= chosenImage;
    [self applyFilter];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
}

#pragma mark Save Photo Delegate

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    
    if (error) {
        
         [[[UIAlertView alloc] initWithTitle:@"Save Photo" message:@"Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
    } else {
        
         [[[UIAlertView alloc] initWithTitle:@"Save Photo" message:@"Success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
        
    }
   
}

-(void)savePhotoSuccess {
    
    [[[UIAlertView alloc] initWithTitle:@"Save Photo" message:@"Success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

#pragma mark PhotoFilters


-(void) applyFilter {
    
    if (isProcessingNow) return;
    isProcessingNow = YES;
    [activityIndicator startAnimating];
    btnOpen.hidden = YES;
    btnSave.hidden = YES;
    
    [self performSelectorInBackground:@selector(processImage) withObject:nil];
    
    
}
- (void)processImage
{
    
   // NSLog(@"start");
    
    
    float b = -1;
    float c = -1;
    float s = -1;
    
    while (b!=brightness || c!=contrast || s!=saturation) {
        
        b =brightness;
        c =contrast;
        s =saturation;
        
        CIImage *beginImage = [CIImage imageWithCGImage:[self.savedImage CGImage]];
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"
                                      keysAndValues: kCIInputImageKey, beginImage,
                            @"inputBrightness", @(b),
                            @"inputContrast", @(c),
                            @"inputSaturation", @(s),
                            
                            nil];
        
        
        
        CIImage *outputImage = [filter outputImage];
        
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *newImg = [UIImage imageWithCGImage:cgimg];
        
        CGImageRelease(cgimg);
        
        _imageView.image = newImg;
        
    }
    
    [activityIndicator stopAnimating];
    isProcessingNow = NO;
    btnOpen.hidden = NO;
    btnSave.hidden = NO;
    //NSLog(@"stop");
   

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
