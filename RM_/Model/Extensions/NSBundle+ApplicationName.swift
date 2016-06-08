//
//  NSBundle+ApplicationName.swift
//  RM_
//
//  Created by Oleh Kulykov on 08/06/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import UIKit
import CoreFoundation

extension NSBundle {

	/**
	Get application name. Check `Info.plist`
	*/
	public var appName: String {
		let bundle = NSBundle.mainBundle()
		for key in ["CFBundleDisplayName", "CFBundleName"] {
			if let name = bundle.objectForInfoDictionaryKey(key) as? String {
				return name
			}
		}
		return ""
	}
}