//
//  UIView+EdgedBorders.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import UIKit

extension UIView {

	/**
	Add borders to the view.
	
	- Parameter edges: View adges to that add border.
 
	- Parameter color: Color of the added borders.
	
	- Parameter thickness: The thickness of the border views, e.g. border width in a case of vertical or height in case of horizontal.
	
	- Returns: Array with added borders.
	*/
	func addBorders(edges: UIRectEdge, color: UIColor, thickness: CGFloat) -> [UIView] {

		func border() -> UIView {
			let border = UIView(frame: CGRectZero)
			border.backgroundColor = color
			border.translatesAutoresizingMaskIntoConstraints = false
			return border
		}

		var borders = [UIView]()
		if edges.contains(.Top) || edges.contains(.All) {
			let top = border()
			self.addSubview(top)
			self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[top(==thickness)]",
				options: [],
				metrics: ["thickness": thickness],
				views: ["top": top]))
			self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[top]-(0)-|",
				options: [],
				metrics: nil,
				views: ["top": top]))
			borders.append(top)
		}

		if edges.contains(.Left) || edges.contains(.All) {
			let left = border()
			self.addSubview(left)
			self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[left(==thickness)]",
				options: [],
				metrics: ["thickness": thickness],
				views: ["left": left]))
			self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[left]-(0)-|",
				options: [],
				metrics: nil,
				views: ["left": left]))
			borders.append(left)
		}

		if edges.contains(.Right) || edges.contains(.All) {
			let right = border()
			self.addSubview(right)
			self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[right(==thickness)]-(0)-|",
				options: [],
				metrics: ["thickness": thickness],
				views: ["right": right]))
			self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[right]-(0)-|",
				options: [],
				metrics: nil,
				views: ["right": right]))
			borders.append(right)
		}

		if edges.contains(.Bottom) || edges.contains(.All) {
			let bottom = border()
			self.addSubview(bottom)
			self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bottom(==thickness)]-(0)-|",
				options: [],
				metrics: ["thickness": thickness],
				views: ["bottom": bottom]))
			self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[bottom]-(0)-|",
				options: [],
				metrics: nil,
				views: ["bottom": bottom]))
			borders.append(bottom)
		}
		return borders
	}
	
}

