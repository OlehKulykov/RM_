//
//  RM_APIRequestGETJSON.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import XCTest
@testable import RM_

class RM_APIRequestGETJSON: XCTestCase {

	let api = RM_APIRequest<RM_JSONElement>(url: "http://mysafeinfo.com/api/data?list=englishmonarchs&format=json")

	func testGETJSON() {
		XCTAssertNotNil(api.url, "URL should not be nil.")

		let expectation = self.expectationWithDescription("API json result.")

		api.request { result in
			switch result {
			case .Success(let json):
				XCTAssertNotNil(json.array, "Here should be an array.")
				expectation.fulfill()
			case .Failure(let error):
				XCTFail("API error: \(error)")
			}
		}

		self.waitForExpectationsWithTimeout(api.timeout) { error in
			if let error = error {
				XCTFail("API Time out error: \(error)")
			}
		}
	}

}
