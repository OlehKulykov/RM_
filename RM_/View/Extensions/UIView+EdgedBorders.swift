//
//  UIView+EdgedBorders.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import UIKit

extension UIView {

	/// Creates border view with border color.
	/// - Parameter color: The border view color.
	private static func createBorderView(color: UIColor) -> UIView {
		let border = UIView(frame: CGRectZero)
		border.backgroundColor = color
		border.translatesAutoresizingMaskIntoConstraints = false
		return border
	}


	/**
	Add top border view to the receiver. 
	Border is `UIView` and location of the border controls by layout constraints.
	
	- Parameter color: The border color.
	
	- Parameter height: The border height in points.
	
	- Parameter insets: Optional insets for the border. By default insets is `UIEdgeInsetsZero`
	
	- Returns: Added border view.
	
	- Note: The `bottom` insets value is ignored.
	*/
	public func addTopBorder(color: UIColor, height: CGFloat, insets: UIEdgeInsets = UIEdgeInsetsZero) -> UIView {
		let border = UIView.createBorderView(color)
		addSubview(border)
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(top)-[border(==height)]",
			options: [],
			metrics: ["height" : height, "top" : insets.top],
			views: ["border" : border]))
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(left)-[border]-(right)-|",
			options: [],
			metrics: ["left" : insets.left, "right" : insets.right],
			views: ["border" : border]))
		return border
	}


	/**
	Add left border view to the receiver. 
	Border is `UIView` and location of the border controls by layout constraints.

	- Parameter color: The border color.

	- Parameter width: The border width in points.

	- Parameter insets: Optional insets for the border. By default insets is `UIEdgeInsetsZero`

	- Returns: Added border view.

	- Note: The `right` insets value is ignored.
	*/
	public func addLeftBorder(color: UIColor, width: CGFloat, insets: UIEdgeInsets = UIEdgeInsetsZero) -> UIView {
		let border = UIView.createBorderView(color)
		addSubview(border)
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(left)-[border(==width)]",
			options: [],
			metrics: ["width" : width, "left" : insets.left],
			views: ["border" : border]))
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(top)-[border]-(bottom)-|",
			options: [],
			metrics: ["top" : insets.top, "bottom" : insets.bottom],
			views: ["border" : border]))
		return border
	}


	/**
	Add right border view to the receiver. 
	Border is `UIView` and location of the border controls by layout constraints.

	- Parameter color: The border color.

	- Parameter width: The border width in points.

	- Parameter insets: Optional insets for the border. By default insets is `UIEdgeInsetsZero`

	- Returns: Added border view.

	- Note: The `left` insets value is ignored.
	*/
	public func addRightBorder(color: UIColor, width: CGFloat, insets: UIEdgeInsets = UIEdgeInsetsZero) -> UIView {
		let border = UIView.createBorderView(color)
		addSubview(border)
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[border(==width)]-(right)-|",
			options: [],
			metrics: ["width" : width, "right" : insets.right],
			views: ["border" : border]))
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(top)-[border]-(bottom)-|",
			options: [],
			metrics: ["top" : insets.top, "bottom" : insets.bottom],
			views: ["border" : border]))
		return border
	}


	/**
	Add bottom border view to the receiver. 
	Border is `UIView` and location of the border controls by layout constraints.

	- Parameter color: The border color.

	- Parameter height: The border height in points.

	- Parameter insets: Optional insets for the border. By default insets is `UIEdgeInsetsZero`

	- Returns: Added border view.

	- Note: The `top` insets value is ignored.
	*/
	public func addBottomBorder(color: UIColor, height: CGFloat, insets: UIEdgeInsets = UIEdgeInsetsZero) -> UIView {
		let border = UIView.createBorderView(color)
		addSubview(border)
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[border(==height)]-(bottom)-|",
			options: [],
			metrics: ["height" : height, "bottom" : insets.bottom],
			views: ["border" : border]))
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(left)-[border]-(right)-|",
			options: [],
			metrics: ["left" : insets.left, "right" : insets.right],
			views: ["border" : border]))
		return border
	}


	/**
	Add borders to the view. 
	For each required rectangle edge using appropriate methods, e.g. 'addTopBorder', 'addLeftBorder', etc.
	
	- Note: The adding borders sequence is: `top`, `left`, `bottom`, `right`.

	- Parameter edges: View edges to that add borders.

	- Parameter color: Color of the added borders.

	- Parameter thickness: The thickness of the border views, e.g. border width in a case of vertical or height in case of horizontal.

	- Returns: Array with added borders.
	
	Example:

	```swift
	// Add top and left border with the same color and thickness
	let borders = view.addBorders([.Top, .Left], color: UIColor.redColor(), thickness: 1.5)
	
	// Add single bottom border
	view.addBorders(.Bottom, color: UIColor.redColor(), thickness: 0.5)
	```
	*/
	public func addBorders(edges: UIRectEdge, color: UIColor, thickness: CGFloat) -> [UIView] {
		var borders = [UIView]()
		if edges.contains(.Top) || edges.contains(.All) {
			borders.append(addTopBorder(color, height: thickness))
		}

		if edges.contains(.Left) || edges.contains(.All) {
			borders.append(addLeftBorder(color, width: thickness))
		}

		if edges.contains(.Bottom) || edges.contains(.All) {
			borders.append(addBottomBorder(color, height: thickness))
		}

		if edges.contains(.Right) || edges.contains(.All) {
			borders.append(addRightBorder(color, width: thickness))
		}
		return borders
	}

}

