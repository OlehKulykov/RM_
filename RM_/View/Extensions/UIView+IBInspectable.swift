//
//  UIView+IBInspectable.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import UIKit

extension UIView {

	@IBInspectable var cornerRadius: CGFloat {
		get {
			return self.layer.cornerRadius
		}
		set {
			self.layer.cornerRadius = newValue
		}
	}

	@IBInspectable var borderColor: UIColor {
		get {
			return UIColor(CGColor: self.layer.borderColor ?? UIColor.clearColor().CGColor) ?? UIColor.clearColor()
		}
		set {
			self.layer.borderColor = newValue.CGColor
		}
	}

	@IBInspectable var borderWidth: CGFloat {
		get {
			return self.layer.borderWidth
		}
		set {
			self.layer.borderWidth = newValue
		}
	}

	@IBInspectable var clipsToBounds_: Bool {
		get {
			return self.clipsToBounds
		}
		set {
			self.clipsToBounds = newValue
		}
	}

	@IBInspectable var masksToBounds_: Bool {
		get {
			return self.layer.masksToBounds
		}
		set {
			self.layer.masksToBounds = newValue
		}
	}

}

