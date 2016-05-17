//
//  UIView+IBInspectable.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import UIKit


/**
Interface Builder inspectable properties. 
All this properties/variables interacts dirrectly with view or it's ```layer```.
No need to hardcode this parameters.
*/
extension UIView {

	/**
	The radius to use when drawing rounded corners for the layer’s background.
	*/
	@IBInspectable public var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
		}
	}


	/**
	The color of the layer’s border. 
	*/
	@IBInspectable public var borderColor: UIColor {
		get {
			return UIColor(CGColor: layer.borderColor ?? UIColor.clearColor().CGColor) ?? UIColor.clearColor()
		}
		set {
			layer.borderColor = newValue.CGColor
		}
	}


	/**
	The width of the layer’s border.
	*/
	@IBInspectable public var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}


	/**
	A Boolean value that determines whether subviews are confined to the bounds of the view.
	*/
	@IBInspectable public var clipsToBounds_: Bool {
		get {
			return clipsToBounds
		}
		set {
			clipsToBounds = newValue
		}
	}


	/**
	A Boolean indicating whether sublayers are clipped to the layer’s bounds.
	*/
	@IBInspectable public var masksToBounds_: Bool {
		get {
			return layer.masksToBounds
		}
		set {
			layer.masksToBounds = newValue
		}
	}

}

