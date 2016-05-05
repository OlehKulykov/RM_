//
//  UIColor+HexString.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import UIKit


extension UIColor {

	/**
	Initialize color object with HEX string.
	
	- Parameter hexString: The color HEX string with a first `#` character.
	
	- Returns: Initialized color object or red color if `hexString` `#` character is missed or conversion error occurred during conversion.
	*/
	public convenience init(hexString hex: String) {
		guard hex.hasPrefix("#") else {
			self.init(red: 1, green: 0, blue: 0, alpha: 1)
			print("UIColor hexString required # character")
			return
		}

		let digits = hex[hex.startIndex.successor()..<hex.endIndex]

		guard let number = UInt32(digits, radix: 16) else {
			self.init(red: 1, green: 0, blue: 0, alpha: 1)
			print("UIColor hexString have wrong format")
			return
		}

		self.init(red: CGFloat((number & 0xFF0000) >> 16) / 255,
		          green: CGFloat((number & 0x00FF00) >>  8) / 255,
		          blue: CGFloat((number & 0x0000FF) >>  0) / 255,
		          alpha: 1)
	}
}

