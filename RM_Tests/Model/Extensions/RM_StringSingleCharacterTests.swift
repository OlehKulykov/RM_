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

	func testGetNull() {
        let string = ""
		XCTAssertEqual(string[0], String.NULLCharacter, "Wrong null character result")
		XCTAssertEqual(string[-1], String.NULLCharacter, "Wrong null character result")
		XCTAssertEqual(string[1], String.NULLCharacter, "Wrong null character result")
    }

	func testGetCharacter() {
		let string = "01"
		XCTAssertEqual(string[0], "0", "Wrong character")
		XCTAssertEqual(string[1], "1", "Wrong character")
		XCTAssertEqual(string[2], String.NULLCharacter, "Wrong null character result")
		XCTAssertEqual(string[-1], String.NULLCharacter, "Wrong null character result")
	}

	func testSetCharacter() {
		var string = "10"

		string[0] = "0"
		XCTAssertEqual(string, "00", "Wrong update string")

		string[1] = "1"
		XCTAssertEqual(string, "01", "Wrong update string")

		string[-1] = " "
		XCTAssertEqual(string, "01", "String should not be changed")

		string[2] = "2"
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
	}
}
