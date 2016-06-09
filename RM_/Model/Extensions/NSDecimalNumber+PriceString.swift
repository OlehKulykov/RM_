//
//  NSDecimalNumber+PriceString.swift
//  RM_
//
//  Created by Oleh Kulykov on 08/06/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation

extension NSDecimalNumber {

	/**
	Default number formatter.
	*/
	private static func currencyFormatter(currencySymbol: String?, currencySuffix: String?) -> NSNumberFormatter {
		let currencyFormatter = NSNumberFormatter()
		currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
		currencyFormatter.locale = NSLocale.currentLocale()

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
	internal func priceString(currencySymbol: String? = nil, currencySuffix: String? = nil) -> String {
		return NSDecimalNumber.currencyFormatter(currencySymbol, currencySuffix: currencySuffix).stringFromNumber(self)!
	}
	
}
