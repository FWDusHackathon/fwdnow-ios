//
//  FNPostView.m
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import "FNPostView.h"
#import "FNItem.h"
#import <FacebookSDK/Facebook.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "FNKit.h"

#define DEFAULT_HEIGHT  200.0

@implementation FNPostView {
    BOOL _shouldPostOnFB;
    BOOL _shouldPostOnTwitter;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 2.0;
}

- (void)setupForItem:(FNItem *)item {
    
    NSArray *nameWords = [item.celebrityName componentsSeparatedByString:@" "];
    if (nameWords.count > 0) {
        NSString *text = [NSString stringWithFormat:@"I go FWD with @%@ to support immigration reform #ready4reform", nameWords[0]];
        self.textView.text = text;
    }
}

- (IBAction)btnFBPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)btnTwitterPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)btnCongressmanPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self setZipcodeVisible:sender.selected];
}

- (void)setZipcodeVisible:(BOOL)visible {
    
    CGFloat alpha = visible?1.0:0.0;
    CGRect frame = self.frame;
    if (visible) {
        frame.size.height = DEFAULT_HEIGHT + _zipcodeContainer.height + 10.0;
        frame.origin.y = (self.superview.height-frame.size.height)/2.0;
    } else {
        frame.size.height = DEFAULT_HEIGHT;
        frame.origin.y = (self.superview.height-frame.size.height)/2.0;
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _zipcodeContainer.alpha = alpha;
                         self.frame = frame;
                     }
                     completion:NULL];
}

- (IBAction)btnFWDNowPressed:(UIButton *)sender {
    _shouldPostOnFB = self.btnFB.selected;
    _shouldPostOnTwitter = self.btnTwitter.selected;
    
    BOOL shouldPost = (_shouldPostOnFB || _shouldPostOnTwitter);
    if (shouldPost) {
        if (_shouldPostOnFB) {
            [self postOnFacebook];
        } else if (_shouldPostOnTwitter) {
            [self postOnTwitter];
        }
    }
}

- (void)postOnFacebook {
    
    NSString *message = self.textView.text;
    NSString *link = @"www.fwdnow.com";
    
    UIViewController *vc = [self.delegate viewControllerForPostViewShareViews:self];
    
    BOOL displayedNativeDialog = [FBDialogs
                                  presentOSIntegratedShareDialogModallyFrom:vc
                                  initialText:message
                                  image:nil
                                  url:[NSURL URLWithString:link]
                                  handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
                                      
                                      NSString *alertText = nil;
                                      if (result == FBOSIntegratedShareDialogResultError && ![[error userInfo][FBErrorDialogReasonKey] isEqualToString:FBErrorDialogNotSupported]) {
                                          alertText = @"Error sharing on Facebook. Please try again.";
                                          // Show the result in an alert
                                          [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                      message:alertText
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil]
                                           show];
                                      } else {
                                          _shouldPostOnFB = NO;
                                          //Success, let's see if we need to show twitter
                                          [self checkIfDonePosting];
                                      }
                                  }];
    
    if (!displayedNativeDialog) {
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       link, @"link",
                                       message, @"name",
                                       @"FWDnow, we are all in for immigration reform",  @"description",
                                       nil];
        
        // Invoke the dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:
         ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
             if (error) {
                 // Error launching the dialog or publishing a story.
                 NSLog(@"Error publishing story.");
             } else {
                 if (result == FBWebDialogResultDialogNotCompleted) {
                     // User clicked the "x" icon
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // Handle the publish feed callback
                     NSLog(@"Posted!");
                     //Success, let's see if we need to show twitter
                     _shouldPostOnFB = NO;
                     [self checkIfDonePosting];
                 }
             }
         }];
    }
}

- (void)postOnTwitter {
    
    NSString *message = self.textView.text;
    NSString *link = @"www.fwdnow.com";
    NSURL *twitterAppURL = [NSURL URLWithString:@"twitter://"];
    
    UIViewController *vc = [self.delegate viewControllerForPostViewShareViews:self];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *composer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [composer setInitialText:message];
        
        [composer addURL:[NSURL URLWithString:link]];
        [composer setCompletionHandler:^(SLComposeViewControllerResult result) {
            _shouldPostOnTwitter = NO;
            [vc dismissViewControllerAnimated:YES
                                   completion:^{
                                       [self checkIfDonePosting];
                                   }];
        }];
        
        [vc presentViewController:composer animated:YES completion:nil];
        
    } else if ([[UIApplication sharedApplication] canOpenURL:twitterAppURL]) {
        message = [message stringByAppendingFormat:@" %@", link];
        NSString *encodedMessage = [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *postURL = [NSURL URLWithString:[NSString stringWithFormat:@"twitter://post?message=%@", encodedMessage]];
        [[UIApplication sharedApplication] openURL:postURL];
        _shouldPostOnTwitter = NO;
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter account" message:@"Please connect a Twitter account by going to the Settings app first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        _shouldPostOnTwitter = NO;
    }
    
}

- (void)checkIfDonePosting {
    
    if (_shouldPostOnFB) {
        [self postOnFacebook];
    } else if (_shouldPostOnTwitter) {
        [self postOnTwitter];
    } else {
        [self.delegate postViewDidFinishPosting:self];
    }
    
    
}

@end
