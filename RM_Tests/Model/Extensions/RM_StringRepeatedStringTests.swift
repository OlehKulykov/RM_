//
//  RM_StringRepeatedStringTests.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import XCTest
@testable import RM_

class RM_StringRepeatedStringTests: XCTestCase {

	func testNonEmpty() {
		XCTAssertEqual(String(count: 1, repeatedValue: "a"), "a", "Not equal to expected string")
		XCTAssertEqual(String(count: 1, repeatedValue: "ab"), "ab", "Not equal to expected string")
		XCTAssertEqual(String(count: 2, repeatedValue: "ab"), "abab", "Not equal to expected string")
		XCTAssertEqual(String(count: 2, repeatedValue: "abc"), "abcabc", "Not equal to expected string")
	}

	func testEmpty() {
		XCTAssertEqual(String(count: Int.min, repeatedValue: "a"), "", "Not equal to empty string")
		XCTAssertEqual(String(count: -1, repeatedValue: "a"), "", "Not equal to empty string")
		XCTAssertEqual(String(count: 0, repeatedValue: "a"), "", "Not equal to empty string")
		XCTAssertEqual(String(count: -2, repeatedValue: ""), "", "Not equal to empty string")
		XCTAssertEqual(String(count: 0, repeatedValue: ""), "", "Not equal to empty string")
		XCTAssertEqual(String(count: 1, repeatedValue: ""), "", "Not equal to empty string")
		XCTAssertEqual(String(count: 1, repeatedValue: ""), "", "Not equal to empty string")
		XCTAssertEqual(String(count: 234, repeatedValue: ""), "", "Not equal to empty string")
	}

}
