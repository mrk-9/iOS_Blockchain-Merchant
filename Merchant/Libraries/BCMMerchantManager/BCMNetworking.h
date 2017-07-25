//
//  BCMNetworking.h
//  Merchant
//
//  Created by User on 11/3/14.
//  Copyright (c) 2014 com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kBCMNetworkingErrorDomain;

typedef NS_ENUM(NSUInteger, BCMErrorCode) {
    BCMNetworkRequestMissingArgs  = 9000,
    BCMNetworkRequestResultFailure  = 9001,
};

extern NSString *const kBCMNetworkingErrorKey;
extern NSString *const kBCMNetworkingErrorDetailKey;

typedef void(^BCMNetworkingSuccess)(NSURLRequest *request, NSDictionary *dict);
typedef void(^BCMNetworkingFailure)(NSURLRequest *request, NSError* error);

extern NSString *kBlockChainTxURL;

@class Merchant;

@interface BCMNetworking : NSObject

+ (instancetype)sharedInstance;

- (NSURLRequest *)retrieveBitcoinCurrenciesSuccess:(BCMNetworkingSuccess)success error:(BCMNetworkingFailure)failure;

- (NSURLRequest *)convertToBitcoinFromAmount:(NSDecimalNumber *)amount fromCurrency:(NSString *)currency success:(BCMNetworkingSuccess)success error:(BCMNetworkingFailure)failure;
- (NSURLRequest *)convertToCurrency:(NSString *)currency fromAmount:(uint64_t)amount success:(BCMNetworkingSuccess)success error:(BCMNetworkingFailure)failure;
- (void)lookUpTransactionResultWithHash:(NSString *)transactionHash address:(NSString *)merchantAddress completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

// Merchant Listing
- (NSURLRequest *)retrieveSuggestMerchantsSuccess:(BCMNetworkingSuccess)success error:(BCMNetworkingFailure)failure;
//- (NSURLRequest *)postSuggestMerchant:(Merchant *)merchant success:(BCMNetworkingSuccess)success error:(BCMNetworkingFailure)failure;

- (instancetype)init;

@end
