//
//  RM_NetworkIndicatorTests.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import XCTest
@testable import RM_

class RM_NetworkIndicatorTests: XCTestCase {

	func toInvisible() {
		for _ in 0...5 {
			RM_NetworkIndicator.visible = false
		}
		XCTAssertFalse(RM_NetworkIndicator.visible, "Should be invisible")
	}

	func testSingle() {
		toInvisible()

		RM_NetworkIndicator.visible = true
		XCTAssertTrue(RM_NetworkIndicator.visible, "Should be visible")

		RM_NetworkIndicator.visible = false
		XCTAssertFalse(RM_NetworkIndicator.visible, "Should be invisible")
	}

	func testMultiple() {
		toInvisible()

		RM_NetworkIndicator.visible = true
		RM_NetworkIndicator.visible = true
		XCTAssertTrue(RM_NetworkIndicator.visible, "Should be visible")

		RM_NetworkIndicator.visible = false
		XCTAssertTrue(RM_NetworkIndicator.visible, "Should be visible")
		RM_NetworkIndicator.visible = false
		XCTAssertFalse(RM_NetworkIndicator.visible, "Should be invisible")
	}

	func testMultipleMultiThreaded() {
		toInvisible()

		RM_NetworkIndicator.visible = true
		XCTAssertTrue(RM_NetworkIndicator.visible, "Should be visible")

		let expectation = self.expectationWithDescription("Dummy timeout.")

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
			NSThread.sleepForTimeInterval(0.4)
			RM_NetworkIndicator.visible = true
			XCTAssertTrue(RM_NetworkIndicator.visible, "Should be visible")
		}

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
			NSThread.sleepForTimeInterval(0.8)
			RM_NetworkIndicator.visible = false
			XCTAssertTrue(RM_NetworkIndicator.visible, "Should be visible")
		}

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
			NSThread.sleepForTimeInterval(1.2)
			RM_NetworkIndicator.visible = false
			XCTAssertFalse(RM_NetworkIndicator.visible, "Should be invisible")
			expectation.fulfill()
		}

		self.waitForExpectationsWithTimeout(10) { error in
			XCTAssertFalse(RM_NetworkIndicator.visible, "Should be invisible")
			if let error = error {
				XCTFail("Create user in background: \(error)")
			}
		}
	}
}
