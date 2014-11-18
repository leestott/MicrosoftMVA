--[[/*
 * (C) 2012-2013 Marmalade.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */--]]

--[[

/**
 Global unified in-app purchasing API that supports the following platforms:
 The follow platforms and vendors are supported:
 - Android
   - Amazon App Store
   - Android Market
   - Google Play v3
   - Samsung Apps
   - Fortumo
 - BlackBerry
 - iOS
 - Windows Phone 8
 - Windows Store 8

 Function descriptions:
 - billing:isAvailable(vendor) - Returns true if billing is available, otherwise false
 - billing:init(vendor) - Initialises the billing system, returns true on success
 - billing:terminate() - Terminates the billing system
 - billing:queryProduct(productId) - Queries billing for information for the product specified by product id
 - billing:purchaseProduct(productId) - Starts the purchase of the product specified by product id
 - billing:finishTransaction(data) - Finishes / finalises a transaction
 - billing:consumeProduct(purchase_token) - Consumes the consumable purchase
 - billing:restoreTransactions() - Restores previously purchased products
 - billing:setTestMode(enable) - Sets test or live mode
 - billing:setItemRange(startItem, endItem) - Sets the item start and item end indices (Samsung only)
 - billing:setDisplayName(display_name) - Sets the name of the product displayed by Fortumo (Fortumo only)
 - billing:setServiceID(service_id) - Sets the service ID that is used to identiy a Fortumo service (Fortumo only)
 - billing:setAppSecret(app_secret) - Sets the app secret that is associated with the Fortumo service (Fortumo only)
 - billing:setConsumable(consumable) - Sets consumable or none consumable purchase (Fortumo only)

 Depending upon the platform a product id is defined as:
 - iOS - The Product ID as defined in the in-app purchases section of the app on Apple iTunes Connect, e.g. com.companyname.appname.itemname
 - Android - The in-app Product ID as defined in the in-app purchases section of the app on Google Play's developer console, e.g. com.companyname.appname.itemname
 - BlackBerry - The Product SKU as defined in the virtual goods section of the app on the BlackBerry developer portal, e.g. appname_itemname

 Billing errors descriptions:
 - BILLING_ERROR_CLIENT_INVALID				- The client is invalid
 - BILLING_ERROR_PAYMENT_CANCELLED         - Payment was cancelled
 - BILLING_ERROR_PAYMENT_INVALID           - Payment request is invalid
 - BILLING_ERROR_PAYMENT_NOT_ALLOWED       - Payment is prohibited by the device
 - BILLING_ERROR_PURCHASE_UNKNOWN          - Purchase failed for unknown reason
 - BILLING_ERROR_PURCHASE_DISABLED         - Purchasing is disabled
 - BILLING_ERROR_NO_CONNECTION             - No connection to store available
 - BILLING_ERROR_RESTORE_FAILED            - Product restore failed
 - BILLING_ERROR_UNKNOWN_PRODUCT           - Product was not found in the store
 - BILLING_ERROR_DEVELOPER_ERROR           - The application making the request is not properly signed
 - BILLING_ERROR_UNAVAILABLE               - The billing extension is not available
 - BILLING_ERROR_ALREADY_OWNED             - The product is already owned
 - BILLING_ERROR_NOT_OWNED				   - Failure to consume / finalise because item is not owned
 - BILLING_ERROR_FAILED                    - General failure
 - BILLING_ERROR_PENDING                   - Payment is pending
 - BILLING_ERROR_NOT_READY                 - Market is not yet ready to use
 - BILLING_ERROR_SECURITY_FAILED		   - Security check failed 
 - BILLING_RESULT_NO_ERROR                 - General successful error code

 Product refunds:
 The API does not directly force a product refund, however should one occur the refundAvailable event will be raised. The refundAvailable 
 event table is defined as follows:
 - productId			- Product identifier
 - finaliseData			- Data used to finalise the transaction

 Note that finishTransaction() should be called to inform the store that the refund was completed.

 Refunds are only supported by the Android platform.

 Android Public Key:
 For the Android platform you can set your public key in the app.icf file as shown below:
 
 [BILLING]
 androidPublicKey1="Part of Android public key"
 androidPublicKey2="Part of Android public key"
 androidPublicKey3="Part of Android public key"
 androidPublicKey4="Part of Android public key"
 androidPublicKey5="Part of Android public key"

 Note that the key is split across up to 5 settings, each setting can carry a max of 127 characters. The complete key will be a concatenation 
 of all 5 settings.

*/

--]]

--------------------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------------------
billing = {}

