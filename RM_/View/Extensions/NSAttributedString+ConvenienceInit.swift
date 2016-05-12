//
//  NSAttributedString+ConvenienceInit.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import UIKit

extension NSAttributedString {

	/**
	Initialize attributed string with font, color, line spacing, text aligment and optionally kerning.
	
	- Parameter string: The string for the new attributed string.
	
	- Parameter font: The attributed string text font.
	
	- Parameter color: The attributed string text color.

	- Parameter lineSpacing: The distance in points between the bottom of one line fragment and the top of the next.
	
	- Parameter textAlignment: The attributed string text alignment.
	
	- Parameter kerning: The optional number of points by which to adjust kern-pair characters, e.g. characters spacing. 
	By default this parameter is ```0``` and ingnored.
	*/
	public convenience init(string: String, font: UIFont, color: UIColor, lineSpacing: CGFloat, textAlignment: NSTextAlignment, kerning: CGFloat = 0) {
		var attributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: color]
		if kerning != 0 {
			attributes[NSKernAttributeName] = NSNumber(float: Float(kerning))
		}

		if lineSpacing != 0 {
			let style = NSMutableParagraphStyle()
			style.lineSpacing = lineSpacing
			style.alignment = textAlignment
			attributes[NSParagraphStyleAttributeName] = style
		}
		self.init(string: string, attributes: attributes)
	}


	/**
	Initialize attributed string with font, color and optionally kerning.

	- Parameter string: The string for the new attributed string.

	- Parameter font: The attributed string text font.

	- Parameter color: The attributed string text color.

	- Parameter kerning: The optional number of points by which to adjust kern-pair characters, e.g. characters spacing.
	By default this parameter is ```0``` and ingnored.
	*/
	public convenience init(string: String, font: UIFont, color: UIColor, kerning: CGFloat = 0) {
		var attributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: color]
		if kerning != 0 {
			attributes[NSKernAttributeName] = NSNumber(float: Float(kerning))
		}
		self.init(string: string, attributes: attributes)
	}
}
