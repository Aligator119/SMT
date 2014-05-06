//
//  HPLocationSearch.m
//  HunterPredictor
//
//  Created by Admin on 1/22/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "LocationSearch.h"
#import "AppDelegate.h"
#import "CJSONDeserializer.h"
#import <GoogleMaps/GoogleMaps.h>
#import "PlaceSearchResult.h"

@implementation LocationSearch

+(NSArray*) getSearchResultWithInput: (NSString*) input{
    NSString * baseURL = @"https://maps.googleapis.com/maps/api/place/autocomplete/json?";
    NSString * url = [NSString stringWithFormat:@"%@input=%@&sensor=false&key=%@",baseURL, input, kGoogleBrouserAPIkey];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * queryURL = [NSURL URLWithString:url];
    NSData * response = [NSData dataWithContentsOfURL:queryURL];
    NSArray * result = [self parseSearchRespose:response];
    return result?result:[NSArray new];
}

+(NSArray*) parseSearchRespose: (NSData*) response{
    NSError * error;
    CJSONDeserializer* deserializer = [CJSONDeserializer deserializer];
    NSDictionary * responseDict = [deserializer deserialize:response error:&error];
    if (error){
        NSLog(@"JSON deserialization error");
        return nil;
    }else{
        NSMutableArray * addressArray = [NSMutableArray new];
        for (NSDictionary * dict in [responseDict objectForKey:@"predictions"]){
            PlaceSearchResult * place = [[PlaceSearchResult alloc] initWithName:[dict objectForKey:@"description"] Reference:[dict objectForKey:@"reference"]];
            [addressArray addObject:place];
        }
   // NSLog(@"Search result: %@", addressArray);
        
        return addressArray;
    }
}

+(CLLocationCoordinate2D) getCoordinateOfLocationWithReference: (NSString*) ref{
    CFTimeInterval begin = CACurrentMediaTime();
    NSString * baseURL = @"https://maps.googleapis.com/maps/api/place/details/json?";
    NSString * url = [NSString stringWithFormat:@"%@reference=%@&sensor=false&key=%@", baseURL, ref, kGoogleBrouserAPIkey];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * queryURL = [NSURL URLWithString:url];
    NSData * response = [NSData dataWithContentsOfURL:queryURL];
    CLLocationCoordinate2D result = [self parseLocationReferenceWithData:response];
    CFTimeInterval end = CACurrentMediaTime();
    NSLog(@" TIME : %f", end-begin);
    return result;
}

+(CLLocationCoordinate2D) parseLocationReferenceWithData: (NSData*) response{
    NSError * error;
    CJSONDeserializer* deserializer = [CJSONDeserializer deserializer];
    NSDictionary * responseDict = [deserializer deserialize:response error:&error];
    if (error){
        NSLog(@"JSON deserialization error");
        return CLLocationCoordinate2DMake(MAXFLOAT, MAXFLOAT);
    }else{
        NSDictionary * result = [responseDict objectForKey:@"result"];
        NSDictionary * geometry = [result objectForKey:@"geometry"];
        NSDictionary * location = [geometry objectForKey:@"location"];
        float lat = [[location objectForKey:@"lat"] floatValue];
        float lng = [[location objectForKey:@"lng"] floatValue];
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lng);
        return loc;
    }
}

@end