--[[
/**
 @brief Checks availability of in-app purchasing.

 The following vendors are supported:
 - amazon - Amazon App Store
 - android_market - Android Market
 - google_play - Google Play Billing v3 (Android 2.2 and above)
 - samsung - Samsung Apps (Android 2.3.3 and above)
 - fortumo - Fortumo
 - blackberry - BlackBerry App World
 - ios - iOS App Store
 - wp8 - Windows Phone 8
 - ws8 - Windows Store 8

 @note You do not need to supply a vendor for platforms other than Android.
 @param vendor The app store vendor for devices that support multiple app stores (Android only, default is Google Play)
 @return True if the app store system is available, false otherwise.
*/
--]]
function billing:isAvailable(vendor)
	return quick.QBilling:isAvailable(vendor)
end

--[[
/**
 @brief Initialises the billing system.

 The following vendors are supported:
 - amazon - Amazon App Store
 - android_market - Android Market
 - google_play - Google Play Billing v3 (Android 2.2 and above)
 - samsung - Samsung Apps (Android 2.3.3 and above)
 - fortumo - Fortumo
 - blackberry - BlackBerry App World
 - ios - iOS App Store
 - wp8 - Windows Phone 8
 - ws8 - Windows Store 8

 @note You do not need to supply a vendor for platforms other than Android.
 @param vendor The app store vendor for devices that support multiple app stores (Android only, default is Google Play)
 @param data Extra data to pass to initialisation such as Android Public key for Android Market / Google Play or Item Group ID for Samsung
 @return True if billing was initialised, false otherwise.
*/
--]]
function billing:init(vendor, data)
	return quick.QBilling:init(vendor, data)
end

--[[
/**
@brief Terminates the billing system.

*/
--]]
function billing:terminate()
	quick.QBilling:terminate()
end

--[[
/**
 @brief Queries product information.

 Queries IwBilling for information regarding the supplied list of product ID's.

 Supported by the following platforms / vendors:
 - Android
   - Amazon App Store
   - Android Market
   - Google Play v3
   - Samsung Apps
 - BlackBerry
 - iOS
 - Windows Phone 8
 - Windows Store 8

 Please note the following platform restrictions:
 - BlackBerry - Only a single product can be queried, attempting to query more than one product will result in failure. In addition, only the price of the product is returned
 - WP8 - Only a single product can be queried, attempting to query more than one product will result in failure.

 When the product information becomes available the infoAvailable event will be raised providing information about the product. 
 The infoAvailable event table is defined as follows:
 - productId			- Product identifier
 - title				- The title of the product
 - description			- The localised description of the product
 - price				- The localised price of the product

 If an error occurs then the billingError event will be raised providing information about the error that occurred. The billingError 
 event table is defined as follows:
 - productId			- Product identifier
 - error				- The error that occurred

 @param productId The product id of the product to query.

 @return true if a successful query request was created, false otherwise.
*/
--]]
function billing:queryProduct(productId)
	return quick.QBilling:queryProduct(productId)
end

--[[
/**
 @brief Purchases a product.

 Upon successfull purchase the receiptAvailable event will be raised providing access to product information. The receiptAvailable 
 event table is defined as follows:
 - productId			- Product identifier
 - transactionId		- Transaction identifier
 - date					- Date of purchase
 - startDate			- Start date of subscription, if a subscription (Amazon / BlackBerry only)
 - endDate				- End date of subscription, if a subscription (Amazon / BlackBerry only)
 - receipt				- Transaction receipt
 - finaliseData			- Data used to finalise the transaction
 - purchaseToken		- Purchase token which can be used to consume the product
 - restored				- true if item was restored, false if item was purchased

 If an error occurs then the billingError event will be raised providing information about the error that occurred. The billingError 
 event table is defined as follows:
 - productId			- Product identifier
 - error				- The error that occurred

 @param productId The product id of the product to start purchasing.

 @return true if a successful product purchase request was created, false otherwise.
*/
--]]
function billing:purchaseProduct(productId)
	return quick.QBilling:purchaseProduct(productId)
end

