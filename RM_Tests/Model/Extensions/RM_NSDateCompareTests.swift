//
//  RM_NSDateCompareTests.swift
//  RM_
//
//  Created by Oleh Kulykov on 09/06/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import XCTest
@testable import RM_

class RM_NSDateCompareTests: XCTestCase {

    /*
	func testCompare() {
		let now = Date()
		let next = now.addingTimeInterval(1)

		XCTAssertTrue(now == now)
		XCTAssertFalse(now != now)
		XCTAssertTrue(now != next)

		XCTAssertTrue(now < next)
		XCTAssertTrue(now <= next)
		XCTAssertFalse(now > next)
		XCTAssertFalse(now >= next)

		XCTAssertTrue(next > now)
		XCTAssertTrue(next >= now)
		XCTAssertFalse(next < now)
		XCTAssertFalse(next <= now)
	}

	func testMin() {
		let now = Date()
		let next = now.addingTimeInterval(1)
		let prev = now.addingTimeInterval(-1)

		var minimum = min(next, now)
		XCTAssertTrue(minimum == now)

		minimum = min(now)
		XCTAssertTrue(minimum == now)

		minimum = min(now, next)
		XCTAssertTrue(minimum == now)

		minimum = min(now, next, now.addingTimeInterval(2))
		XCTAssertTrue(minimum == now)

		minimum = min(now, next, now.addingTimeInterval(2), now.addingTimeInterval(-2))
		XCTAssertTrue(minimum == now.addingTimeInterval(-2))

		minimum = min(now, now)
		XCTAssertTrue(minimum == now)

		minimum = min(now, prev)
		XCTAssertTrue(minimum == prev)
	}

	func testMax() {
		let now = Date()
		let next = now.addingTimeInterval(1)

		var maximim = max(next, now)
		XCTAssertTrue(maximim == next)

		maximim = max(now)
		XCTAssertTrue(maximim == now)

		maximim = max(now, next)
		XCTAssertTrue(maximim == next)

		maximim = max(now, next, now.addingTimeInterval(2))
		XCTAssertTrue(maximim == now.addingTimeInterval(2))

		maximim = max(now, now)
		XCTAssertTrue(maximim == now)
	}
 */
}
