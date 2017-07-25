//
//  BCMNetworking.m
//  Merchant
//
//  Created by User on 11/3/14.
//  Copyright (c) 2014 com. All rights reserved.
//

#import "BCMNetworking.h"

#import "Foundation-Utility.h"

NSString *const kBCMNetworkingErrorDomain = @"com.blockchain.networking";

NSString *const kBCMNetworkingErrorKey = @"BCMError";
NSString *const kBCMNetworkingErrorDetailKey = @"BCMErrorDetail";

static const NSString *kBCExchangeRatesRoute = @"ticker";
static const NSString *kBCConvertToBitcoin = @"tobtc";
static const NSString *kBCConvertToFiat = @"frombtc";
static const NSString *kBCMerchangeSuggestRoute = @"suggest_merchant.php";
static const NSString *kBCMValidateAddress = @"rawaddr";

@interface BCMNetworking ()

@property (strong, nonatomic) NSOperationQueue *mediumPriorityRequestQueue;

@end

@implementation BCMNetworking

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _mediumPriorityRequestQueue = [[NSOperationQueue alloc] init];
        [_mediumPriorityRequestQueue setName:@"com.blockchain.mediumQueue"];
    }
    
    return self;
}

- (NSURLRequest *)retrieveBitcoinCurrenciesSuccess:(BCMNetworkingSuccess)success error:(BCMNetworkingFailure)failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", BASE_URL, kBCExchangeRatesRoute];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:self.mediumPriorityRequestQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failure(urlRequest, connectionError);
        } else {
            NSError *error = nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            success(urlRequest, responseDict);
        }
    }];
    
    return urlRequest;
}

- (NSURLRequest *)convertToBitcoinFromAmount:(NSDecimalNumber *)amount fromCurrency:(NSString *)currency success:(BCMNetworkingSuccess)success error:(BCMNetworkingFailure)failure
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setMinimumIntegerDigits:1];
    [numberFormatter setMinimumFractionDigits:4];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?currency=%@&value=%@", BASE_URL, kBCConvertToBitcoin, currency, [numberFormatter stringFromNumber:amount]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:self.mediumPriorityRequestQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failure(urlRequest, connectionError);
        } else {
            NSString *btcValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            success(urlRequest, @{ @"btcValue" : btcValue });
        }
    }];
    
    return urlRequest;
}

- (NSURLRequest *)convertToCurrency:(NSString *)currency fromAmount:(uint64_t)amount success:(BCMNetworkingSuccess)success error:(BCMNetworkingFailure)failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?currency=%@&value=%lld", BASE_URL, kBCConvertToFiat, currency, amount];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:self.mediumPriorityRequestQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failure(urlRequest, connectionError);
        } else {
            NSString *fiatValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            success(urlRequest, @{ @"fiatValue" : fiatValue });
        }
    }];
    
    return urlRequest;
}

- (void)lookUpTransactionResultWithHash:(NSString *)transactionHash address:(NSString *)merchantAddress completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:DEFAULT_TRANSACTION_RESULT_URL_HASH_ARGUMENT_ADDRESS_ARGUMENT, transactionHash, merchantAddress]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completionHandler) completionHandler(data, response, error);
    }];
    
    [task resume];
    
    [session finishTasksAndInvalidate];
}

// Merchant Listing

- (NSURLRequest *)retrieveSuggestMerchantsSuccess:(BCMNetworkingSuccess)success error:(BCMNetworkingFailure)failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", BASE_URL, kBCMerchangeSuggestRoute];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:self.mediumPriorityRequestQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failure(urlRequest, connectionError);
        } else {
            NSString *btcValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            success(urlRequest, @{ @"btcValue" : btcValue });
        }
    }];
    
    return urlRequest;
}

/*
static NSString *const kSuggestMerchantResultKey = @"result";

- (NSURLRequest *)postSuggestMerchant:(Merchant *)merchant success:(BCMNetworkingSuccess)success error:(BCMNetworkingFailure)failure
{
    NSDictionary *merchantAsDict = [merchant merchantAsSuggestionDict];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/%@", MERCHANT_DIRECTORY_URL, kBCMerchangeSuggestRoute];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSError *error;
    NSData *merchantData = [NSJSONSerialization dataWithJSONObject:merchantAsDict options:0 error:&error];
    [urlRequest setHTTPBody:merchantData];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:self.mediumPriorityRequestQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failure(urlRequest, connectionError);
        } else {
            NSError *error = nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSNumber *result = [responseDict safeObjectForKey:kSuggestMerchantResultKey];
            if ([result integerValue] == 1) {
                success(urlRequest, responseDict);
            } else {
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"Merchant Post Failure"};
                NSError *error = [[NSError alloc] initWithDomain:kBCMNetworkingErrorDomain code:BCMNetworkRequestResultFailure userInfo:userInfo];
                failure(urlRequest, error);
            }
        }
    }];
    
    return urlRequest;
}
*/

//- (NSData *)encodeDictionary:(NSDictionary*)dictionary {
//    NSMutableArray *values = [[NSMutableArray alloc] init];
//    for (NSString *key in dictionary) {
//        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
//        [values addObject:part];
//    }
//    NSString *encodedDictionary = [values componentsJoinedByString:@"&"];
//    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
//}

@end