--[[
/**
 @brief Restores previously purchased products.

 Previous transaction restoration is supported by the following platforms / vendors:
 - Android
   - Amazon App Store
   - Android Market
   - Google Play v3
   - Samsung Apps
   - Fortumo
 - BlackBerry
 - iOS
 - Windows Phone 8
 - Windows Store 8

 iOS and Android:
 Begins the product restoration process to restore all none consumable products that the user has previously purchased for this application. The
 ReceiptAvailableCallback callback will be called for each product that is successfully restored, providing information about the purchase.

 Fortumo:
 Only a single product can be restored at one time. The service ID and app secret must be set for the product that is to be restored before calling
 restoreTransactions.

 WP8:
 Begins the product restoration process to restore all non-finalized consumable products that the user has previously purchased for this application. The
 ReceiptAvailableCallback will be called for each product that is successfully restored, providing information about the ProductID and FinaliseData.

 For each product that is restored the receiptAvailable event will be raised providing access to product information. The receiptAvailable 
 event table is defined as follows:
 - productId			- Product identifier
 - transactionId		- Transaction identifier
 - date					- Date of purchase
 - startDate			- Start date of subscription, if a subscription (Amazon / BlackBerry only)
 - endDate				- End date of subscription, if a subscription (Amazon / BlackBerry only)
 - receipt				- Transaction receipt
 - finaliseData			- Data used to finalise the transaction
 - purchaseToken		- Purchase token which can be used to consume the product
 - restored				- true if item was restored, false if item was purchased

 If an error occurs then the billingError event will be raised providing information about the error that occurred. The billingError 
 event table is defined as follows:
 - productId			- Product identifier
 - error				- The error that occurred

 @return true if a successful product restore request was created, false otherwise.
*/
--]]
function billing:restoreTransactions()
	return quick.QBilling:restoreTransactions()
end

--[[
/**
 @brief Finishes / finalises a transaction. 

 When a purchase request is made it is not finalised until this function is called. This gives the developer the opportunity to validate 
 the transaction / download content before notifying the store that the purchase was successfully completed. If the app exits before the 
 purchase has been finished, the system will inform the app of the purchase again in the future. 

 Finishing transactions is only required for the following platforms / vendors:
 - Android
   - Amazon
   - Android Market
 - iOS
 - Windows Phone 8
 - Windows Store 8

 @param data Finalisation data that is returned by product purchase / restore
 @return true if product was finalised, false otherwise.
*/
--]]
function billing:finishTransaction(data)
	return quick.QBilling:finishTransaction(data)
end

--[[
/**
 @brief Consumes a product

 When a purchase request is made for a consumable product a transasction token is returned that can be used to consume the product at a 
 later date making it available for purchase again in the future.

 Product consumption is supported by the following stores:
 - Android Google Play

 @param token Purchase token that is returned by product purchase / restore
*/
--]]
function billing:consumeProduct(token)
	return quick.QBilling:consumeProduct(token)
end

--[[
/**
 @brief Converts an error number to an error string.

 @return Error string.
*/
--]]
function billing:getErrorString(error)
	return quick.QBilling:getErrorString(error)
end

--[[
/**
 @brief Sets the item start and item end indices

 Samsung IAP restore products and query products require an item range to be specified. Note that the range starts at 1 and not 0. Default is 1 to 15

 @param	startItem	Start item index (1 based), default is 1
 @param	endItem	End item index, default is 15
*/
--]]
function billing:setItemRange(startItem, endItem)
	return quick.QBilling:setItemRange(startItem, endItem)
end

--[[
/**
 @brief Specifies live or test mode

 Test mode will allow the return of test responses, whilst live mode will carry out valid in-app purchases.
 The following platforms and vendors are supported:
 - Android
   - Samsung Apps
 - BlackBerry

 @param	enable	True to set test mode, otherwise live mode is set.
*/
--]]
function billing:setTestMode(enable)
	return quick.QBilling:setTestMode(enable)
end

--[[
/**
 @brief Sets the current product ID

 Sets the ID of the current product

 @param	productId	product ID.
*/
--]]
function billing:setCurrentProductID(productId)
    quick.QBilling:setCurrentProductID(productId);
end

--[[
/**
 @brief Sets the item display name

 The display name is the name of the purchasable service that is displayed to the user when making a purchase using Fortumo

 @param	displayName	Item display name.
*/
--]]
function billing:setDisplayName(displayName)
    quick.QBilling:setDisplayName(displayName);
end

--[[
/**
 @brief Sets the service ID

 The service ID is a unique identifier that is supplied by Fortumo for the service that the user can purchase. The ID is available 
 in the Fortumo services dashboard under the "General" tab.

 @param	serviceId	The service ID.
*/
--]]
function billing:setServiceID(serviceId)
    quick.QBilling:setServiceID(serviceId);
end

--[[
/**
 @brief Sets the In-application secret

 Sets the In-application secret that is associated with the Fortumo service. The In-application secret is available 
 in the Fortumo services dashboard under the "General" tab.

 @param	appSecret The In-application secret
*/
--]]
function billing:setAppSecret(appSecret)
    quick.QBilling:setAppSecret(appSecret);
end

--[[
/**
 @brief Sets the purchase type

 Sets the type of purchase for the Forumo service, Possible values include:
 - consumable - A consumable product such as coins
 - none_consumable - A none conumable product such as additional game levels
 - subscription - A subscription based product such as m magazine

 @param	type	The purchase type
*/
--]]
function billing:setPurchaseType(type)
    return quick.QBilling:setPurchaseType(type)
end
