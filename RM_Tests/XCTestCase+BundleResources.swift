//
//  XCTestCase+BundleResources.swift
//  RM_
//
//  Created by Oleh Kulykov on 23/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import XCTest
@testable import RM_

extension XCTestCase {

	func bundleFileData(fileName: String) -> NSData {
		let bundle = NSBundle(forClass: self.dynamicType)
		XCTAssertNotNil(bundle)

		let path = bundle.pathForResource(fileName, ofType: "")
		XCTAssertNotNil(path)

		let data = NSData(contentsOfFile: path!)
		XCTAssertNotNil(data)

		return data!
	}

	func jsonElement(fileName: String) -> RM_JSONElement? {
		let bundle = NSBundle(forClass: self.dynamicType)
		XCTAssertNotNil(bundle)

		let path = bundle.pathForResource(fileName, ofType: "json")
		XCTAssertNotNil(path)

		let data = NSData(contentsOfFile: path!)
		XCTAssertNotNil(data)

		return RM_JSONElement(data: data!)
	}
	
}
