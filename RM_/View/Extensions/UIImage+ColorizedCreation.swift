//
//  UIImage+ColorizedCreation.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import UIKit

extension UIImage {

	/**
	Initialize image that filled with color with an optional size.
	
	- Parameter color: The image color.
	
	- Parameter size: The image size in points. Defaults is [1; 1].
	*/
	public convenience init(color: UIColor, size: CGSize = CGSizeMake(1, 1)) {
		UIGraphicsBeginImageContext(size)
		let context = UIGraphicsGetCurrentContext()
		CGContextSetFillColorWithColor(context, color.CGColor)
		CGContextFillRect(context, CGRect(origin: CGPointZero, size: size))
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.init(CGImage: image.CGImage!, scale: UIScreen.mainScreen().scale, orientation: UIImageOrientation.Up)
	}
}

