//
//  RM_DALTypes.swift
//  RM_
//
//  Created by Oleh Kulykov on 26/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation
import CoreData


// Description of DAL's puclic functionality, e.g. CoreData Data Layer types.
// Available read only and mutable DAL's.


/**
Read only, immutable Data layer type, e.g. DAL functionality.

All DAL's operates with entities, thats why this DAL type use internal entity type for identify,
manage objects and next provide/cast to it's public type.

For instance: data model have user entity as `RM_User` and there is user type public protocol `RM_UserType`,
with the public getters, vars and functions.
And, `InternalType` will be `RM_User` and `PublicType` is `RM_UserType`.

- Note: Following OOP encapsulation, all internal functionality use `InternalType` and the result
provided as `PublicType`.
*/
public protocol RM_DALType {

	/// Placeholder for the internal entity type as it presented in data model.
	associatedtype InternalType


	/// Public/read only entity type, e.g. result entity type. Each entity should have public protocol.
	associatedtype PublicType


	/**
	Locates all `InternalType` type entities which satify optional predicate.
	Without predicate this functionality returns all entities.
	
	- Parameter predicate: Optional predicate/search criterio.
	
	- Returns: Array with `PublicType` entity types followed search criterio/predicate, all available entities without predicate
	or empty array if nothing have beed found.
	*/
	func findWithPredicate(_ predicate: NSPredicate?) -> [PublicType]


	/**
	Locates all available `InternalType` type entities and returns as array of `PublicType`.
	
	- Returns: Array with all available `PublicType` entity types or empty array if no entities exists.
	*/
	func findAll() -> [PublicType]


	/**
	Creates specific data layer, e.g. DAL, instance which operates main thread Core Data Stack.
	This types of DAL's should be used for iteraction with UI.
	
	- Returns: Main thread specific DAL.
	*/
	static func create() -> Self


	/**
	Creates specific data layer, e.g. DAL, instance which operates background queue Core Data Stack.
	This types of DAL's could be used within non-main threads, 
	for instance in a API processing block or any background update logic, etc.
	
	- Returns: Background queue specific DAL.
	*/
	static func createBackgrounded() -> Self
}



/**
Mutable DAL type. 

This type of the DAL's inherits all readable/immutable functionality
and extends with editing functionality.

The main difference is that, the `PublicType` is same as `InternalType` type.
Let's say, mutable DAL's operates with entity original type, like `RM_User` ( **NOT** public `RM_UserType` protocol ) and
inherited read functionality will return actual `InternalType` type of the entities.

With mutable DAL's you could modify CoreData entity properties, relationships, etc.
Use this DAL type for update/modify mada model.

- Note: All mutable methods doesn't save changes, thats why developer should call `save()` manualy after all operations/modifications are done.
*/
public protocol RM_MutableDALType: RM_DALType {

	/**
	Create new entity instance with the `InternalType` type.
	
	- Returns: Newly created entity instance.
	*/
	func createEntity() -> InternalType


	/**
	Delete entity instance.
	*/
	func deleteEntity(_ entity: InternalType)


	/**
	Delete all instances of the `InternalType` type.
	*/
	func deleteAll()


	/**
	Save changes after modifications of the data model, entities, etc.
	*/
	func save()
}
