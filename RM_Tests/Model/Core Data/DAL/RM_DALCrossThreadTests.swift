//
//  RM_DALCrossThreadTests.swift
//  RM_
//
//  Created by Oleh Kulykov on 26/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import XCTest
@testable import RM_

class RM_DALCrossThreadTests: XCTestCase {

	func cleanup() {
		let dalMT: RM_MutableDAL<RM_User> = RM_MutableDAL.create()
		dalMT.deleteAll()
		dalMT.save()
		XCTAssertTrue(dalMT.findAll().count == 0, "Can't delete all entities.")
	}

	func testCreateMainReadBackground() {
		cleanup()

		let dalMT: RM_MutableDAL<RM_User> = RM_MutableDAL.create()

		// create entity in a main thread.
		let userMT = dalMT.createEntity()
		let userId = NSUUID().UUIDString
		userMT.oId = userId
		let userName = "Some name"
		userMT.name = userName
		dalMT.save()

		XCTAssertTrue(dalMT.findAll().count == 1, "Can't save new entity.")

		let expectation = self.expectationWithDescription("Read user in background.")
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {

			// read and compare entity from background.
			let dalBT: RM_DAL<RM_User> = RM_DAL.createBackgrounded()
			XCTAssertTrue(dalBT.findAll().count == 1, "Wrong entities count readed in a background.")

			guard let userBT = dalBT.findAll().first else {
				XCTFail("Can't read user in a background.")
				return
			}

			XCTAssertTrue(userBT.oId == userId, "Created and readed user id not same.")
			XCTAssertTrue(userBT.name == userName, "Created and readed user name not same.")

			expectation.fulfill()
		})

		self.waitForExpectationsWithTimeout(10) { error in
			if let error = error {
				XCTFail("Create user in background: \(error)")
			}
		}
	}

	func testCreateBackgroundReadMain() {
		cleanup()

		let expectation = self.expectationWithDescription("Write user in background.")
		let userId = NSUUID().UUIDString
		let userName = "Some name"

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {

			// create and setup enty in a background.
			let dal: RM_MutableDAL<RM_User> = RM_MutableDAL.createBackgrounded()

			let user = dal.createEntity()
			user.oId = userId
			user.name = userName
			dal.save()

			XCTAssertTrue(dal.findAll().count == 1, "Can't save new entity.")
			expectation.fulfill()
		})

		self.waitForExpectationsWithTimeout(10) { error in

			let dal: RM_DAL<RM_User> = RM_DAL.create()

			guard let user = dal.findWithPredicate(NSPredicate(format: "oId == %@", userId)).first else {
				XCTFail("Can't read user in a background.")
				return
			}

			XCTAssertTrue(user.oId == userId, "Created and readed user id not same.")
			XCTAssertTrue(user.name == userName, "Created and readed user name not same.")

			if let error = error {
				XCTFail("Create user in background: \(error)")
			}
		}
	}

}
