//
//  RM_StringMD5Tests.swift
//  RM_
//
//  Created by Oleh Kulykov on 09/06/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import XCTest
@testable import RM_

class RM_StringMD5Tests: XCTestCase {

	// http://www.md5.cz

	let predefined = ["": "d41d8cd98f00b204e9800998ecf8427e",
	                  "a": "0cc175b9c0f1b6a831c399e269772661",
	                  "md5": "1bc29b36f623ba82aaf6724fd3b16718",
	                  "Hello world!!!": "87ee732d831690f45b8606b1547bd09e",
	                  "Привет мир": "79d636ccef972a9d10db69750cd53e8b",
	                  "Бобрыдень": "1bfc385445d178a790178c7886fd0ce5",
	                  "Später noch einmal": "ffc4ef8b53bc03dc696a230a43b0a4e5",
	                  "こんにちは": "c0e89a293bd36c7a768e4e9d2c5475a8"
	                  ]

	func testMD5() {
		for (key, value) in predefined {
			let md5 = key.md5
			XCTAssertEqual(md5, value, "String: [\(key)] wrong MD5 result: \(md5)")
		}
	}
}
