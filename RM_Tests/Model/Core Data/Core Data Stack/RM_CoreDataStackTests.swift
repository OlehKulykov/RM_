//
//  RM_CoreDataStackTests.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import XCTest
@testable import RM_

class RM_CoreDataStackTests: XCTestCase {

	func testSharedStacks() {
		let _ = RM_CoreDataStack.sharedDataStack
		let _ = RM_CoreDataStack.sharedBackgroundDataStack
	}

	func testDocumentsDirectory() {
		XCTAssertNotNil(RM_CoreDataStack.documentsDirectory.path, "Documents directory path is empty")
		XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(RM_CoreDataStack.documentsDirectory.path!), "Documents directory doesn't exists.")
		XCTAssertTrue(NSFileManager.defaultManager().isWritableFileAtPath(RM_CoreDataStack.documentsDirectory.path!), "Documents directory not writable.")
	}

}
