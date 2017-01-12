//
//  NSBundle+ApplicationName.swift
//  RM_
//
//  Created by Oleh Kulykov on 08/06/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation


/// Get application name from bundle
extension Bundle {

	/**
	Get application name. Check `Info.plist`
	*/
	public var appName: String {
		let bundle = Bundle.main
		for key in ["CFBundleDisplayName", "CFBundleName"] {
			if let name = bundle.object(forInfoDictionaryKey: key) as? String {
				return name
			}
		}
		return ""
	}
}
