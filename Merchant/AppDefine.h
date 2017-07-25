//
//  AppDefine.h
//  Merchant
//
//  Created by Alex on 6/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#ifndef AppDefine_h
#define AppDefine_h

#import <Foundation/Foundation.h>

//OneSignal Key
#define ONE_APP_ID @"75c07185-bc78-4940-885f-2c8d03f25dde"
#define ONE_REST_KEY @"ZWU0YjI1MTAtMWRmZi00YjBlLTg3YjctYWU1NTkzMjUwNWVm"

#define COLOR_GREEN [UIColor colorWithRed:255.0f/255.0f green:165.0f/255.0f blue:0.0f/255.0f alpha:1.0]
//#define COLOR_GREEN [UIColor colorWithRed:55.0f/255.0f green:160.0f/255.0f blue:0.0f/255.0f alpha:1.0]


#define WEB_SITE            @"http://onthegocoins.com/"
#define CONTACT_EMAIL       @"support@onthegocoins.com"
#define CONTACT_PHONE       @"+15148276696"
#define CONTACT_FACEBOOK    @"https://www.facebook.com/OnTheGoCoins/"
#define CONTACT_TWITTER     @"https://twitter.com/OnTheGoCoins"
#define CONTACT_GOOGLE      @"https://plus.google.com/+BitcoinATMOnTheGoCoinsLaval"
#define CONTACT_YOUTUBE     @""

#define TYPE_NEW        @"new"
#define TYPE_RESET      @"reset"
#define TYPE_COMFIRM    @"confirm"

#define NOTIFICATION_PIN        @"pin_notify"
#define NOTIFICATION_QR_CANCEL  @"qr_cancel_notify"

#define KEY_ISREGISTER  @"register"
#define KEY_NAME        @"name"
#define KEY_ADDRESS     @"address"
#define KEY_CITY        @"city"
#define KEY_PROVINCY    @"provincy"
#define KEY_ZIPCODE     @"zip"
#define KEY_PHONE       @"phone"
#define KEY_NOTE        @"note"
#define KEY_WALLET      @"wallet"
#define KEY_CURRENCY    @"currency"
#define KEY_PIN         @"pin"
#define KEY_TRANSACTION @"transaction"
#define KEY_PAYMENT     @"payment"

#define KEY_TOTAL       @"total"
#define KEY_SUBTOTAL    @"subtotal"
#define KEY_TIP         @"tip"
#define KEY_BTC         @"bitcoin"
#define KEY_TYPE        @"type"
#define KEY_DATE        @"date"
#define KEY_SENDER      @"senderWallet"

#define KEY_TITLE       @"title"
#define KEY_NOTIFICATION       @"notificate"

#define BITCOIN_CURRENCY @"BTC"
#define SATOSHI 1e8 // 100,000,000
#define SOCKET_STATE_CLOSING 2
#define SOCKET_STATE_CLOSED 3


#define USER_DEFAULTS_KEY_BASE_URL @"baseURL"
#define USER_DEFAULTS_KEY_MERCHANT_DIRECTORY_URL @"merchantDirectoryURL"
#define USER_DEFAULTS_KEY_TRANSACTION_URL @"transactionURL"
#define USER_DEFAULTS_KEY_WEB_SOCKET_URL @"webSocketURL"

#define DEFAULT_BASE_URL @"https://blockchain.info"
#define DEFAULT_MERCHANT_DIRECTORY_URL @"https://api.blockchain.info/merchant"

#define DEFAULT_TRANSACTION_URL @"https://blockchain.info/tx"
#define DEFAULT_TRANSACTION_RESULT_URL_HASH_ARGUMENT_ADDRESS_ARGUMENT @"https://blockchain.info/q/txresult/%@/%@"
#define DEFAULT_WEB_SOCKET_URL @"wss://ws.blockchain.info/inv"

#define BASE_URL [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_KEY_BASE_URL] == nil ? DEFAULT_BASE_URL : [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_KEY_BASE_URL]
#define MERCHANT_DIRECTORY_URL [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_KEY_MERCHANT_DIRECTORY_URL] == nil ? DEFAULT_MERCHANT_DIRECTORY_URL : [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_KEY_MERCHANT_DIRECTORY_URL]
#define TRANSACTION_URL [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_KEY_TRANSACTION_URL] == nil ? DEFAULT_TRANSACTION_URL : [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_KEY_TRANSACTION_URL]
#define WEB_SOCKET_URL [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_KEY_WEB_SOCKET_URL] == nil ? DEFAULT_WEB_SOCKET_URL : [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_KEY_WEB_SOCKET_URL]

#endif /* AppDefine_h */
