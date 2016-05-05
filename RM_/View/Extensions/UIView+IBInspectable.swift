//
//  UIView+IBInspectable.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import UIKit

// Interface Builder inpectable properties. No need to hardcode this parameters.

extension UIView {

	@IBInspectable public var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
		}
	}

	@IBInspectable public var borderColor: UIColor {
		get {
			return UIColor(CGColor: layer.borderColor ?? UIColor.clearColor().CGColor) ?? UIColor.clearColor()
		}
		set {
			layer.borderColor = newValue.CGColor
		}
	}

	@IBInspectable public var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}

	@IBInspectable public var clipsToBounds_: Bool {
		get {
			return clipsToBounds
		}
		set {
			clipsToBounds = newValue
		}
	}

	@IBInspectable public var masksToBounds_: Bool {
		get {
			return layer.masksToBounds
		}
		set {
			layer.masksToBounds = newValue
		}
	}

}

