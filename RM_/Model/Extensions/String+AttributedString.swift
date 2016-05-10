//
//  String+AttributedString.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import UIKit

extension String {

	/**
	Create attributed version of the string with color and font.
	
	- Parameter font: The attributed text font.
	
	- Parameter color: The attributed text color.
	
	- Returns: Immutable attributed version of the string.
	*/
	public func attributed(font: UIFont, color: UIColor) -> NSAttributedString {
		return NSAttributedString(string: self, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color])
	}
}

