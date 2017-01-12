//
//  RM_CoreDataStack.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation
import CoreData


/**
CoreData stack holds CoreData properties and provide basic operations with managed objects.
*/
open class RM_CoreDataStack {


	//MARK: Public functionality of the stack type RM_CoreDataStackType.

	/**
	Returns managed object context concurrency type for the created instance of the Core Data Stack.
	Available `MainQueueConcurrencyType` and `PrivateQueueConcurrencyType`.
	*/
	open var concurrencyType: NSManagedObjectContextConcurrencyType {
		return managedObjectContext.concurrencyType
	}


	/**
	Creates, configures, inserts and returns an instance with a given managed object/entity name.

	It's recommended to use object/entity name same as presentation class without any suffixes and prefixes.
	
	- Parameter name: Name of the managed object/entity that should be created, configured and inserted.
	
	- Returns: New instance of the managed object/entity, ready for use, modify, fill with data, etc.
	*/
	open func createNewObject(objectName name: String) -> NSManagedObject {
		return NSEntityDescription.insertNewObject(forEntityName: name, into: managedObjectContext)
	}


	/**
	Find all objects with a given object/entity name and optional predicate.

	To find all objects/entities by name just provide predicate as nil, e.g. ignore.

	- Note: It's recommended to use object/entity name same as presentation class without any suffixes and prefixes.

	- Parameter name: The name of the managed objects/entities for locating.
	
	- Parameter predicate: Optional search predicate, can be nil if you want to get all objects/entities by name.
	
	- Returns: Array with located objects/entities or empty array.
	*/
	open func findObjects(objectName name: String, withPredicate predicate: NSPredicate?) -> [NSManagedObject] {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
		fetchRequest.returnsObjectsAsFaults = false
		fetchRequest.predicate = predicate

		guard let results = try? managedObjectContext.fetch(fetchRequest) else {
			return []
		}

		return results.map { $0 as! NSManagedObject }
	}


	/**
	Delete managed object/entity.

	Context is not saved after successful operation.

	- Parameter object: managed object/entity that should be deleted.
	*/
	open func deleteObject(_ object: NSManagedObject) {
		managedObjectContext.delete(object)
	}


	/**
	Delete all objects/entities with a given name.

	It's recommended to use object/entity name same as presentation class without any suffixes and prefixes.
	
	- Parameter name: Name of the managed object/entity to delete.

	- Warning: Context is not saved after successful operation.
	*/
	open func deleteObjects(objectsName name: String) {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
		fetchRequest.includesPropertyValues = false

		guard let objects = try? managedObjectContext.fetch(fetchRequest) else {
			return
		}

		for object in objects {
			managedObjectContext.delete(object as! NSManagedObject)
		}
	}


	/**
	Commit unsaved changes to the context.
	
	- Returns: nil on success or error object which describes error during operation.
	*/
	open func save() -> Error? {
		if managedObjectContext.hasChanges {
			do {
				try managedObjectContext.save()
			} catch let error {
				return error
			}
		}
		return nil
	}


	//MARK: Public singletons and static variables.

	/**
	Shared main thread Core Data Stack type.
	The context creates and manages a main queue with concurrency `MainQueueConcurrencyType`.
	*/
	open static var sharedDataStack: RM_CoreDataStack = {
		return RM_CoreDataStack()
	}()


	/**
	Shared background thread Core Data Stack type.
	The context creates and manages a background queue with concurrency: `PrivateQueueConcurrencyType`.
	*/
	open static var sharedBackgroundDataStack: RM_CoreDataStack = {
		return RM_CoreDataStack(concurrency: .privateQueueConcurrencyType)
	}()


