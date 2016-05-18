//
//  RM_DALInternals.swift
//  RM_
//
//  Created by Oleh Kulykov on 26/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import Foundation
import CoreData


// Internal implementation of DAL's common functionality described via DAL's protocols.


/**
Generic implementation of the immutable/readonly DAL common functionality.

* `InternalType` - is the class type of the entity presented in a data model, like `RM_User`.
* `PublicType` - public protocol of the `InternalType`, like `RM_UserType`.

- Warning: For internal purpose only. Use `RM_DAL` instead.
*/
public class RM_ReadableDAL<InternalType, PublicType> {

	//MARK: Private DAL vars, functionality

	/// private Core Data Stack instance.
	private let dataStack: RM_CoreDataStack

	/// Initialize instance and store Core Data Stack.
	internal init(dataStack: RM_CoreDataStack) {
		self.dataStack = dataStack
	}

	//MARK: Public DAL functionality

	/**
	Locates all `InternalType` type entities which satify optional predicate.
	Without predicate this functionality returns all entities.

	- Parameter predicate: Optional predicate/search criterio.
	
	- Returns: Array with `PublicType` entity types followed search criterio/predicate, all available entities without predicate
	or empty array if nothing have beed found.
	*/
	public func findWithPredicate(predicate: NSPredicate?) -> [PublicType] {
		let entities = dataStack.findObjects(objectName: "\(InternalType.self)", withPredicate: predicate)
		return entities.map { $0 as! PublicType }
	}


	/**
	Locates all available `InternalType` type entities and returns as array of `PublicType`.

	- Returns: Array with all available `PublicType` entity types or empty array if no entities exists.
	*/
	public func findAll() -> [PublicType] {
		return dataStack.findObjects(objectName: "\(InternalType.self)", withPredicate: nil).map { $0 as! PublicType }
	}

}



/**
Generic implementation of the mutable DAL common functionality.
Inherits all readable/immutable functionality and extends with editing functionality.

- Note: This functionality should be provided with `InternalType` for both `InternalType` and `PublicType` types.

- Warning: For internal purpose only. Use `RM_MutableDAL` instead.
*/
public class RM_WritableDAL<InternalType, PublicType>: RM_ReadableDAL<InternalType, PublicType> {

	//MARK: Private DAL vars, functionality

	/// Initialize instance and store Core Data Stack to base.
	override internal init(dataStack: RM_CoreDataStack) {
		super.init(dataStack: dataStack)
	}


	//MARK: Public DAL functionality

	/**
	Create new entity instance with the `InternalType` type.
	
	- Returns: Newly created entity instance.
	*/
	public func createEntity() -> PublicType {
		return dataStack.createNewObject(objectName: "\(InternalType.self)") as! PublicType
	}


	/**
	Delete entity instance.
	*/
	public func deleteEntity(entity: PublicType) {
		dataStack.deleteObject(entity as! NSManagedObject)
	}


	/**
	Delete all instances of the `InternalType` type.
	*/
	public func deleteAll() {
		dataStack.deleteObjects(objectsName: "\(InternalType.self)")
	}


	/**
	Save changes after modifications of the data model, entities, etc.
	*/
	public func save() {
		dataStack.save()
	}
}
