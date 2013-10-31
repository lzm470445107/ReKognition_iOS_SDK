//
//  RKPostJobs.m
//  Rekognition_iOS_SDK
//
//  Created by cys on 7/20/13.
//  Copyright (c) 2013 Orbeus Inc. All rights reserved.
//

#import "ReKognitionSDK.h"


@implementation ReKognitionSDK

static NSString *API_Key = @"1234";
static NSString *API_Secret = @"5678";


+ (NSData *) dictionaryToUrlData:(NSDictionary *)dict {
    NSMutableString *bodyString = [[NSMutableString alloc] init];
    NSArray *keys = [dict allKeys];
    if ([dict count] > 0) {
        [bodyString appendFormat:@"%@=%@", keys[0], [dict valueForKey:keys[0]]];
        for(int i = 1; i < [dict count]; i++) {
            [bodyString appendFormat:@"&%@=%@", keys[i], [dict valueForKey:keys[i]]];
        }
    }
    return [bodyString dataUsingEncoding:NSUTF8StringEncoding];
}


+ (NSString*) postReKognitionJobs:(NSDictionary *) jobsDictionary {
    NSData *data = [ReKognitionSDK dictionaryToUrlData:jobsDictionary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSString *url = @"http://rekognition.com/func/api/";
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error;
    NSHTTPURLResponse *responseCode;
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    if([responseCode statusCode] != 200 || error){
        NSLog(@"Error getting response: HTTP status code: %i, Error: %@", [responseCode statusCode], [error localizedDescription]);
        return nil;
    }
    NSString *result = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    return result;
}


// ReKognition Face Detect Function
+ (NSString *)RKFaceDetect:(UIImage *)image jobs:(NSString *)jobs {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSString *jobsString = jobs ? jobs : @"face_aggressive";
    NSDictionary * jobsDictionary = @{@"api_key": API_Key,
                                      @"api_secret": API_Secret,
                                      @"jobs": jobsString,
                                      @"base64": encodedString};
    return [self postReKognitionJobs:jobsDictionary];
}


+ (NSString *)RKFaceDetectWithUrl:(NSURL *)imageUrl jobs:(NSString *)jobs {
    NSString *jobsString = jobs ? jobs : @"face_aggressive";
    NSDictionary * jobsDictionary = @{@"api_key": API_Key,
                                      @"api_secret": API_Secret,
                                      @"jobs": jobsString,
                                      @"urls": [imageUrl absoluteString]};
    return [self postReKognitionJobs:jobsDictionary];
}


// ReKognition Face Add Function
+ (NSString *)RKFaceAdd:(UIImage *)image nameSpace:(NSString *)name_space userID:(NSString *)user_id tag:(NSString *)tag jobs:(NSString *)jobs {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSString *jobsString = jobs ? jobs : @"face_add_aggressive";
    NSMutableDictionary * jobsDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"api_key": API_Key,
                                                                                           @"api_secret": API_Secret,
                                                                                           @"jobs": jobsString,
                                                                                           @"base64": encodedString}];
    if (name_space) {
        [jobsDictionary setObject:name_space forKey:@"name_space"];
    }
    if (user_id) {
        [jobsDictionary setObject:user_id forKey:@"user_id"];
    }
    if (tag) {
        [jobsDictionary setObject:tag forKey:@"tag"];
    }
    return [self postReKognitionJobs:jobsDictionary];
}

+ (NSString *)RKFaceAddWithUrl:(NSURL *)imageUrl nameSpace:(NSString *)name_space userID:(NSString *)user_id tag:(NSString *)tag jobs:(NSString *)jobs {
    NSString *jobsString = jobs ? jobs : @"face_add_aggressive";
    NSMutableDictionary * jobsDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"api_key": API_Key,
                                                                                           @"api_secret": API_Secret,
                                                                                           @"jobs": jobsString,
                                                                                           @"urls": [imageUrl absoluteString]}];
    if (name_space) {
        [jobsDictionary setObject:name_space forKey:@"name_space"];
    }
    if (user_id) {
        [jobsDictionary setObject:user_id forKey:@"user_id"];
    }
    if (tag) {
        [jobsDictionary setObject:tag forKey:@"tag"];
    }
    return [self postReKognitionJobs:jobsDictionary];
}


