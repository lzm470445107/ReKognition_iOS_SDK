//
//  ReKognitionResults.m
//  StacheCam
//
//  Created by Yushan on 10/25/13.
//
//

#import "ReKognitionResults.h"

@implementation RKRawResponse
@end

@implementation RKDetectionResults

+ (RKDetectionResults *) parseDetectionResults: (NSString *) resultString{
    RKDetectionResults * results = [[RKDetectionResults alloc] init];
    results.response = [self ParseJSONResult: resultString];
    results.url = [results.response objectForKey:@"url"];
    results.apiUsage = [results.response objectForKey:@"usage"];
    NSArray * array = [results.response objectForKey:@"face_detection"];
    
    if(array && [array count] > 0){
        results.faceDetection = [[NSMutableArray alloc] initWithCapacity:[array count]];
        for(int i = 0; i < [array count]; i++){
            FaceDetection * facedection = [self parseFace:[array objectAtIndex:i]];
            [results.faceDetection addObject:facedection];
        }
    }
    return results;
}

+ (FaceDetection *) parseFace: (NSDictionary *) item{
    FaceDetection * facedection = [[FaceDetection alloc] init];
    facedection.confidence = [item objectForKey:@"confidence"];
    facedection.sex = [item objectForKey:@"sex"];
    facedection.age = [item objectForKey:@"age"];
    facedection.glasses = [item objectForKey:@"glasses"];
    facedection.mouth_open_wide = [item objectForKey:@"mouth_open_wide"];
    facedection.eye_closed = [item objectForKey:@"eye_closed"];
    facedection.smile = [item objectForKey:@"smile"];
    facedection.race = [item objectForKey:@"race"];
    facedection.emotion = [item objectForKey:@"emotion"];
    facedection.eye_left = CGPointMake([[[item objectForKey:@"eye_left"] objectForKey:@"x"] floatValue],
                                       [[[item objectForKey:@"eye_left"] objectForKey:@"y"] floatValue]);
    
    facedection.eye_right = CGPointMake([[[item objectForKey:@"eye_right"] objectForKey:@"x"] floatValue],
                                        [[[item objectForKey:@"eye_right"] objectForKey:@"y"] floatValue]);
    
    facedection.mouth_l = CGPointMake([[[item objectForKey:@"mouth_l"] objectForKey:@"x"] floatValue],
                                      [[[item objectForKey:@"mouth_l"] objectForKey:@"y"] floatValue]);
    
    facedection.mouth_r = CGPointMake([[[item objectForKey:@"mouth_r"] objectForKey:@"x"] floatValue],
                                      [[[item objectForKey:@"mouth_r"] objectForKey:@"y"] floatValue]);
    
    facedection.nose = CGPointMake([[[item objectForKey:@"nose"] objectForKey:@"x"] floatValue],
                                   [[[item objectForKey:@"nose"] objectForKey:@"y"] floatValue]);
    
    facedection.ori_img_size = CGSizeMake([[[item objectForKey:@"ori_img_size"] objectForKey:@"width"] floatValue],
                                          [[[item objectForKey:@"ori_img_size"] objectForKey:@"height"] floatValue]);
    
    NSMutableArray * nameArray = [item objectForKey:@"matches"];
    facedection.nameMatch = [NSMutableArray arrayWithCapacity:[nameArray count]];
    for(int j = 0; j < [nameArray count]; j++){
        NameMatch * nameMatch = [[NameMatch alloc] init];
        nameMatch.tag = [item objectForKey:@"tag"];
        nameMatch.score = [item objectForKey:@"score"];
        [facedection.nameMatch addObject:nameMatch];
    }
    
    facedection.boundingbox = CGRectMake([[[[item objectForKey:@"boundingbox"] objectForKey:@"tl"] objectForKey:@"x"] floatValue],
                                         [[[[item objectForKey:@"boundingbox"] objectForKey:@"tl"] objectForKey:@"y"] floatValue],
                                         [[[[item objectForKey:@"boundingbox"] objectForKey:@"size"] objectForKey:@"width"] floatValue],
                                         [[[[item objectForKey:@"boundingbox"] objectForKey:@"size"] objectForKey:@"height"] floatValue]);
    
    return facedection;
}

+ (RKClusterResults *) parseClusterResults: (NSString *) resultString{
    RKClusterResults * results = [[RKClusterResults alloc] init];
    results.response = [self ParseJSONResult: resultString];
    results.apiUsage = [results.response objectForKey:@"usage"];
    NSArray * array = [results.response objectForKey:@"clusters"];
    
    if(array && [array count] > 0){
        results.faceCluster = [[NSMutableArray alloc] initWithCapacity:[array count]];
        for (int i = 0; i < [array count]; i++){
            FaceCluster * faceCluster = [[FaceCluster alloc] init];
            faceCluster.tag = [[array objectAtIndex:i] objectForKey:@"tag"];
            faceCluster.img_index = [[array objectAtIndex:i] objectForKey:@"img_index"];
            [results.faceCluster addObject:faceCluster];
        }
    }
    return results;
}

