//
//  AlgorithmsViewController.m
//  Test
//
//  Created by Pavel Deminov on 16/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "AlgorithmsViewController.h"
#include <stdio.h>
#include <string.h>

#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))

@interface AlgorithmsViewController () <UITextFieldDelegate> {
    
    IBOutlet UIScrollView *_scrollView;
    IBOutlet NSLayoutConstraint *bottomViewConstraint;
    
    IBOutlet UITextField *tfText;
    IBOutlet UILabel *lblFastResult;
    IBOutlet UILabel *lblSimpleResult;
    
    IBOutlet UITextField *tfM;
    IBOutlet UITextField *tfN;
    IBOutlet UILabel *lblFindDigitResult;
    IBOutlet UITextView *tvDigits;
    IBOutlet UIButton *btnGenerate;
    
    int *zeroBitsArray;
}

@property (nonatomic,strong) NSArray *digitsArray;

@end

@implementation AlgorithmsViewController

#pragma mark ViewController Base Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Algorithms";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    tfM.delegate = self;
    tfN.delegate = self;
    tfText.delegate = self;
    
    [tfText addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self prefillZeroBitsArray];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    
    free(zeroBitsArray);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width,btnGenerate.frame.origin.y+btnGenerate.frame.size.height) ;
    //NSLog(@"%f", _scrollView.contentSize.height);
    
    //if (activeTextView!=nil) [_scrollView scrollRectToVisible:moreInfoTextView.frame animated:YES];
}

#pragma mark Actions

-(IBAction)textFieldValueChanged:(id)sender {
    
    NSString *text = [(UITextField*)sender text];
    lblFastResult.text = [NSString stringWithFormat:@"%i",[self countZeroBitsFast:text] ];
    lblSimpleResult.text = [NSString stringWithFormat:@"%i",[self countZeroBitsSimple:text] ];
    
}

-(IBAction)btnGeneratePressed:(id)sender {
    
    int m = [tfM.text intValue];
    int n = [tfN.text intValue];
    
    
    if (n<2 || m<2) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Imposssible expression" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
        
    }
    
    if (m<n) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"M must be >= N" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
        
        
    }
    [self fillDigitsArray];
    [self findDigit];
   
    
}


#pragma mark UItextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark keyboard notifications

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    NSTimeInterval duration = 0;
    NSValue* value = [keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [value getValue:&duration];
    
    [UIView animateWithDuration:duration animations:^{
        
        bottomViewConstraint.constant = keyboardFrameBeginRect.size.height;
        
        [self.view layoutIfNeeded]; // Called on parent view
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    //NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    //CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    NSTimeInterval duration = 0;
    NSValue* value = [keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [value getValue:&duration];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         bottomViewConstraint.constant =0;
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    
    
    
}

#pragma mark Private


-(void)dismissKeyboard {
    
    if ([tfText isFirstResponder]) {
        [tfText resignFirstResponder];
    }
    else if ([tfM resignFirstResponder]) {
        [tfText resignFirstResponder];
    }
    else if ([tfN resignFirstResponder]) {
        [tfText resignFirstResponder];
        
    }
    
    
}

-(int)countZeroBitsSimple:(NSString*)string {
    
    int result = 0;;
    for (int i=0; i<[string length]; i++) {
        int asciiCode = [string characterAtIndex:i];
        unsigned char character = asciiCode;
        
      //  printf("--->%c<---\n", character);
      //  printf("--->%d<---\n", character);

        for (int j=0; j < 8; j++) {
            int bit = (character >> j) & 1;
            if (bit ==0) result++;
        //    printf("%d ", bit);
        }
       // printf("\n");
    }
    
    return result;
    
}

-(void) prefillZeroBitsArray {
    
    const int itemsCount = (int)(CHAR_MAX - CHAR_MIN) + 1;
    
    zeroBitsArray = malloc(sizeof(int) * itemsCount);
    int bufferDoubleDigits[itemsCount];
    
    for (int i=0; i<itemsCount; i++) {
        unsigned char character = i;
        int count = 0;
        for (int j=0; j < 8; j++) {
            int bit = (character >> j) & 1;
            if (bit ==0) count++;
        }
        bufferDoubleDigits[i] = count;
    }
    
    memcpy(zeroBitsArray, bufferDoubleDigits, sizeof(int) * itemsCount);

    
}

-(int)countZeroBitsFast:(NSString*)string {
    
    int result = 0;;
    for (int i=0; i<[string length]; i++) {
        int asciiCode = [string characterAtIndex:i];
        result+=zeroBitsArray[asciiCode];
    }
    
    return result;
    
}


-(void) fillDigitsArray {
    
    int m = [tfM.text intValue];
    int n = [tfN.text intValue];
    
    NSString *strResult = @"";
    
    NSMutableArray *array = [NSMutableArray new];
    
    int step = (int)m/n;
    int min;
    int max;
    for (int i=0; i<n; i++) {
        int digit= 0;
        min = i*step;
        max = (i+1)*step-1;
       
        digit = RAND_FROM_TO(min, max);
        
        [array addObject:@(digit)];
        
    }
    int digitForFindIndex = ( RAND_FROM_TO(0, (int)(array.count-1)) );
    if (digitForFindIndex!=0) {
        array[0] = array[digitForFindIndex];
    } else {
        array[array.count-1] = array[digitForFindIndex];

    }
                                                            
    
    
    NSArray *randomizedArray = [self shuffledArray:array];
    
    for (NSNumber *num in randomizedArray) {
        
        if (strResult.length==0) {
            strResult = [NSString stringWithFormat:@"%i",num.intValue];
        } else {
            strResult = [NSString stringWithFormat:@"%@ %i",strResult,num.intValue];
            
        }
        
    }
    self.digitsArray = randomizedArray;
    tvDigits.text = strResult;
    
}

- (NSArray *)shuffledArray:(NSArray *)array
{
    return [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if (arc4random() % 2) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
}

-(void)findDigit {
    
    int m = [tfM.text intValue];
    
    int b[m];
    for(int i = 0; i < m; i++) {
        b[i] = 0;
    }
    
    int result = 0;
    
    for (int i = 0; i < _digitsArray.count; i++)
    {
        int value = [_digitsArray[i] intValue];
        
        if ( b[value] ==0)
        {
            b[value] = value;
        }
        else
        {
            result = value;
            break;
        }
    }
    
    lblFindDigitResult.text = [NSString stringWithFormat:@"%i",result];
    
    
    
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
