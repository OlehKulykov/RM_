//
//  RM_NetworkIndicator.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import Foundation
import UIKit

class RM_NetworkIndicator {

	private static var visibility: Int = 0 {
		didSet {
			UIApplication.sharedApplication().networkActivityIndicatorVisible = visibility > 0
		}
	}

	static var visible: Bool {
		get {
			return visibility > 0
		}
		set {
			let increment = newValue ? 1 : -1
			if NSThread.isMainThread() {
				visibility = max(visibility + increment, 0)
			} else {
				dispatch_async(dispatch_get_main_queue(), {
					visibility = max(visibility + increment, 0)
				})
			}
		}
	}
}