//ReKognition Face Train Function
+ (NSString *)RKFaceTrain:(NSString *)name_space userID:(NSString *)user_id tags:(NSArray *)tags {
    NSMutableDictionary * jobsDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"api_key": API_Key,
                                                                                           @"api_secret": API_Secret}];
    if (tags) {
        [jobsDictionary setObject:@"face_train_sync" forKey:@"jobs"];
        [jobsDictionary setObject:[tags componentsJoinedByString:@";"] forKey:@"tags"];
    } else {
        [jobsDictionary setObject:@"face_train" forKey:@"jobs"];
    }
    if (name_space) {
        [jobsDictionary setObject:name_space forKey:@"name_space"];
    }
    if (user_id) {
        [jobsDictionary setObject:user_id forKey:@"user_id"];
    }
    return [self postReKognitionJobs:jobsDictionary];
}


// ReKognition Face Cluster Function
+ (NSString *)RKFaceCluster:(NSString *)name_space userId:(NSString *)user_id aggressiveness:(NSNumber *)aggressiveness {
    NSMutableDictionary * jobsDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"api_key": API_Key,
                                                                                           @"api_secret": API_Secret,
                                                                                           @"jobs": @"face_cluster"}];
    if (name_space) {
        [jobsDictionary setObject:name_space forKey:@"name_space"];
    }
    if (user_id) {
        [jobsDictionary setObject:user_id forKey:@"user_id"];
    }
    if (aggressiveness) {
        [jobsDictionary setObject:aggressiveness forKey:@"aggressiveness"];
    }
    return [self postReKognitionJobs:jobsDictionary];
}


// ReKognition Face Crawl Function
+ (NSString *) RKFaceCrawl:(NSString *)fb_id access_token:(NSString *)access_token crawl_fb_id:(NSArray *)friends_ids nameSpace:(NSString *)name_space userID:(NSString *)user_id {
    NSString *temp_string = [friends_ids componentsJoinedByString:@";"];
    NSString *crawl_string = [@"face_crawl_" stringByAppendingFormat:@"[%@]", temp_string];
    NSMutableDictionary * jobsDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"api_key": API_Key,
                                                                                           @"api_secret": API_Secret,
                                                                                           @"jobs": crawl_string,
                                                                                           @"fb_id": fb_id,
                                                                                           @"access_token": access_token}];
    if (name_space) {
        [jobsDictionary setObject:name_space forKey:@"name_space"];
    }
    if (user_id) {
        [jobsDictionary setObject:user_id forKey:@"user_id"];
    }
    return [self postReKognitionJobs:jobsDictionary];
}


//ReKognition Face Recognize Function
+ (NSString *)RKFaceRecognize:(UIImage *)image nameSpace:(NSString *)name_space userID:(NSString *)user_id jobs:(NSString *)jobs num_return:(NSNumber *)num_return tags:(NSArray *)tags {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSString *jobsString = jobs ? jobs : @"face_recognize";
    NSMutableDictionary * jobsDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"api_key": API_Key,
                                                                                           @"api_secret": API_Secret,
                                                                                           @"jobs": jobsString,
                                                                                           @"base64": encodedString}];
    if (name_space) {
        [jobsDictionary setObject:name_space forKey:@"name_space"];
    }
    if (user_id) {
        [jobsDictionary setObject:user_id forKey:@"user_id"];
    }
    if (num_return) {
        [jobsDictionary setObject:num_return forKey:@"num_return"];
    }
    if (tags) {
        [jobsDictionary setObject:[tags componentsJoinedByString:@";"] forKey:@"tags"];
    }
    return [self postReKognitionJobs:jobsDictionary];
}

