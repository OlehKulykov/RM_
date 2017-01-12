//
//  RM_FontTests.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import XCTest
@testable import RM_

class RM_FontTests: XCTestCase {

	func testAllFonts() {
		for fontKey in iterateEnum(RM_Font).makeIterator() {
			for fontSize in 5...55 {
				// Should be initialized without any errors and optionals.
				let _ = fontKey.fontWithSize(CGFloat(fontSize))
			}
		}
	}
}
