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
	
	- Returns: Last character or `String.NULLCharacter`
	*/
	public var lastCharacter: Character {
		return characters.count > 0 ? self[endIndex.predecessor()] : String.NULLCharacter
	}


	/**
	Get/set string character at index.
	
	- Parameter index: The character index to get or set. 
	If `index` out of bounds than do nothing or get null character `String.NULLCharacter`

	- Returns: String character or `String.NULLCharacter`
	*/
	public subscript(index: Int) -> Character {
		get {
			return (index >= 0 && index < characters.count) ? self[startIndex.advancedBy(index)] : String.NULLCharacter
		}
		set {
			if index >= 0 && index < characters.count {
				let updateIndex = startIndex.advancedBy(index)
				replaceRange(updateIndex..<updateIndex.successor(), with: "\(newValue)")
			}
		}
	}


	/**
	Character initialized with `0` UnicodeScalar value.
	*/
	public static var NULLCharacter: Character {
		return Character(UnicodeScalar(0))
	}
}
