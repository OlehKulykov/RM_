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
	fileprivate func setShadowPath(_ path: CGPath, color: UIColor, offset: CGSize, radius: CGFloat, opacity: CGFloat) {
		layer.masksToBounds = false
		layer.shadowRadius = radius
		layer.shadowColor = color.cgColor
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
	
	- Warning: Set shadow only after view layout was changed, due to correct view/layer `bounds`. See example.
	
	Example: 
	
	```swift
	override func layoutSubviews() {
		super.layoutSubviews()
		setShadow(UIEdgeInsetsMake(1, 2.5, 6, 2.5), color: UIColor.blackColor(), radius: 4, opacity: 0.16)
	}
	```
	*/
	public func setShadow(_ insets: UIEdgeInsets, color: UIColor, radius: CGFloat, opacity: CGFloat) {
		let screenPixel = 1.0 / UIScreen.main.scale
		let offset = radius + screenPixel
		let path = UIBezierPath()
		path.lineWidth = 1
		path.lineJoinStyle = .round

		let bounds = self.bounds

		// Top left
		var topLeft = CGPoint.zero
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
		var topRight = CGPoint.zero
		topRight.y = topLeft.y
		if insets.right > 0 {
			topRight.x = bounds.width + insets.right / 2 - screenPixel
		} else {
			topRight.x = bounds.width - offset
		}

		// Bottom right
		var bottomRight = CGPoint.zero
		bottomRight.x = topRight.x
		if insets.bottom > 0 {
			bottomRight.y = bounds.height + insets.bottom / 2 - screenPixel
		} else {
			bottomRight.y = bounds.height - offset
		}

		// Bottom left
		var bottomLeft = CGPoint.zero
		bottomLeft.y = bottomRight.y
		bottomLeft.x = topLeft.x

		// Create path
		path.move(to: topLeft)
		path.addLine(to: topRight)
		path.addLine(to: bottomRight)
		path.addLine(to: bottomLeft)

		path.close()

		setShadowPath(path.cgPath, color: color, offset: CGSize.zero, radius: radius, opacity: opacity)
	}


	/**
	Set rounded shadow for all view sides.

	- Parameter color: The color of the shadow. This value applies directly to view `layer`.

	- Parameter offset: Offset of the shadow layer.

	- Parameter radius: Shadow radius. This value applies directly to view `layer`.

	- Parameter opacity: Shadow opacity. This value applies directly to view `layer`.

	- Warning: Set shadow only after view layout was changed, due to correct view/layer `bounds`. See example.

	Example:

	```swift
	override func layoutSubviews() {
		super.layoutSubviews()
		setShadow(UIColor.blackColor(), offset: CGSizeMake(0, 1), radius: cornerRadius, opacity: 0.16)
	}
	```
	*/
	public func setShadow(_ color: UIColor, offset: CGSize, radius: CGFloat, opacity: CGFloat) {
		let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius)
		setShadowPath(shadowPath.cgPath, color: color, offset: offset, radius: radius, opacity: opacity)
	}

}
