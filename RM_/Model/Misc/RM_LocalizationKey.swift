//
//  RM_LocalizationKey.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation


/**
Application localizable keys. This enum contains string keys for ```Localizable.strings``` file and
should be translated to all available languages.
*/
enum RM_LocalizationKey: String {

	//MARK: Localization cases

	/**
	API request can't process/parse received data. Received data could be broken or have unsupported format.
	*/
	case APIRequestCantHandleResponce = "apiRequestCantHandleResponce"


	//MARK: Localized string from case computed variable

	/**
	Get localized string from main bundle table.

	Example: get localized string from case.

	```swift
		print("Localized string: \(RM_LocalizationKey.<KEY>.localized)")
	```
	*/
	var localized: String {
		return NSLocalizedString(self.rawValue, comment: "")
	}
}
