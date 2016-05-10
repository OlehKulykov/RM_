//
//  String+AttributedString.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import UIKit

extension String {

	public func attributed(font: UIFont, color: UIColor) -> NSAttributedString {
		return NSAttributedString(string: self, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color])
	}
}