	/**
	This code uses a directory in the application's documents _Application Support_ directory.
	
	This directory have write permissions for this application.
	The `.path` property of this URL can be used as a string path.
	
	- Returns: The directory which can be used to store the Core Data file or any other application files.
	*/
	open static var documentsDirectory: URL = {
		let fileManager = FileManager()
		for url in fileManager.urls(for: .documentDirectory, in: .userDomainMask) {
            
			// this value is suitable for input into methods of NSFileManager
            //TODO: ...
//			if let urlPath = url.path {
//				if fileManager.isWritableFile(atPath: urlPath) { // check for existance and write permission
//					return url
//				}
//			}

			do {
				try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: [:])
			} catch {
				continue // check next url
			}

			return url
		}
		fatalError("Can't get, create and store user documents directory which should be available to be used with Core Data")
	}()


	/**
	The model resource name.

	Resource with this name plus `momd` extension should be present in a main bundle.
	Assign this name before using Core Data stuff.
	Also with this name will be created `SQLite` persistent coordinator in a `documentsDirectory` and
	full path will be: `documentsDirectory/managedObjectModelResourceName.sqlite`
	
	- Note: You could find in a project tree your data model, like `NAME.xcdatamodeld` where `NAME` part should be used here.
	*/
	open static var managedObjectModelResourceName: String {
		return "RM_"
	}


	//MARK: Private implementation.

	/// Hold Core Data managed object context.
	fileprivate var managedObjectContext: NSManagedObjectContext


	/// Initialize Core Data Stack with concurrency type.
	/// - Parameter concurrency: The concurrency pattern with which you will use created and stored managed object context.
	/// Available `MainQueueConcurrencyType` and `PrivateQueueConcurrencyType`.
	fileprivate init(concurrency: NSManagedObjectContextConcurrencyType) {
		let objectContext = NSManagedObjectContext(concurrencyType: concurrency)
		objectContext.persistentStoreCoordinator = RM_CoreDataStack.SQLitePersistentStoreCoordinator
		self.managedObjectContext = objectContext

		// Add managed object context observer to receive completes a save operation notification.
		// Need to merge changes in a main thread.
		NotificationCenter.default.addObserver(self,
		                                                 selector: #selector(RM_CoreDataStack.contextDidSave(_:)),
		                                                 name: NSNotification.Name.NSManagedObjectContextDidSave,
		                                                 object: objectContext)
	}


	/// Posted whenever a managed object context completes a save operation.
	/// - Note: Need to synchronous merge changes within main thread.
	@objc func contextDidSave(_ notification: Notification) {
		if Thread.isMainThread {
			managedObjectContext.mergeChanges(fromContextDidSave: notification)
		} else {
			DispatchQueue.main.sync { [weak self] in
				self?.managedObjectContext.mergeChanges(fromContextDidSave: notification)
			}
		}
	}

	/// Default initializer of the Core Data Stack with main queue concurrency.
	convenience fileprivate init() {
		self.init(concurrency: .mainQueueConcurrencyType)
	}

	/// Deinitialize and remove observer.
	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	//MARK: Private static lazy variables.

	/// Holds managed object model for the application.
	/// It is a fatal error for the application not to be able to find and load it's model.
	fileprivate static var managedObjectModel: NSManagedObjectModel = {
		guard let
			modelURL = Bundle.main.url(forResource: managedObjectModelResourceName, withExtension: "momd"),
			let model = NSManagedObjectModel(contentsOf: modelURL)
			else {
				fatalError("Can't get and load application \(managedObjectModelResourceName). Check name and existanse.")
		}
		return model
	}()


	/// Holds `SQLite` persistent store coordinator for the application.
	/// Can be nil if initialization operation can't be done.
	/// This implementation creates a `SQLite` coordinator.
	/// This is optional since there are legitimate error conditions that could cause the creation of the store to fail.
	fileprivate static var SQLitePersistentStoreCoordinator: NSPersistentStoreCoordinator? = {
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: RM_CoreDataStack.managedObjectModel)
		let url = RM_CoreDataStack.documentsDirectory.appendingPathComponent("\(managedObjectModelResourceName).sqlite")
		do {
			try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
		} catch {
			return nil // optional
		}
		return coordinator
	}()
	
}