+ (NSString *)RKFaceRecognizeWithUrl:(NSURL *)imageUrl nameSpace:(NSString *)name_space userID:(NSString *)user_id jobs:(NSString *)jobs num_return:(NSNumber *)num_return tags:(NSArray *)tags {
    NSString *jobsString = jobs ? jobs : @"face_recognize";
    NSMutableDictionary * jobsDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"api_key": API_Key,
                                                                                           @"api_secret": API_Secret,
                                                                                           @"jobs": jobsString,
                                                                                           @"urls": [imageUrl absoluteString]}];
    if (name_space) {
        [jobsDictionary setObject:name_space forKey:@"name_space"];
    }
    if (user_id) {
        [jobsDictionary setObject:user_id forKey:@"user_id"];
    }
    if (num_return) {
        [jobsDictionary setObject:num_return forKey:@"num_return"];
    }
    if (tags) {
        [jobsDictionary setObject:[tags componentsJoinedByString:@";"] forKey:@"tags"];
    }
    return [self postReKognitionJobs:jobsDictionary];
}


// ReKognition Face Visualize Function
+ (NSString *)RKFaceVisualize:(NSArray *)tags jobs:(NSString *)jobs nameSpace:(NSString *)name_space userID:(NSString *)user_id num_tag_return:(NSNumber *)num_tag_return num_img_return_pertag:(NSNumber *)num_img_return_pertag {
    NSString *jobsString = jobs ? jobs : @"face_visualize_show_default_tag";
    NSMutableDictionary * jobsDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"api_key": API_Key,
                                                                                           @"api_secret": API_Secret,
                                                                                           @"jobs": jobsString}];
    if (tags) {
        [jobsDictionary setObject:[tags componentsJoinedByString:@";"] forKey:@"tags"];
    }
    if (name_space) {
        [jobsDictionary setObject:name_space forKey:@"name_space"];
    }
    if (user_id) {
        [jobsDictionary setObject:user_id forKey:@"user_id"];
    }
    if (num_tag_return) {
        [jobsDictionary setObject:num_tag_return forKey:@"num_tag_return"];
    }
    if (num_img_return_pertag) {
        [jobsDictionary setObject:num_img_return_pertag forKey:@"num_img_return_pertag"];
    }
    return [self postReKognitionJobs:jobsDictionary];
}


// ReKognition Face Search Function
+ (NSString *)RKFaceSearch:(UIImage *)image jobs:(NSString *)jobs nameSpace:(NSString *)name_space userID:(NSString *)user_id num_return:(NSNumber *)num_return tags:(NSArray *)tags {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSString *jobsString = jobs ? jobs : @"face_search";
    NSMutableDictionary * jobsDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"api_key": API_Key,
                                                                                           @"api_secret": API_Secret,
                                                                                           @"jobs": jobsString,
                                                                                           @"base64": encodedString}];
    if (tags) {
        [jobsDictionary setObject:[tags componentsJoinedByString:@";"] forKey:@"tags"];
    }
    if (name_space) {
        [jobsDictionary setObject:name_space forKey:@"name_space"];
    }
    if (user_id) {
        [jobsDictionary setObject:user_id forKey:@"user_id"];
    }
    if (num_return) {
        [jobsDictionary setObject:num_return forKey:@"num_return"];
    }
    return [self postReKognitionJobs:jobsDictionary];
}

