//
//  RM_DALTests.swift
//  RM_
//
//  Created by Oleh Kulykov on 25/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import XCTest
@testable import RM_

class RM_DALTests: XCTestCase {

	let testUserId = UUID().uuidString
	let testUserName = "Some name"

	override func setUp() {
		super.setUp()

		let dal: RM_MutableDAL<RM_User> = RM_MutableDAL.create()

		// cleanup all
		dal.deleteAll()
		dal.save()

		XCTAssertTrue(dal.findAll().count == 0, "Can't remove all users")

		let user = dal.createEntity()
		user.oId = testUserId
		user.name = testUserName
		dal.save()

		XCTAssertTrue(dal.findAll().count == 1, "Create user entity")
	}

	func testImmutableFindAll() {
		let dal: RM_DAL<RM_User> = RM_DAL.create()
		guard let user = dal.findAll().first else {
			XCTFail("Can't locate test user")
			return
		}

		XCTAssertTrue(user.oId == testUserId, "Test user have broken identifier")
		XCTAssertTrue(user.name == testUserName, "Test user have broken name")
	}

	func testImmutableFindWithPredicate() {
		let dal: RM_DAL<RM_User> = RM_DAL.create()

		let userIdPredicate = NSPredicate(format: "oId == %@", testUserId)
		guard let user1 = dal.findWithPredicate(userIdPredicate).first else {
			XCTFail("Can't find test user with predicate by identifier")
			return
		}

		let userNamePredicate = NSPredicate(format: "name == %@", testUserName)
		guard let user2 = dal.findWithPredicate(userNamePredicate).first else {
			XCTFail("Can't find test user with predicate by name")
			return
		}

		XCTAssertTrue(user1.oId == testUserId, "Test user have broken identifier")
		XCTAssertTrue(user1.name == testUserName, "Test user have broken name")
		XCTAssertTrue(user2.oId == user1.oId, "Test user have broken identifier")
		XCTAssertTrue(user2.name == user1.name, "Test user have broken name")

		var emptyUsers = dal.findWithPredicate(NSPredicate(format: "oId == %@", testUserId + "-"))
		XCTAssertTrue(emptyUsers.count == 0, "Located wrong user(s)")

		emptyUsers = dal.findWithPredicate(NSPredicate(format: "name == %@", testUserName + "-"))
		XCTAssertTrue(emptyUsers.count == 0, "Located wrong user(s)")
	}

	func testMutableFindAll() {
		let dal: RM_MutableDAL<RM_User> = RM_MutableDAL.create()
		guard let user = dal.findAll().first else {
			XCTFail("Can't locate test user")
			return
		}

		XCTAssertTrue(user.oId == testUserId, "Test user have broken identifier")
		XCTAssertTrue(user.name == testUserName, "Test user have broken name")
	}

	func testMutableFindWithPredicate() {
		let dal: RM_MutableDAL<RM_User> = RM_MutableDAL.create()

		let userIdPredicate = NSPredicate(format: "oId == %@", testUserId)
		guard let user1 = dal.findWithPredicate(userIdPredicate).first else {
			XCTFail("Can't find test user with predicate by identifier")
			return
		}

		let userNamePredicate = NSPredicate(format: "name == %@", testUserName)
		guard let user2 = dal.findWithPredicate(userNamePredicate).first else {
			XCTFail("Can't find test user with predicate by name")
			return
		}

		XCTAssertTrue(user1.oId == testUserId, "Test user have broken identifier")
		XCTAssertTrue(user1.name == testUserName, "Test user have broken name")
		XCTAssertTrue(user2.oId == user1.oId, "Test user have broken identifier")
		XCTAssertTrue(user2.name == user1.name, "Test user have broken name")

		var emptyUsers = dal.findWithPredicate(NSPredicate(format: "oId == %@", testUserId + "-"))
		XCTAssertTrue(emptyUsers.count == 0, "Located wrong user(s)")

		emptyUsers = dal.findWithPredicate(NSPredicate(format: "name == %@", testUserName + "-"))
		XCTAssertTrue(emptyUsers.count == 0, "Located wrong user(s)")
	}

}
