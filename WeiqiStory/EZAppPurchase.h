//
//  EZAppPurchase.h
//  WeiqiStory
//
//  Created by xietian on 12-12-11.
//
//

#import <Foundation/Foundation.h>
#import "EZConstants.h"
#import <StoreKit/StoreKit.h>

//What's the purpose of this?
//I will do all the in-App purchase in this class
@interface EZAppPurchase : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>


+ (EZAppPurchase*) getInstance;
//I will purchase the productId and tell you if you succeed or not
//The sender is the object which you could query the status out,
//So that you may do something with the UI or not.
//Query AppStore for what I can sell.
- (void) queryPurchaseInfo:(NSString*)productID;


//What's the purpose of this method?
//This method is to help user to get all the history brought in-app gadget back.
//That is what we will do
//I can call this method, whenever user are switch this method from background to forground
//No, not the cases
//It will ask user to input username and password, which could be very annoying to your user.
//So what should we do?
//Let's add a button to do this. Consider it later,
//Code here is just serve as a document, so that I knew what I have done.

- (void) restorePurchase:(EZEventBlock)successBlock;

//Why do I need this?
//I will do the actual purchase in this method.
- (void) purchase:(NSString*)productID successBlock:(EZEventBlock)successBlock failedBlock:(EZEventBlock)failedBlock;


//This will be the method really do the purchase
- (void) triggerPurchase:(SKProduct*)product;


- (BOOL) isPurchased:(NSString*)pid;


- (void) setPurchased:(BOOL)purchased pid:(NSString*)pid;

@property (nonatomic, strong) EZEventBlock purchaseCompleteBlock;
@property (nonatomic, strong) EZEventBlock purchaseFailedBlock;


@property (nonatomic, strong) EZEventBlock productQuerySuccess;
@property (nonatomic, strong) EZEventBlock productQueryFailed;

@property (nonatomic, strong) NSMutableDictionary* productID2Product;

@end
