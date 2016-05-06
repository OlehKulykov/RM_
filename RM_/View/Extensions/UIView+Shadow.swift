//
//  UIView+Shadow.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import UIKit

/**
Add shadows to the view.
*/
extension UIView {

	/// Set shadow path with common parameters.
	private func setShadowPath(path: CGPath, color: UIColor, offset: CGSize, radius: CGFloat, opacity: CGFloat) {
		layer.masksToBounds = false
		layer.shadowRadius = radius
		layer.shadowColor = color.CGColor
		layer.shadowOffset = offset
		layer.shadowOpacity = Float(opacity)
		layer.shadowPath = path
	}


	/**
	Set shadow for some or all view sides. 
 
	- Parameter insets: Shadow insets in points for each view side.
	Provide `0` to ignore or positive value in points to define thickness of the shadow part.
	
	- Parameter color: The color of the shadow. This value applies directly to view `layer`.
	
	- Parameter radius: Shadow radius. This value applies directly to view `layer`.
	
	- Parameter opacity: Shadow opacity. This value applies directly to view `layer`.
	
	- Warning: Set shadow only after view layout was changed, due to correct view/layer bounds. See example.
	
	Example: 
	
	```swift
		override func layoutSubviews() {
			super.layoutSubviews()
			setShadow(UIEdgeInsetsMake(1, 2.5, 6, 2.5), color: UIColor.blackColor(), radius: 4, opacity: 0.16)
		}
	```
	*/
	public func setShadow(insets: UIEdgeInsets, color: UIColor, radius: CGFloat, opacity: CGFloat) {
		let screenPixel = 1.0 / UIScreen.mainScreen().scale
		let offset = radius + screenPixel
		let path = UIBezierPath()
		path.lineWidth = 1
		path.lineJoinStyle = .Round

		let bounds = self.bounds

		// Top left
		var topLeft = CGPointZero
		if insets.top > 0 {
			topLeft.y = -insets.top / 2 + screenPixel
		} else {
			topLeft.y = offset
		}

		if insets.left > 0 {
			topLeft.x = -insets.left / 2 + screenPixel
		} else {
			topLeft.x = offset
		}

		// Top right
		var topRight = CGPointZero
		topRight.y = topLeft.y
		if insets.right > 0 {
			topRight.x = bounds.width + insets.right / 2 - screenPixel
		} else {
			topRight.x = bounds.width - offset
		}

		// Bottom right
		var bottomRight = CGPointZero
		bottomRight.x = topRight.x
		if insets.bottom > 0 {
			bottomRight.y = bounds.height + insets.bottom / 2 - screenPixel
		} else {
			bottomRight.y = bounds.height - offset
		}

		// Bottom left
		var bottomLeft = CGPointZero
		bottomLeft.y = bottomRight.y
		bottomLeft.x = topLeft.x

		// Create path
		path.moveToPoint(topLeft)
		path.addLineToPoint(topRight)
		path.addLineToPoint(bottomRight)
		path.addLineToPoint(bottomLeft)

		path.closePath()

		setShadowPath(path.CGPath, color: color, offset: CGSizeZero, radius: radius, opacity: opacity)
	}


	/**
	Set rounded shadow for all view sides.

	- Parameter color: The color of the shadow. This value applies directly to view `layer`.

	- Parameter offset: Offset of the shadow layer.

	- Parameter radius: Shadow radius. This value applies directly to view `layer`.

	- Parameter opacity: Shadow opacity. This value applies directly to view `layer`.

	- Warning: Set shadow only after view layout was changed, due to correct view/layer bounds. See example.

	Example:

	```swift
		override func layoutSubviews() {
			super.layoutSubviews()
			setShadow(UIColor.blackColor(), offset: CGSizeMake(0, 1), radius: cornerRadius, opacity: 0.16)
		}
	```
	*/
	public func setShadow(color: UIColor, offset: CGSize, radius: CGFloat, opacity: CGFloat) {
		let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius)
		setShadowPath(shadowPath.CGPath, color: color, offset: offset, radius: radius, opacity: opacity)
	}

}
