//
//  RM_JSONElementTests.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import XCTest
@testable import RM_

class RM_JSONElementTests: XCTestCase {

	var json: RM_JSONElement!

	override func setUp() {
		super.setUp()

		guard let json = jsonElement("api_public_products_GET") else {
			XCTFail("Can't initialize JSON from file data.")
			return
		}
		self.json = json
	}

	func  testSimple() {
		let JSONString = "{\"data\":[{\"description\":\"Some text\",\"price\":148.85,\"quantity\":2}]}"
		let JSONData = NSData(bytes: JSONString.cStringUsingEncoding(NSUTF8StringEncoding)!, length: JSONString.characters.count)
		guard let json = RM_JSONElement(data: JSONData) else {
			XCTFail("Can't initialize JSON from data object.")
			return
		}

		guard let
			datas = json["data"].array,
			data = datas.first
		else {
			XCTFail("JSON format is broken.")
			return
		}

		XCTAssertNotNil(data["description"].string, "Can't find string for key.")
		XCTAssertTrue(data["description"].string == "Some text", "Wrong string value.")

		XCTAssertTrue(data["price"].integer == 148, "Integer is not as expected.")
		XCTAssertTrue(data["price"].decimal == NSDecimalNumber(string: "148.85"), "Decimals not as expected.")
		XCTAssertTrue(data["quantity"].integer == 2, "Integer value not as expected")
		XCTAssertTrue(data["quantity"].decimal == NSDecimalNumber(string: "2"), "Small decimals not as expected.")
	}

	func testReadElements() {
		XCTAssertNotNil(json["status"].string, "Can't find string for key.")
		XCTAssertTrue(json["status"].string == "ok", "Located string is not as expected.")

		XCTAssertNotNil(json["data"].array, "Can't find array element.")
		XCTAssertTrue(json["data"].array?.count == 1, "Located array has wrong count.")

		guard let
			datas = json["data"].array,
			data = datas.first
		else {
			XCTFail("Can't find data section")
			return
		}

		XCTAssertTrue(data["_id"].string == "56baf9d2bb375c3477176bd9")
		XCTAssertTrue(data["price"].integer == 148, "Integer is not as expected")
		XCTAssertTrue(data["price"].decimal == NSDecimalNumber(string: "148.85"), "Decimals not as expected.")
		XCTAssertTrue(data["surcharge"].integer == 0)
		XCTAssertTrue(data["surcharge"].decimal == NSDecimalNumber(string: "0.1"), "Small decimals not as expected.")
		XCTAssertFalse(data["auditing"]["deleted"].bool!, "Boolean value can't be detected.")
		XCTAssertTrue(data["auditing"]["canbedeleted"].bool!, "Wrong boolean value.")
	}

}
