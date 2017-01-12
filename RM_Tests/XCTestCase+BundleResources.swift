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

	func bundleFileData(_ fileName: String) -> Data {
		let bundle = Bundle(for: type(of: self))
		XCTAssertNotNil(bundle)

		let path = bundle.path(forResource: fileName, ofType: "")
		XCTAssertNotNil(path)

		let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
		XCTAssertNotNil(data)

		return data!
	}

	func jsonElement(_ fileName: String) -> RM_JSONElement? {
		let bundle = Bundle(for: type(of: self))
		XCTAssertNotNil(bundle)

		let path = bundle.path(forResource: fileName, ofType: "json")
		XCTAssertNotNil(path)

		let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
		XCTAssertNotNil(data)

		return RM_JSONElement(data: data!)
	}
	
}
