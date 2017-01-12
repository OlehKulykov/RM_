//
//  UIAlertController+ShowMessage.swift
//  RM_
//
//  Created by Oleh Kulykov on 09/06/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import UIKit


extension UIAlertController {

	static func show(title: String, message: String? = nil) {
		guard let controller = RM_AppDelegate.shared.window?.rootViewController else {
			print("Alert: \(title), message: \(message ?? "")")
			return
		}

		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: RM_LocalizationKey.OK.localized, style: .cancel, handler: nil))

		controller.present(alert, animated: true, completion: nil)
	}
	
}

