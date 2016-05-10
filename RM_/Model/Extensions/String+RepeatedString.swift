//
//  String+RepeatedString.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import Foundation

extension String {

	/**
	Initialize string with number of repeated string.
	
	- Parameter count: Number of repeated parts count.
	
	- Parameter repeated: Repeated string part.
	
	- Returns: String with the number of repeated parts count or empty string.
	*/
	public init(count: Int, repeatedValue repeated: String) {
		var s = ""
		for _ in 0..<count {
			s += repeated
		}
		self.init(s)
	}
}
