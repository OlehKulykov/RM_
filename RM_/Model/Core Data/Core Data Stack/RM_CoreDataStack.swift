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
class RM_CoreDataStack {


	//MARK: Public functionality of the stack type RM_CoreDataStackType.

	/**
	Returns managed object context concurrency type for the created instance of the Core Data Stack.
	Available `MainQueueConcurrencyType` and `PrivateQueueConcurrencyType`.
	*/
	var concurrencyType: NSManagedObjectContextConcurrencyType {
		return managedObjectContext.concurrencyType
	}


	/**
	Creates, configures, inserts and returns an instance with a given managed object/entity name.

	It's recommended to use object/entity name same as presentation class without any suffixes and prefixes.
	
	- Parameter name: Name of the managed object/entity that should be created, configured and inserted.
	
	- Returns: New instance of the managed object/entity, ready for use, modify, fill with data, etc.
	*/
	func createNewObject(objectName name: String) -> NSManagedObject {
		return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: managedObjectContext)
	}


	/**
	Find all objects with a given object/entity name and optional predicate.

	To find all objects/entities by name just provide predicate as nil, e.g. ignore.

	- Note: It's recommended to use object/entity name same as presentation class without any suffixes and prefixes.
	
	- Parameters:
		- name: Name of the managed objects/entities for locating.
	
		- predicate: optional search predicate, can be nil if you want to get all objects/entities by name.
	
	- Returns: Array with located objects/entities or empty array.
	*/
	func findObjects(objectName name: String, withPredicate predicate: NSPredicate?) -> [NSManagedObject] {
		let fetchRequest = NSFetchRequest(entityName: name)
		fetchRequest.returnsObjectsAsFaults = false
		fetchRequest.predicate = predicate

		guard let results = try? managedObjectContext.executeFetchRequest(fetchRequest) else {
			return []
		}

		return results.map { $0 as! NSManagedObject }
	}


	/**
	Delete managed object/entity.

	Context is not saved after successful operation.

	- Parameter object: managed object/entity that should be deleted.
	*/
	func deleteObject(object: NSManagedObject) {
		managedObjectContext.deleteObject(object)
	}


	/**
	Delete all objects/entities with a given name.

	It's recommended to use object/entity name same as presentation class without any suffixes and prefixes.
	
	- Parameter name: Name of the managed object/entity to delete.

	- Warning: Context is not saved after successful operation.
	*/
	func deleteObjects(objectsName name: String) {
		let fetchRequest = NSFetchRequest(entityName: name)
		fetchRequest.includesPropertyValues = false

		guard let objects = try? managedObjectContext.executeFetchRequest(fetchRequest) else {
			return
		}

		for object in objects {
			managedObjectContext.deleteObject(object as! NSManagedObject)
		}
	}


	/**
	Commit unsaved changes to the context.
	
	- Returns: nil on success or error object which describes error during operation.
	*/
	func save() -> NSError? {
		if managedObjectContext.hasChanges {
			do {
				try managedObjectContext.save()
			} catch let error as NSError {
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
	static var sharedDataStack: RM_CoreDataStack = {
		return RM_CoreDataStack()
	}()


	/**
	Shared background thread Core Data Stack type.
	The context creates and manages a background queue with concurrency: `PrivateQueueConcurrencyType`.
	*/
	static var sharedBackgroundDataStack: RM_CoreDataStack = {
		return RM_CoreDataStack(concurrency: .PrivateQueueConcurrencyType)
	}()


	/**
	This code uses a directory in the application's documents _Application Support_ directory.
	
	This directory have write permissions for this application.
	The `.path` property of this URL can be used as a string path.
	
	- Returns: The directory which cen be used to store the Core Data file or any other application files.
	*/
	static var documentsDirectory: NSURL = {
		let fileManager = NSFileManager()
		for url in fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) {

			// this value is suitable for input into methods of NSFileManager
			if let urlPath = url.path {
				if fileManager.isWritableFileAtPath(urlPath) { // check for existance and write permission
					return url
				}
			}

			do {
				try fileManager.createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: [:])
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
	static var managedObjectModelResourceName: String {
		return "RM_"
	}


	//MARK: Private implementation.

	/// Hold Core Data managed object context.
	private var managedObjectContext: NSManagedObjectContext


	/// Initialize Core Data Stack with concurrency type.
	/// - Parameter concurrency: The concurrency pattern with which you will use created and stored managed object context.
	/// Available `MainQueueConcurrencyType` and `PrivateQueueConcurrencyType`.
	private init(concurrency: NSManagedObjectContextConcurrencyType) {
		let objectContext = NSManagedObjectContext(concurrencyType: concurrency)
		objectContext.persistentStoreCoordinator = RM_CoreDataStack.SQLitePersistentStoreCoordinator
		self.managedObjectContext = objectContext

		// Add managed object context observer to receive completes a save operation notification.
		// Need to merge changes in a main thread.
		NSNotificationCenter.defaultCenter().addObserver(self,
		                                                 selector: #selector(RM_CoreDataStack.contextDidSave(_:)),
		                                                 name: NSManagedObjectContextDidSaveNotification,
		                                                 object: objectContext)
	}


	/// Posted whenever a managed object context completes a save operation.
	/// - Note: Need to synchronous merge changes within main thread.
	@objc func contextDidSave(notification: NSNotification) {
		if NSThread.isMainThread() {
			managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
		} else {
			dispatch_sync(dispatch_get_main_queue(), { [weak self] in
				self?.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
			})
		}
	}

	/// Default initializer of the Core Data Stack with main queue concurrency.
	convenience private init() {
		self.init(concurrency: .MainQueueConcurrencyType)
	}

	/// Deinitialize and remove observer.
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	//MARK: Private static lazy variables.

	/// Holds managed object model for the application.
	/// It is a fatal error for the application not to be able to find and load it's model.
	private static var managedObjectModel: NSManagedObjectModel = {
		guard let
			modelURL = NSBundle.mainBundle().URLForResource(managedObjectModelResourceName, withExtension: "momd"),
			model = NSManagedObjectModel(contentsOfURL: modelURL)
			else {
				fatalError("Can't get and load application \(managedObjectModelResourceName). Check name and existanse.")
		}
		return model
	}()


	/// Holds `SQLite` persistent store coordinator for the application.
	/// Can be nil if initialization operation can't be done.
	/// This implementation creates a `SQLite` coordinator.
	/// This is optional since there are legitimate error conditions that could cause the creation of the store to fail.
	private static var SQLitePersistentStoreCoordinator: NSPersistentStoreCoordinator? = {
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: RM_CoreDataStack.managedObjectModel)
		let url = RM_CoreDataStack.documentsDirectory.URLByAppendingPathComponent("\(managedObjectModelResourceName).sqlite")
		do {
			try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
		} catch {
			return nil // optional
		}
		return coordinator
	}()
	
}
