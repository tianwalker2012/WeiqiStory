//
//  EZAppPurchase.m
//  WeiqiStory
//
//  Created by xietian on 12-12-11.
//
//


#import "EZAppPurchase.h"


static EZAppPurchase* instance;

@implementation EZAppPurchase

//Ok, finally, whenever I call this, I only get call the block once
//I love this.
+ (EZAppPurchase*) getInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^ { instance = [[self alloc] init]; });
    return instance;
}

//Make sure this only get called once, use singleton mode.
- (id) init
{
    self = [super init];
    _productID2Product = [[NSMutableDictionary alloc] init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    return self;
}


- (void) queryPurchaseInfo:(NSString*)productID
{
    NSSet* identifierSet = [NSSet setWithArray:@[productID]];
    SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:identifierSet];
    request.delegate = self;
    [request start];
}
//That's why, we need to keep in touch with the society, we could have multiple solutions for the things happened around us.
//This method will check if the product already fetched,
//If it is not, it will try to fetch the product first.
//Then it will try call trigger purchase,
//It will have 2 status,
//Purchase success, failed, or purchased before.
//Let's purchased before will be treat as already purchased.
//Ok, the logic is clear enough.
- (void) purchase:(NSString*)productID successBlock:(EZEventBlock)successBlock failedBlock:(EZEventBlock)failedBlock;
{
    __weak EZAppPurchase* weakSelf = self;
    
    _purchaseCompleteBlock = successBlock;
    EZDEBUG(@"Setup the _purchaseComplete block, the address is:%i", (int)_purchaseCompleteBlock);
    _purchaseFailedBlock = failedBlock;
    SKProduct* product = [weakSelf.productID2Product objectForKey:productID];
    
    _productQuerySuccess = ^(SKProductsResponse* response){
        SKProduct* product = [weakSelf.productID2Product objectForKey:productID];
        if(product){
            EZDEBUG(@"Have found product for ID:%@", productID);
            [weakSelf triggerPurchase:product];
        }
    };
    
    if(product){
        _productQuerySuccess(nil);
    }else{
        [self queryPurchaseInfo:productID];
        _productQueryFailed = ^(id errors){
            failedBlock(errors);
        };
    }
}


- (BOOL) isPurchased:(NSString*)pid
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:pid];
}


- (void) setPurchased:(BOOL)purchased pid:(NSString*)pid
{
    [[NSUserDefaults standardUserDefaults] setBool:purchased forKey:pid];
}

//This will be the method really do the purchase
- (void) triggerPurchase:(SKProduct*)product
{
    SKPayment* payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

// Sent immediately before -requestDidFinish:
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    for(SKProduct* product in response.products){
        EZDEBUG(@"Add product identifier:%@", product.productIdentifier);
        [_productID2Product setValue:product forKey:product.productIdentifier];
    }
    
    if(_productQuerySuccess){
        _productQuerySuccess(response);
    }
    
}

- (void) restorePurchase:(EZEventBlock)successBlock
{
    _purchaseCompleteBlock = successBlock;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    EZDEBUG(@"Failed to query product:%@", error);
    if(_productQueryFailed){
        _productQueryFailed(error);
    }
}

// Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
//Mean user successfully brought something.
//What should we do here?
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction* tr in transactions){
        //Finish it at the first line, to remove the risk of jump it over
        EZDEBUG(@"Transaction status:%i, detail:%@", tr.transactionState, tr);
        //
        switch (tr.transactionState) {
            case SKPaymentTransactionStatePurchased:
                EZDEBUG(@"purchased");
            case SKPaymentTransactionStateRestored:{
                    EZDEBUG(@"restored status:%i, the complete point:%i", tr.transactionState, (int)_purchaseCompleteBlock);
                    if(_purchaseCompleteBlock){
                        _purchaseCompleteBlock(tr);
                    }
                    //[self setPurchased:TRUE pid:tr.payment.productIdentifier];
                    [[SKPaymentQueue defaultQueue] finishTransaction:tr];
                }
                break;
            case SKPaymentTransactionStateFailed:{
                    EZDEBUG(@"failed status:%i", tr.transactionState);
                    if(_purchaseFailedBlock){
                        _purchaseFailedBlock(tr);
                    }
                    [[SKPaymentQueue defaultQueue] finishTransaction:tr];
                }
                break;
                
            default:
                break;
        }
    }
    
   
}

// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    EZDEBUG(@"removedTransactions get called:%i", transactions.count);
}
// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
// If use downloaded this app on iPad and he have a iPhone, so how could I sync up the purchase status among the different equipments?
//Let's check the video and do it accordingly.

//Should I do something more in this method?
//Not necessarily, Just keep it as it is.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    EZDEBUG(@"Restore transaction encounter errors:%@", error);
    
}
// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    EZDEBUG(@"paymentQueueRestoreCompletedTransactionFinished");
}

// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    EZDEBUG(@"paymentQueue updatedDownloads get called, this is only possible when I host my download on the app server, right?");
}
@end
