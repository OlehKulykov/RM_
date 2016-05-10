//
//  String+RepeatedString.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import Foundation

extension String {
	
	public init(count: Int, repeatedValue repeated: String) {
		var s = ""
		for _ in 0..<count {
			s += repeated
		}
		self.init(s)
	}
}