+ (RKVisualizationResults *) parseVisualizationResults: (NSString *) resultString{
    RKVisualizationResults * results = [[RKVisualizationResults alloc] init];
    results.response = [self ParseJSONResult:resultString];
    results.apiUsage = [results.response objectForKey:@"usage"];
    NSArray * array = [results.response objectForKey:@"visualization"];
    
    if(array && [array count] > 0){
        results.faceVisualization = [[NSMutableArray alloc] initWithCapacity:[array count]];
        for(int i = 0; i<[array count]; i++){
            FaceVisualization * faceVisualization = [[FaceVisualization alloc] init];
            faceVisualization.tag = [[array objectAtIndex:i] objectForKey:@"tag"];
            faceVisualization.url = [[array objectAtIndex:i] objectForKey:@"url"];
            faceVisualization.index = [[array objectAtIndex:i] objectForKey:@"index"];
            [results.faceVisualization addObject:faceVisualization];
        }
    }
    return results;
}

+ (RKSearchResults *) parseSearchResults: (NSString *) resultString{
    RKSearchResults * results = [[RKSearchResults alloc] init];
    results.response = [self ParseJSONResult:resultString];
    results.apiUsage = [results.response objectForKey:@"usage"];
    results.url = [results.response objectForKey:@"url"];
    NSArray * array = [results.response objectForKey:@"face_detection"];
    
    if(array && [array count] > 0){
        results.faceSearch = [[NSMutableArray alloc] initWithCapacity:[array count]];
        for(int i = 0; i < [array count]; i++){
            FaceSearch * faceSearch = (FaceSearch *) [self parseFace:[array objectAtIndex:i]];
            faceSearch.matches = [[FaceMatch alloc] init];
            faceSearch.matches.tag = [[[array objectAtIndex:i] objectForKey:@"matches"] objectForKey:@"tag"];
            faceSearch.matches.img_index = [[[array objectAtIndex:i] objectForKey:@"matches"] objectForKey:@"img_index"];
            faceSearch.matches.score = [[[array objectAtIndex:i] objectForKey:@"matches"] objectForKey:@"score"];
            [results.faceSearch addObject:faceSearch];
        }
    }
    return results;
}

+ (RKNameSpaceStatsResults *) parseNameSpaceStatsResults: (NSString *) resultString{
    RKNameSpaceStatsResults * results = [[RKNameSpaceStatsResults alloc] init];
    results.response = [self ParseJSONResult:resultString];
    results.apiUsage = [results.response objectForKey:@"usage"];
    NSArray * array = [results.response objectForKey:@"face_name_space_stats"];
    if(array && [array count] > 0){
        results.nameSpaceStats = [[NSMutableArray alloc] initWithCapacity:[array count]];
        for(int i = 0; i < [array count]; i++){
            NameSpaceStats * nameSpaceStats = [[NameSpaceStats alloc] init];
            nameSpaceStats.name_space = [[array objectAtIndex:i] objectForKey:@"name_space"];
            nameSpaceStats.num_user_id = [[array objectAtIndex:i] objectForKey:@"num_user_id"];
            nameSpaceStats.num_tags = [[array objectAtIndex:i] objectForKey:@"num_tags"];
            nameSpaceStats.num_img = [[array objectAtIndex:i] objectForKey:@"num_img"];
            [results.nameSpaceStats addObject:nameSpaceStats];
        }
    }
    return results;
}

+ (RKFaceUserIdStatsResults *) parseFaceUserIdStatsResults: (NSString *) resultString{
    RKFaceUserIdStatsResults * results = [[RKFaceUserIdStatsResults alloc] init];
    results.response = [self ParseJSONResult:resultString];
    results.apiUsage = [results.response objectForKey:@"usage"];
    NSArray * array = [results.response objectForKey:@"face_user_id_stats"];
    if(array && [array count] > 0){
        results.faceUserIdStats = [[NSMutableArray alloc] initWithCapacity:[array count]];
        for(int i = 0; i < [array count]; i++){
            FaceUserIdStats * faceUserIdStats = [[FaceUserIdStats alloc] init];
            faceUserIdStats.user_id = [[array objectAtIndex:i] objectForKey:@"user_id"];
            faceUserIdStats.num_tags = [[array objectAtIndex:i] objectForKey:@"num_tags"];
            faceUserIdStats.num_img = [[array objectAtIndex:i] objectForKey:@"num_img"];
            [results.faceUserIdStats addObject:faceUserIdStats];
        }
    }
    return results;
}

+ (RKSceneUnderstandingResults *) parseSceneUnderstandingResults: (NSString *) resultString{
    RKSceneUnderstandingResults * results = [[RKSceneUnderstandingResults alloc] init];
    results.response = [self ParseJSONResult:resultString];
    results.apiUsage = [results.response objectForKey:@"usage"];
    results.url = [results.response objectForKey:@"url"];
    NSArray * array = [results.response objectForKey:@"scene_understanding"];
    if(array && [array count] > 0){
        results.sceneUnderstanding = [[NSMutableArray alloc] initWithCapacity:[array count]];
        for(int i = 0; i < [array count]; i++){
            SceneUnderstanding * scene = [[SceneUnderstanding alloc] init];
            scene.label = [[array objectAtIndex:i] objectForKey:@"label"];
            scene.score = [[array objectAtIndex:i] objectForKey:@"score"];
            [results.sceneUnderstanding addObject:scene];
        }
    }
    return results;
}

+ (NSDictionary *) ParseJSONResult:(NSString *)resultString
{
    NSData * data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:0
                     error:&error];
        
        if(error) {
        }
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = object;
            return results;
        }
        else
        {
            return nil;
        }
    }else{
        return nil;
    }
    
}

@end

