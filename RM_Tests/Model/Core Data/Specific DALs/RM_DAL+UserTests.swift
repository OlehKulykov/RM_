//
//  RM_DAL+UserTests.swift
//  RM_
//
//  Created by Oleh Kulykov on 26/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import XCTest
@testable import RM_

class RM_DAL_UserTests: XCTestCase {

	let testUserId = UUID().uuidString

	func testCreateAndRead() {
		let mutableDAL: RM_MutableDAL<RM_User> = RM_MutableDAL.create()
		mutableDAL.deleteAll()
		mutableDAL.save()

		// create
		let user1 = mutableDAL.createUserWithId(testUserId)
		XCTAssertTrue(user1.oId == testUserId, "Created user identifier is wrong.")

		user1.name = "name"
		mutableDAL.save()

		// read
		let dal: RM_DAL<RM_User> = RM_DAL.create()
		guard let user2 = dal.findUserById(testUserId) else {
			XCTFail("Cant findUserById")
			return
		}

		XCTAssertTrue(user2.oId == user1.oId, "Created and readed user id not same.")
		XCTAssertTrue(user2.name == user1.name, "Created and readed user name not same.")
	}

}
