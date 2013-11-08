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


+ (NSData *)dictionaryToUrlData:(NSDictionary *)dict {
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


+ (NSData *)postReKognitionJobs:(NSDictionary *) jobsDictionary {
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
    return oResponseData;
}


// ReKognition Face Detect Function
+ (RKFaceDetectResults *)RKFaceDetect:(UIImage *)image jobs:(NSString *)jobs {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSString *jobsString = jobs ? jobs : @"face_aggressive";
    NSDictionary * jobsDictionary = @{@"api_key": API_Key,
                                      @"api_secret": API_Secret,
                                      @"jobs": jobsString,
                                      @"base64": encodedString};
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseFaceDetectResponse:data];
}


+ (RKFaceDetectResults *)RKFaceDetectWithUrl:(NSURL *)imageUrl jobs:(NSString *)jobs {
    NSString *jobsString = jobs ? jobs : @"face_aggressive";
    NSDictionary * jobsDictionary = @{@"api_key": API_Key,
                                      @"api_secret": API_Secret,
                                      @"jobs": jobsString,
                                      @"urls": [imageUrl absoluteString]};
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseFaceDetectResponse:data];
}


// ReKognition Face Add Function
+ (RKFaceDetectResults *)RKFaceAdd:(UIImage *)image nameSpace:(NSString *)name_space userID:(NSString *)user_id tag:(NSString *)tag jobs:(NSString *)jobs {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSString *jobsString = jobs ? jobs : @"face_add";
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
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseFaceAddResponse:data];
}

+ (RKFaceDetectResults *)RKFaceAddWithUrl:(NSURL *)imageUrl nameSpace:(NSString *)name_space userID:(NSString *)user_id tag:(NSString *)tag jobs:(NSString *)jobs {
    NSString *jobsString = jobs ? jobs : @"face_add";
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
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseFaceAddResponse:data];
}


//ReKognition Face Train Function
+ (RKBaseResults *)RKFaceTrain:(NSString *)name_space userID:(NSString *)user_id tags:(NSArray *)tags {
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
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseFaceTrainResponse:data];
}


// ReKognition Face Cluster Function
+ (RKFaceClusterResults *)RKFaceCluster:(NSString *)name_space userId:(NSString *)user_id aggressiveness:(NSNumber *)aggressiveness {
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
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseFaceClusterResponse:data];
}


// ReKognition Face Crawl Function
+ (RKFaceCrawlResults *) RKFaceCrawl:(NSString *)fb_id access_token:(NSString *)access_token crawl_fb_id:(NSArray *)friends_ids nameSpace:(NSString *)name_space userID:(NSString *)user_id {
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
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseFaceCrawlResponse:data];
}


//ReKognition Face Recognize Function
+ (RKFaceDetectResults *)RKFaceRecognize:(UIImage *)image nameSpace:(NSString *)name_space userID:(NSString *)user_id jobs:(NSString *)jobs num_return:(NSNumber *)num_return tags:(NSArray *)tags {
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
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseFaceRecognizeResponse:data];
}

+ (RKFaceDetectResults *)RKFaceRecognizeWithUrl:(NSURL *)imageUrl nameSpace:(NSString *)name_space userID:(NSString *)user_id jobs:(NSString *)jobs num_return:(NSNumber *)num_return tags:(NSArray *)tags {
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
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseFaceRecognizeResponse:data];
}


// ReKognition Face Visualize Function
+ (RKFaceVisualizeResults *)RKFaceVisualize:(NSArray *)tags jobs:(NSString *)jobs nameSpace:(NSString *)name_space userID:(NSString *)user_id num_tag_return:(NSNumber *)num_tag_return num_img_return_pertag:(NSNumber *)num_img_return_pertag {
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
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseFaceVisualizeResponse:data];
}


// ReKognition Face Search Function
+ (RKFaceDetectResults *)RKFaceSearch:(UIImage *)image jobs:(NSString *)jobs nameSpace:(NSString *)name_space userID:(NSString *)user_id num_return:(NSNumber *)num_return tags:(NSArray *)tags {
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
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseFaceSearchResponse:data];
}

+ (RKFaceDetectResults *)RKFaceSearchWithUrl:(NSURL *)imageUrl jobs:(NSString *)jobs nameSpace:(NSString *)name_space userID:(NSString *)user_id num_return:(NSNumber *)num_return tags:(NSArray *)tags {
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
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseFaceSearchResponse:data];
}


// ReKognition Face Delete Function
+ (RKBaseResults *)RKFaceDelete:(NSString *)tag imageIndex:(NSArray *)img_index_array nameSpace:(NSString *)name_space userID:(NSString *)user_id {
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
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseFaceDeleteResponse:data];
}


//ReKognition Face Rename Function
+ (RKBaseResults *)RKFaceRenameOrMergeTag:(NSString *)oldTag withTag:(NSString *)newTag selectedFaces:(NSArray *)img_index_array nameSpace:(NSString *)name_space userID:(NSString *)user_id {
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
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseFaceRenameResponse:data];
}


// ReKognition Face Stats Function
+ (RKNameSpaceStatsResults *)RKNameSpaceStats {
    NSDictionary *jobsDictionary = @{@"api_key": API_Key,
                                     @"api_secret": API_Secret,
                                     @"jobs": @"face_name_space_stats"};
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseNameSpaceStatsResponse:data];
}

+ (RKUserIdStatsResults *)RKUserIdStats:(NSString *)name_space {
    NSDictionary *jobsDictionary = @{@"api_key": API_Key,
                                     @"api_secret": API_Secret,
                                     @"jobs": @"face_user_id_stats",
                                     @"name_space": name_space};
    NSData *data = [self postReKognitionJobs:jobsDictionary];
    return [ReKognitionResponseParser parseUserIdStatsResponse:data];
}


// ReKognition Scene Understanding Function
+ (RKSceneUnderstandingResults *)RKSceneUnderstanding:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary * jobDictionary = @{@"api_key": API_Key,
                                     @"api_secret": API_Secret,
                                     @"jobs": @"scene",
                                     @"base64": encodedString};
    NSData *data = [self postReKognitionJobs:jobDictionary];
    return [ReKognitionResponseParser parseSceneUnderstandingResponse:data];
}

+ (RKSceneUnderstandingResults *)RKSceneUnderstandingWithUrl:(NSURL *)imageUrl {
    NSDictionary * jobDictionary = @{@"api_key": API_Key,
                                     @"api_secret": API_Secret,
                                     @"jobs": @"scene",
                                     @"urls": imageUrl};
    NSData *data = [self postReKognitionJobs:jobDictionary];
    return [ReKognitionResponseParser parseSceneUnderstandingResponse:data];
}

@end
