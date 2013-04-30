//
//  MTPocket.m
//  MTPocket
//
//  Created by Adam Kirk on 2/17/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


#import "mtpocket_private.h"


@interface MTPocket ()
@property (assign,            nonatomic) BOOL           templatesRegistered;
@property (strong, readwrite, nonatomic) NSDictionary   *templates;
@end


@implementation MTPocket


- (id)init
{
    self = [super init];
    if (self) {
        _templates              = [NSMutableDictionary dictionary];
        _templatesRegistered    = NO;
    }
    return self;
}





#pragma mark - Public

+ (MTPocket *)sharedPocket
{
    static MTPocket *__sharedPocket;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedPocket = [MTPocket new];
    });
    return __sharedPocket;
}







#pragma mark - Templates

- (void)registerTemplates
{
    // to be overridden
    _templatesRegistered = YES;
}

- (void)addTemplateWithRequest:(MTPocketRequest *)request name:(NSString *)name
{
    NSMutableDictionary *dict = (NSMutableDictionary *)_templates;
    dict[name] = [request copy];
}

- (void)removeTemplateWithName:(NSString *)name
{
    NSMutableDictionary *dict = (NSMutableDictionary *)_templates;
    dict[name] = nil;
}



#pragma mark - Create Request

- (MTPocketRequest *)requestWithTemplate:(NSString *)name
                                    path:(NSString *)path
                             identifiers:(NSArray *)identifiers
                                  method:(MTPocketMethod)method
                                    body:(id)body
                                  params:(NSDictionary *)params
{
    if (!_templatesRegistered) [self registerTemplates];

    MTPocketRequest *request = [_templates[name] copy];
    request.path            = path;
    request.identifiers     = identifiers;
    request.method          = method;
    request.body            = body;
    if (params) [request.params addEntriesFromDictionary:params];
    return request;
}


@end

