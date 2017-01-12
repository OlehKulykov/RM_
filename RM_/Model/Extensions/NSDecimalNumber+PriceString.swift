//
//  NSDecimalNumber+PriceString.swift
//  RM_
//
//  Created by Oleh Kulykov on 08/06/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation


/// Price string generation from decimal number
extension NSDecimalNumber {

	/**
	Default number formatter.
	*/
	fileprivate static func currencyFormatter(_ currencySymbol: String?, currencySuffix: String?) -> NumberFormatter {
		let currencyFormatter = NumberFormatter()
		currencyFormatter.numberStyle = NumberFormatter.Style.currency
		currencyFormatter.locale = Locale.current

		let symbol = currencySymbol ?? "$"

		if let suffix = currencySuffix {
			currencyFormatter.currencySymbol = symbol + suffix
		} else {
			currencyFormatter.currencySymbol = symbol
		}

		// no grouping, eg " 12'234.99 "
		currencyFormatter.usesGroupingSeparator = false
		currencyFormatter.currencyGroupingSeparator = ""

		// no ".00" at the end
		//currencyFormatter.alwaysShowsDecimalSeparator = false
		//currencyFormatter.minimumFractionDigits = 0
		return currencyFormatter
	}

	/**
	Generate price string with currency symbol and separated currency suffix
	Example: <currencySymbol><currencySuffix><44.99>
	*/
	internal func priceString(_ currencySymbol: String? = nil, currencySuffix: String? = nil) -> String {
		return NSDecimalNumber.currencyFormatter(currencySymbol, currencySuffix: currencySuffix).string(from: self)!
	}
	
}
