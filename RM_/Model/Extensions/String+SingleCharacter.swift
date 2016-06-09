//
//  String+SingleCharacter.swift
//  RM_
//
//  Created by Oleh Kulykov on 09/06/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation


/// Single character modifications
extension String {

	/**
	Remove last string character if posible.
	If no characters available than do nothing.
	*/
	public mutating func removeLastCharacter() {
		if characters.count > 0 {
			removeAtIndex(endIndex.predecessor())
		}
	}


	/**
	Get last string character if posible.
	
	- Returns: Last character or nil
	*/
	public var lastCharacter: Character? {
		return characters.count > 0 ? self[endIndex.predecessor()] : nil
	}


	/**
	Get/set string character at index.
	
	- Parameter index: The character index to get or set. 
	If `index` out of bounds than do nothing or get nil.

	- Returns: String character or nil.
	*/
	public subscript(index: Int) -> Character? {
		get {
			return (index >= 0 && index < characters.count) ? self[startIndex.advancedBy(index)] : nil
		}
		set {
			if let character = newValue where index >= 0 && index < characters.count {
				let updateIndex = startIndex.advancedBy(index)
				replaceRange(updateIndex..<updateIndex.successor(), with: "\(character)")
			}
		}
	}
}
