//
//  RM_DAL+User.swift
//  RM_
//
//  Created by Oleh Kulykov on 26/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import Foundation
import CoreData


// Extend standart DAL functionality with `RM_User` specific methods.
// Use top level DAL protocol for the `RM_User` internal type.


extension RM_DALType where InternalType == RM_User {

	/**
	Find user by ID.
	
	- Parameter userId: User's identifier string.
	
	- Returns: User as it's public protocol or nil if no User found with provided identifier.
	*/
	public func findUserById(_ userId: String) -> PublicType? {
		let predicate = NSPredicate(format: "oId == %@", userId)
		let users = findWithPredicate(predicate)
		assert(users.count < 2, "There are few users with same id: \(userId)")
		return users.first
	}
}


extension RM_MutableDALType where InternalType == RM_User {

	/**
	Create user with specific identifier.
	
	- Parameter userId: User's identifier string.
	
	- Returns: User as internal/editable instance with provided identifier.
	*/
	func createUserWithId(_ userId: String) -> InternalType {
		let user = createEntity()
		user.oId = userId
		return user
	}
}
