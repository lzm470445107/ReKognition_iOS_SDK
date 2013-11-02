//
//  ViewController.m
//  Rekognition_iOS_SDK
//
//  Created by cys on 7/18/13.
//  Copyright (c) 2013 Orbeus Inc. All rights reserved.
//

#import "ViewController.h"
#import "FaceThumbnailCropper.h"
#import "ReKognitionSDK.h"
#import <QuartzCore/QuartzCore.h>
#import "FaceThumbnailCropper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"ReKognition Example";
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    labelView.hidden = YES;
    activityIndicator.hidesWhenStopped = YES;
	// Do any additional setup after loading the view, typically from a nib.
    // Base64 encode your jpeg image
}


- (IBAction)btnReKognizeImageClicked:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose the following..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Face Detection", @"Scene Understanding", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
	actionSheet.alpha = 0.80;
	actionSheet.tag = 2;
	[actionSheet showInView:self.view];
}

- (IBAction)btnSelectImageClicked:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallary", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
	actionSheet.alpha = 0.80;
	actionSheet.tag = 1;
	[actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (actionSheet.tag)
	{
		case 1:
			switch (buttonIndex)
            {
                labelView.hidden = YES;
                case 0:
                {
                    #if TARGET_IPHONE_SIMULATOR
				
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Saw Them" message:@"Camera not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
				
                    #elif TARGET_OS_IPHONE
				
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.delegate = self;
                    //picker.allowsEditing = YES;
                    [self presentViewController:picker animated:YES completion:nil];
                    [self clearRecognitionResults];
                    #endif
                }
                    break;
                case 1:
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    picker.delegate = self;
                    [self presentViewController:picker animated:YES completion:nil];
                    [self clearRecognitionResults];
                }
                    break;
            }
			break;
        
        case 2:
            switch (buttonIndex)
            {
                case 0:
                {
                    if(imageView.image){
                        FaceThumbnailCropper *cropper = [[FaceThumbnailCropper alloc] init];
                        NSData *imageData = UIImageJPEGRepresentation(imageView.image, 1.0f);
                        [cropper cropFaceThumbnailsInNSData:imageData];
                        return;
                        
                        // image x, y, width, height
                        float image_x, image_y, image_width, image_height;
                        if(imageView.image.size.width/imageView.image.size.height > imageView.frame.size.width/imageView.frame.size.height){
                            image_width = imageView.frame.size.width;
                            image_height = image_width/imageView.image.size.width * imageView.image.size.height;
                            image_x = 0;
                            image_y = (imageView.frame.size.height - image_height)/2;
                            
                            
                            if (imageView.image.size.width > 2600){
                                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Image too large" message:@"Max image size is 3000 px" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [alert show];
                                break;
                            }
                        }else if(imageView.image.size.width/imageView.image.size.height < imageView.frame.size.width/imageView.frame.size.height)
                        {
                            image_height = imageView.frame.size.height;
                            image_width = image_height/imageView.image.size.height * imageView.image.size.width;
                            image_y = 0;
                            image_x = (imageView.frame.size.width - image_width)/2;
                            if (imageView.image.size.width > 2600){
                                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Image too large" message:@"Max image size is 3000 px" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [alert show];
                                break;                           
                            }
                            
                        }else{
                            image_x = 0;
                            image_y = 0;
                            image_width = imageView.frame.size.width;
                            image_height = imageView.frame.size.height;
                            if (imageView.image.size.width > 2600){
                                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Image too large" message:@"Max image size is 3000 px" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [alert show];
                                break;
                            }
                        }
                        

                        [activityIndicator startAnimating];
                        dispatch_queue_t queue = dispatch_get_global_queue(0,0);
                        dispatch_async(queue, ^{
                        
                        NSString* detectResultString = [ReKognitionSDK RKFaceDetect:imageView.image jobs:nil];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [activityIndicator stopAnimating];
                            NSDictionary* results = [self ParseJSONResult: detectResultString];
                            NSLog(@"detectResultString = %@", detectResultString);
                            labelView.hidden = NO;
                            
                            NSMutableArray * array = [results objectForKey:@"face_detection"];
                            labelView.text = @"Face detection: \n";
                            NSLog(@"results = %@", array);
                            
                            int face_no = 0;
                            for(int i = 0; i < [array count]; i++){
                                if ([[[array objectAtIndex:i] objectForKey:@"confidence"] floatValue] > 0.1){
                                
                                    face_no = face_no + 1;

                                    id gender = [[array objectAtIndex:i] objectForKey:@"sex"];
                                    id glasses =  [[array objectAtIndex:i] objectForKey:@"glasses"];
                                    id confidence =  [[array objectAtIndex:i] objectForKey:@"confidence"];
                                    id eye_closed =  [[array objectAtIndex:i] objectForKey:@"eye_closed"];
                                    id age =  [[array objectAtIndex:i] objectForKey:@"age"];
                                    
                                    
                                    labelView.text = [labelView.text stringByAppendingFormat:@"Face %d -- ", i+1];
                                    labelView.text = [labelView.text stringByAppendingFormat:@"confidence: %04.2f; ",
                                                      [confidence floatValue]];
                                    labelView.text = [labelView.text stringByAppendingFormat:@"glass: %04.2f; ",
                                                      [glasses floatValue]];
                                    labelView.text = [labelView.text stringByAppendingFormat:@"age: %04.2f; ",
                                                      [age floatValue]];
                                    labelView.text = [labelView.text stringByAppendingFormat:@"eye_closed: %04.2f.\n",
                                                      [eye_closed floatValue]];

       
                                    //for debug
                                    //NSLog(@"%f, %f, %f, %f", image_x, image_y, image_width, image_height);
                                    //NSLog(@"%f, %f, %f, %f", imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
                                    //NSLog(@"%f, %f", imageView.image.size.width, imageView.image.size.height);
                                    //NSLog(@"%f", scale);
                                    
                                    CGFloat resize_scale = image_width/imageView.image.size.width;
                                    //NSLog(@"%f", resize_scale);
                                    
                                    // drawing faces
                                    
                                    // returned bounding box
                                    id x = [[[[array objectAtIndex:i] objectForKey:@"boundingbox"] objectForKey:@"tl"] objectForKey:@"x"];
                                    id y = [[[[array objectAtIndex:i] objectForKey:@"boundingbox"] objectForKey:@"tl"] objectForKey:@"y"];
                                    id width = [[[[array objectAtIndex:i] objectForKey:@"boundingbox"] objectForKey:@"size"] objectForKey:@"width"];
                                    id height = [[[[array objectAtIndex:i] objectForKey:@"boundingbox"] objectForKey:@"size"] objectForKey:@"height"];
                                    
                                    
                                    CALayer *layer = [CALayer new];
                                    layer.borderWidth = 2.0f;
                                    [layer setCornerRadius:5.0f*resize_scale];
                                    [layer setFrame:CGRectMake([x floatValue]*resize_scale + image_x,
                                                               [y floatValue]*resize_scale + image_y,
                                                               [width floatValue]*resize_scale,
                                                               [height floatValue]*resize_scale)];
                                    layer.borderColor = [[UIColor colorWithRed:(1-[gender floatValue]) green:0.0 blue:[gender floatValue] alpha:1] CGColor];

                                    // returned right eye position
                                    float radius = [width floatValue]*resize_scale/40;
                                    id eye_right_x = [[[array objectAtIndex:i] objectForKey:@"eye_right"] objectForKey:@"x"];
                                    id eye_right_y = [[[array objectAtIndex:i] objectForKey:@"eye_right"] objectForKey:@"y"];
                                    CALayer *eye_right_layer = [CALayer new];
                                    [eye_right_layer setCornerRadius:radius];
                                    eye_right_layer.backgroundColor = layer.borderColor;
                                    [eye_right_layer setFrame:CGRectMake(([eye_right_x floatValue] - [x floatValue])*resize_scale - radius,
                                                               ([eye_right_y floatValue] - [y floatValue])*resize_scale - radius,
                                                               radius * 2, radius * 2)];

                                    // returned left eye position
                                    id eye_left_x = [[[array objectAtIndex:i] objectForKey:@"eye_left"] objectForKey:@"x"];
                                    id eye_left_y = [[[array objectAtIndex:i] objectForKey:@"eye_left"] objectForKey:@"y"];
                                    CALayer *eye_left_layer = [CALayer new];
                                    eye_left_layer.backgroundColor = layer.borderColor;
                                    [eye_left_layer setCornerRadius:radius];
                                    [eye_left_layer setFrame:CGRectMake(([eye_left_x floatValue] - [x floatValue])*resize_scale - radius,
                                                                         ([eye_left_y floatValue] - [y floatValue])*resize_scale - radius,
                                                                         radius * 2, radius * 2)];
                                    
                                    // returned nose position
                                    id nose_x = [[[array objectAtIndex:i] objectForKey:@"nose"] objectForKey:@"x"];
                                    id nose_y = [[[array objectAtIndex:i] objectForKey:@"nose"] objectForKey:@"y"];
                                    CALayer *nose_layer = [CALayer new];
                                    nose_layer.backgroundColor = layer.borderColor;
                                    [nose_layer setCornerRadius: radius];
                                    [nose_layer setFrame:CGRectMake(([nose_x floatValue] - [x floatValue])*resize_scale - radius,
                                                                        ([nose_y floatValue] - [y floatValue])*resize_scale - radius,
                                                                        radius * 2,
                                                                        radius * 2)];

                                    // returned right mouth position
                                    id mouth_right_x = [[[array objectAtIndex:i] objectForKey:@"mouth_r"] objectForKey:@"x"];
                                    id mouth_right_y = [[[array objectAtIndex:i] objectForKey:@"mouth_r"] objectForKey:@"y"];
                                    CALayer *mouth_right_layer = [CALayer new];
                                    mouth_right_layer.backgroundColor = layer.borderColor;
                                    [mouth_right_layer setCornerRadius: radius];
                                    [mouth_right_layer setFrame:CGRectMake(([mouth_right_x floatValue] -[x floatValue])*resize_scale - radius,
                                                                    ([mouth_right_y floatValue] - [y floatValue])*resize_scale - radius,
                                                                    radius * 2,
                                                                    radius * 2)];

                                    
                                    // returned left mouth position
                                    id mounth_left_x = [[[array objectAtIndex:i] objectForKey:@"mouth_l"] objectForKey:@"x"];
                                    id mounth_left_y = [[[array objectAtIndex:i] objectForKey:@"mouth_l"] objectForKey:@"y"];
                                    CALayer *mouth_left_layer = [CALayer new];                            
                                    mouth_left_layer.backgroundColor = layer.borderColor;
                                    [mouth_left_layer setCornerRadius:radius];
                                    [mouth_left_layer setFrame:CGRectMake(([mounth_left_x floatValue] - [x floatValue])*resize_scale - radius,
                                                                          ([mounth_left_y floatValue] - [y floatValue])*resize_scale - radius,
                                                                           radius * 2,
                                                                           radius * 2)];

                                    

                                    
                                    CATextLayer *label = [[CATextLayer alloc] init];
                                    [label setFontSize:16];
                                    [label setString:[@"" stringByAppendingFormat:@"%d", i+1]];
                                    [label setAlignmentMode:kCAAlignmentCenter];
                                    [label setForegroundColor:layer.borderColor];
                                    [label setFrame:CGRectMake(0, layer.bounds.size.height, layer.frame.size.width, 25)];
                                    
                                    
                                    [layer addSublayer:eye_left_layer];
                                    [layer addSublayer:eye_right_layer];
                                    [layer addSublayer:nose_layer];
                                    [layer addSublayer:mouth_left_layer];
                                    [layer addSublayer:mouth_right_layer];
                                    [layer addSublayer:label];
                                    
                                    [imageView.layer addSublayer:layer];
                                    }
                                
                                }
                            
                            if(face_no > 2){
                                labelView.frame = CGRectMake(labelView.frame.origin.x, labelView.frame.origin.y, labelView.frame.size.width, labelView.frame.size.height + 45 * (face_no-2));
                                labelView.numberOfLines = 1 + face_no * 2;
                            }
                        });
                    });
                    
                    }else{
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Image" message:@"Select an image first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                }
                break;
                case 1:
                {
                    if(imageView.image){
                        CGFloat scale = 1;
                        if(imageView.image.size.width > 640){
                            scale = 640/imageView.image.size.width;
                        }
                        [activityIndicator startAnimating];
                        
                        dispatch_queue_t queue = dispatch_get_global_queue(0,0);                        
                        dispatch_async(queue, ^{
                            NSString* sceneResultString = [ReKognitionSDK RKSceneUnderstanding:imageView.image];
                            
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [activityIndicator stopAnimating];
                                NSDictionary* results = [self ParseJSONResult:sceneResultString];
                                NSLog(@"results = %@", results);
                            
                                labelView.hidden = NO;
                                labelView.text = @" Scene understanding:\n";
                            
                                NSMutableArray * array = [results objectForKey:@"scene_understanding"];
                                for(int i = 0; i < [array count]; i++){
                                    labelView.text = [labelView.text stringByAppendingFormat:@"    %@: %@\n",
                                                      [[array objectAtIndex:i] objectForKey:@"label"],
                                                      [[array objectAtIndex:i] objectForKey:@"score"]];
                                }
                                NSLog(@"%d", [array count]);
                            });
                        });
                    
                    }else{
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Image" message:@"Select an image first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                }
                break;
            }
			break;
			
		default:
			break;
            
	}
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    
    imageView.image  = [info objectForKey:@"UIImagePickerControllerOriginalImage"];    
    NSLog(@"%d", imageView.image.imageOrientation);
    NSLog(@"%f %f", imageView.image.size.width, imageView.image.size.height);
    
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *) ParseJSONResult:(NSString *)resultString
{
    NSData * data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:0
                     error:&error];
        
        if(error) { /* JSON was malformed, act appropriately here */ }
        
        // the originating poster wants to deal with dictionaries;
        // assuming you do too then something like this is the first
        // validation step:
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = object;            
            return results;
            
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
        }
        else
        {
            /* there's no guarantee that the outermost object in a JSON
             packet will be a dictionary; if we get here then it wasn't,
             so 'object' shouldn't be treated as an NSDictionary; probably
             you need to report a suitable error condition */
            return nil;
        }
    }else{
        return nil;
    }
    
}

-(void) clearRecognitionResults{
    labelView.hidden = YES;
    if(imageView.layer.sublayers)
        [imageView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    labelView.frame = CGRectMake(labelView.frame.origin.x, labelView.frame.origin.y, labelView.frame.size.width, labelView.frame.size.height + 78);
    
}


@end


