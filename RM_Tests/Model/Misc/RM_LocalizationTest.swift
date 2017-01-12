//
//  RM_LocalizationTest.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import XCTest
@testable import RM_

extension XCTestCase {

	func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
		var i = 0
		return AnyIterator {
			let next = withUnsafePointer(to: &i) { UnsafeRawPointer($0).load(as: T.self) }
			let result: T? = next.hashValue == i ? next : nil
			i += 1
			return result
		}
	}
}


class RM_LocalizationTest: XCTestCase {

    func testAllLocalized() {
		for key in iterateEnum(RM_LocalizationKey).makeIterator() {
			let rawKey = key.rawValue
			let localized = key.localized
			XCTAssert(rawKey != localized, "RM_LocalizationKey.\(key) is not localized.")
		}
    }

}
