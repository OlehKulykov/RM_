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
	
	- Parameter size: The image size in points. Default size is [1; 1].
	*/
	public convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		let screenScale = UIScreen.main.scale
		let cgSize = CGSize(width: max(screenScale, screenScale * size.width), height: max(screenScale, screenScale * size.height))
		UIGraphicsBeginImageContext(cgSize)
		let context = UIGraphicsGetCurrentContext()
		context?.setFillColor(color.cgColor)
		context?.fill(CGRect(origin: CGPoint.zero, size: cgSize))
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.init(cgImage: (image?.cgImage!)!, scale: screenScale, orientation: UIImageOrientation.up)
	}
}

