//
//  RM_StringSingleCharacterTests.swift
//  RM_
//
//  Created by Oleh Kulykov on 09/06/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import XCTest
@testable import RM_

class RM_StringSingleCharacterTests: XCTestCase {

	func testLastCharacter() {
		XCTAssertNil("".lastCharacter, "Wrong nil character result")

		XCTAssertNotNil("0".lastCharacter, "Wrong last character")
		XCTAssertEqual("0".lastCharacter, "0", "Wrong last character")

		XCTAssertNotNil("01".lastCharacter, "Wrong last character")
		XCTAssertEqual("01".lastCharacter, "1", "Wrong last character")
	}

	func testRemoveLastCharacter() {
		var string = "01"
		string.removeLastCharacter()

		XCTAssertEqual(string, "0", "Wrong remove character result")

		string.removeLastCharacter()
		XCTAssertEqual(string, "", "Wrong remove character result")

		string.removeLastCharacter()
		XCTAssertEqual(string, "", "Wrong remove character result")
	}

	func testGetnil() {
        let string = ""
		XCTAssertNil(string[0], "Wrong nil character result")
		XCTAssertNil(string[-1], "Wrong nil character result")
		XCTAssertNil(string[1], "Wrong nil character result")
    }

	func testGetCharacter() {
		let string = "01"
		XCTAssertEqual(string[0], "0", "Wrong character")
		XCTAssertEqual(string[1], "1", "Wrong character")
		XCTAssertNil(string[2], "Wrong nil character result")
		XCTAssertNil(string[-1], "Wrong nil character result")
	}

	func testSetCharacter() {
		var string = "10"

		string[0] = "0"
		XCTAssertEqual(string, "00", "Wrong update string")
		string[0] = nil
		XCTAssertEqual(string, "00", "Wrong update string")

		string[1] = "1"
		XCTAssertEqual(string, "01", "Wrong update string")
		string[1] = nil
		XCTAssertEqual(string, "01", "Wrong update string")

		string[-1] = " "
		XCTAssertEqual(string, "01", "String should not be changed")
		string[-1] = nil
		XCTAssertEqual(string, "01", "String should not be changed")

		string[2] = "2"
		XCTAssertEqual(string, "01", "String should not be changed")
		string[2] = nil
		XCTAssertEqual(string, "01", "String should not be changed")
	}

	func testSetCharacterToEmptyString() {
		var string = ""

		string[0] = "1"
		XCTAssertTrue(string.isEmpty, "String should not be changed")

		string[1] = "1"
		XCTAssertTrue(string.isEmpty, "String should not be changed")

		string[-1] = "1"
		XCTAssertTrue(string.isEmpty, "String should not be changed")

		string[0] = nil
		XCTAssertTrue(string.isEmpty, "String should not be changed")

		string[1] = nil
		XCTAssertTrue(string.isEmpty, "String should not be changed")

		string[-1] = nil
		XCTAssertTrue(string.isEmpty, "String should not be changed")
	}
}
