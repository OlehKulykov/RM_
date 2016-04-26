//
//  RM_DALs.swift
//  RM_
//
//  Created by Oleh Kulykov on 26/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import Foundation
import CoreData


// Final DAL's implementation. Containes common internal part and type specific functionality
// to support public DAL's protocols.


/**
Read only, immutable DAL.


All DAL's operates with entities, thats why this DAL type use internal entity type for identify,
manage objects and next provide/cast to it's public type.

For instance: data model have user entity as `RM_User` and there is user type public protocol `RM_UserType`,
with the public getters, vars and functions.
And, `InternalType` will be `RM_User` and `PublicType` is `RM_UserType`.

- Note: Following OOP encapsulation, all internal functionality use `InternalType` and the result
provided as `PublicType` protocol. 
To extend public information you need to update `RM_UserType` protocol.

Example: Locate and edit entity.

```swift
	// Create readonly/immutable DAL for the "RM_User" entity.
	// Each data model object inherits it's public protocol, like "RM_UserType", and have
	// typealias with this public protocol.
	let dal: RM_DAL<RM_User> = RM_DAL.create()

	// Get readonly/immutable "RM_UserType"
	let user = dal.findUserById(userId)

	// Print "RM_UserType" public name.
	// Variable name defined in "RM_UserType" protocol as: "var name: String { get }"
	print("User name: \(user.name)")
```
*/
final class RM_DAL<Entity: RM_EntityType>: RM_ReadableDAL<Entity, Entity.PublicType>, RM_DALType {

	/// Define internal entity type as it presented in data model.
	typealias InternalType = Entity

	/// Define public/read only entity type, e.g. result entity type. 
	/// - Note: Each entity should have public protocol
	typealias PublicType = Entity.PublicType


	//MARK: Private DAL vars, functionality

	/// Initialize instance and store Core Data Stack.
	override private init(dataStack: RM_CoreDataStack) {
		super.init(dataStack: dataStack)
	}

	//MARK: Public, readonly/immutable DAL functionality

	/**
	Creates immutable/readonly data layer, e.g. DAL, instance which operates main thread Core Data Stack.
	
	- Note: This types of DAL's should be used for iteraction with UI.
	
	- Returns: Main thread readonly/immutable DAL.
	*/
	static func create() -> RM_DAL {
		return RM_DAL(dataStack: RM_CoreDataStack.sharedDataStack)
	}


	/**
	Creates immutable/readonly data layer, e.g. DAL, instance which operates background queue Core Data Stack.
	
	- Note: This types of DAL's could be used within non-main threads,
	for instance in a API processing block or any background update logic, etc.
	
	- Returns: Background queue readonly/immutable DAL.
	*/
	static func createBackgrounded() -> RM_DAL {
		return RM_DAL(dataStack: RM_CoreDataStack.sharedBackgroundDataStack)
	}

}


/**
Mutable DAL type. 

This type of the DAL's inherits all readable/immutable functionality
and extends with editing functionality.
The main difference is that, the `PublicType` is same as `InternalType` type.
Let's say, mutable DAL's operates with entity original type, like `RM_User` ( **NOT** public `RM_UserType` protocol ) and
inherited read functionality will return actual `InternalType` type of the entities.

With mutable DAL's you could modify CoreData entity properties, relationships, etc.

- Note: 
	* Use this DAL type for update/modify mada model.
	* All mutable methods doesn't save changes, thats why developer should call `save()` manualy after all operations/modifications are done.
	* This functionality should be provided with `InternalType` for both `InternalType` and `PublicType` types.

Example: Create and edit new user.

```swift
	// Create mutable DAL for the "RM_User" entity.
	let dal: RM_MutableDAL<RM_User> = RM_MutableDAL.create()

	// Get mutable "RM_User"
	let user = dal.findUserById(userId)

	// Edit "RM_User" internal "name" variable. "RM_User" have data model variable, defined as as: "@NSManaged var name: String"
	user.name = "Some user name"
```
*/
final class RM_MutableDAL<Entity: RM_EntityType>: RM_WritableDAL<Entity, Entity>, RM_MutableDALType {

	/// Define internal entity type as it presented in data model.
	typealias InternalType = Entity

	/// Define public entity type as internal type to have possibility to edit entities.
	typealias PublicType = Entity


	//MARK: Private DAL vars, functionality

	/// Initialize instance and store Core Data Stack.
	override private init(dataStack: RM_CoreDataStack) {
		super.init(dataStack: dataStack)
	}

	//MARK: Public, mutable DAL functionality

	/**
	Creates mutable layer, e.g. DAL, instance which operates main thread Core Data Stack.
	
	- Returns: Main thread mutable DAL.
	*/
	static func create() -> RM_MutableDAL {
		return RM_MutableDAL(dataStack: RM_CoreDataStack.sharedDataStack)
	}


	/**
	Creates immutable/readonly data layer, e.g. DAL, instance which operates background queue Core Data Stack.
	
	- Note: This types of DAL's could be used within non-main threads,
	for instance in a API processing block or any background update logic, etc.
	
	- Returns: Background queue mutable DAL.
	*/
	static func createBackgrounded() -> RM_MutableDAL {
		return RM_MutableDAL(dataStack: RM_CoreDataStack.sharedBackgroundDataStack)
	}
}
