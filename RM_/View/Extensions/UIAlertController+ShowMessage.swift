//
//  UIAlertController+ShowMessage.swift
//  RM_
//
//  Created by Oleh Kulykov on 09/06/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import UIKit


extension UIAlertController {

	static func show(title title: String, message: String? = nil) {
		guard let controller = RM_AppDelegate.shared.window?.rootViewController else {
			print("Alert: \(title), message: \(message ?? "")")
			return
		}

		let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)

		alert.addAction(UIAlertAction(title: RM_LocalizationKey.OK.localized, style: .Cancel, handler: nil))

		controller.presentViewController(alert, animated: true, completion: nil)
	}
	
}

