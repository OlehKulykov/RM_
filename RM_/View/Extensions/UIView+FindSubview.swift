//
//  UIView+FindSubview.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import UIKit


extension UIView {

	/**
	Recursively find subview of type `T` and optional tag value.

	- Parameter tag: Optional tag of subview.

	- Returns: Located subview or nil if not found.
	*/
	func findSubView<T>(_ tag: Int = 0) -> T? where T: UIView {
		for subview in subviews {
			if let result = subview as? T, result.tag == tag {
				return result
			} else if let result: T = subview.findSubView(tag) {
				return result
			}
		}
		return nil
	}
}