+ (NSString *)RKFaceSearchWithUrl:(NSURL *)imageUrl jobs:(NSString *)jobs nameSpace:(NSString *)name_space userID:(NSString *)user_id num_return:(NSNumber *)num_return tags:(NSArray *)tags {
    NSString *jobsString = jobs ? jobs : @"face_search";
    NSMutableDictionary * jobsDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"api_key": API_Key,
                                                                                           @"api_secret": API_Secret,
                                                                                           @"jobs": jobsString,
                                                                                           @"urls": [imageUrl absoluteString]}];
    if (tags) {
        [jobsDictionary setObject:[tags componentsJoinedByString:@";"] forKey:@"tags"];
    }
    if (name_space) {
        [jobsDictionary setObject:name_space forKey:@"name_space"];
    }
    if (user_id) {
        [jobsDictionary setObject:user_id forKey:@"user_id"];
    }
    if (num_return) {
        [jobsDictionary setObject:num_return forKey:@"num_return"];
    }
    return [self postReKognitionJobs:jobsDictionary];
}


// ReKognition Face Delete Function
+ (NSString *)RKFaceDelete:(NSString *)tag imageIndex:(NSArray *)img_index_array nameSpace:(NSString *)name_space userID:(NSString *)user_id {
    NSMutableDictionary *jobsDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"api_key": API_Key,
                                                                                          @"api_secret": API_Secret,
                                                                                          @"jobs": @"face_delete"}];
    if (name_space) {
        [jobsDictionary setObject:name_space forKey:@"name_space"];
    }
    if (user_id) {
        [jobsDictionary setObject:user_id forKey:@"user_id"];
    }
    if (tag) {
        [jobsDictionary setObject:tag forKey:@"tag"];
    }
    if (img_index_array) {
        [jobsDictionary setObject:[img_index_array componentsJoinedByString:@";"] forKey:@"img_index"];
    }
    return [self postReKognitionJobs:jobsDictionary];
    
}


//ReKognition Face Rename Function
+ (NSString *)RKFaceRenameOrMergeTag:(NSString *)oldTag withTag:(NSString *)newTag selectedFaces:(NSArray *)img_index_array nameSpace:(NSString *)name_space userID:(NSString *)user_id {
    NSMutableDictionary *jobsDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"api_key": API_Key,
                                                                                          @"api_secret": API_Secret,
                                                                                          @"jobs": @"face_rename",
                                                                                          @"tag": oldTag,
                                                                                          @"new_tag": newTag}];
    if (img_index_array) {
        [jobsDictionary setObject:[img_index_array componentsJoinedByString:@";"] forKey:@"img_index"];
    }
    if (name_space) {
        [jobsDictionary setObject:name_space forKey:@"name_space"];
    }
    if (user_id) {
        [jobsDictionary setObject:user_id forKey:@"user_id"];
    }
    return [self postReKognitionJobs:jobsDictionary];
}


// ReKognition Face Stats Function
+ (NSString *)RKFaceNameSpaceStats {
    NSDictionary *jobsDictionary = @{@"api_key": API_Key,
                                     @"api_secret": API_Secret,
                                     @"jobs": @"name_space_stats"};
    return [self postReKognitionJobs:jobsDictionary];
}

+ (NSString *)RKFaceUserIdStats:(NSString *)name_space {
    NSDictionary *jobsDictionary = @{@"api_key": API_Key,
                                     @"api_secret": API_Secret,
                                     @"jobs": @"user_id_stats",
                                     @"name_space": name_space};
    return [self postReKognitionJobs:jobsDictionary];
}


// ReKognition Scene Understanding Function
+ (NSString *)RKSceneUnderstanding:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary * jobDictionary = @{@"api_key": API_Key,
                                     @"api_secret": API_Secret,
                                     @"jobs": @"scene",
                                     @"base64": encodedString};
    return [self postReKognitionJobs:jobDictionary];
}

+ (NSString *)RKSceneUnderstandingWithUrl:(NSURL *)imageUrl {
    NSDictionary * jobDictionary = @{@"api_key": API_Key,
                                     @"api_secret": API_Secret,
                                     @"jobs": @"scene",
                                     @"urls": imageUrl};
    return [self postReKognitionJobs:jobDictionary];
}

@end
