//
//  String+MD5.swift
//  RM_
//
//  Created by Oleh Kulykov on 09/06/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation

/// MD5 string generation
extension String {

	/**
	Generate MD5 lowercase string from a target.
 
	- Returns: MD5 lowercase string.
	*/
	var md5: String {
		var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
		if let str = cStringUsingEncoding(NSUTF8StringEncoding) {
			CC_MD5(str, CC_LONG(lengthOfBytesUsingEncoding(NSUTF8StringEncoding)), &digest)
		}

		return digest.reduce("") { result, byte in
			result + String(format: "%02x", byte)
		}
	}
}
