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

	- Note: Size of the image automatically updated to the main screen scale.
	
	- Parameter color: The image color.
	
	- Parameter size: The image size in points. Defaults is [1; 1].
	*/
	public convenience init(color: UIColor, size: CGSize = CGSizeMake(1, 1)) {
		let screenScale = UIScreen.mainScreen().scale
		let cgSize = CGSizeMake(max(screenScale, screenScale * size.width), max(screenScale, screenScale * size.height))
		UIGraphicsBeginImageContext(cgSize)
		let context = UIGraphicsGetCurrentContext()
		CGContextSetFillColorWithColor(context, color.CGColor)
		CGContextFillRect(context, CGRect(origin: CGPointZero, size: cgSize))
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.init(CGImage: image.CGImage!, scale: screenScale, orientation: UIImageOrientation.Up)
	}
}

