//
//  RM_UIImage_ColorizedCreationTests.swift
//  RM_
//
//  Created by Oleh Kulykov on 25/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import XCTest
@testable import RM_


class RM_UIImage_ColorizedCreationTests: XCTestCase {

	func testCreation() {
		let image = UIImage(color: UIColor.redColor())
		XCTAssertTrue(image.size == CGSize(width: 1, height: 1), "Created image size [\(image.size)] doesn't conform expected size [1; 1]")
		XCTAssertTrue(image.imageOrientation == UIImageOrientation.Up, "Created image have unexpected orientation \(image.imageOrientation)")
	}

    func testSizedCreation() {

		let sizes = [
			CGSize(width: 0, height: 0),
			CGSize(width: -1, height: 0),
			CGSize(width: 0, height: -1),
			CGSize(width: -2, height: -444),
			CGSize(width: 2, height: 2),
			CGSize(width: 2, height: 4),
			CGSize(width: 3, height: 3),
			CGSize(width: 3, height: 5),
		]

		for size in sizes {
			let expectedSize = CGSizeMake(max(1, size.width), max(1, size.height))

			let image = UIImage(color: UIColor.redColor(), size: size)

			XCTAssertTrue(image.size == expectedSize, "Created image size [\(image.size)] doesn't conform expected size \(expectedSize)")
			XCTAssertTrue(image.imageOrientation == UIImageOrientation.Up, "Created image have unexpected orientation \(image.imageOrientation)")
		}

    }

}
