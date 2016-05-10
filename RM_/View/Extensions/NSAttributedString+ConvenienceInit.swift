//
//  NSAttributedString+ConvenienceInit.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import UIKit

extension NSAttributedString {

	public convenience init(string: String, font: UIFont, color: UIColor, kerning: CGFloat = 0) {
		var attributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: color]
		if kerning != 0 {
			attributes[NSKernAttributeName] = NSNumber(float: Float(kerning))
		}
		self.init(string: string, attributes: attributes)
	}
}
