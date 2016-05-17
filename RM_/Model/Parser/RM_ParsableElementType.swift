//
//  RM_ParsableElementType.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation


/**
Parsable element object protocol which could be initialized with data(JSON, XML, etc)
and casted to an internal, primitive values. Like dictionaries, arrays, numbers etc.
*/
protocol RM_ParsableElementType {

	/**
	Initialize element from data.
	
	- Parameter data: The data object to parse.
	
	- Returns: Initialized element or nil if data is not in a supported format for the implementation.
	*/
	init?(data: NSData)


	/**
	Index based subscription to get element by it's array index in a case of array type element.
	
	- Parameter arrayIndex: Array index of the element, could be out on bounds.
	
	- Returns: Element by array index.
	*/
	subscript(arrayIndex: Int) -> Self { get }


	/**
	Key-based subscription to get element by it's key in a case of dictionary element type.
	
	- Parameter key: Object string key.
	
	- Returns: Element for key or Null if no such value for key present or element is not dictionary.
	*/
	subscript(key: String) -> Self { get }


	/**
	Get/cast element value as array of maped elements.
	Could be used to check is this object is array or not.
	
	- Returns: Array or nil.
	*/
	var array: [Self]? { get }


	/**
	Obtain string value of the object if element is string or could be casted to string.
	
	- Returns: String or nil.
	*/
	var string: String? { get }


	/**
	Obtain integer value of the object if possible(can be converted from number or string).
	
	- Returns: Integer value or nil.
	*/
	var integer: Int? { get }


	/**
	Obtain double value of the object if possible(can be converted from number or string).
	
	- Returns: Double value or nil.
	*/
	var double: Double? { get }


	/**
	Obtain boolean value of the object if possible(can be converted from number or string).
	
	- Returns: Boolean value or nil.
	*/
	var bool: Bool? { get }


	/**
	Obtain `NSDecimalNumber` object of the element if possible.
	
	- Returns: `NSDecimalNumber` object or nil.
	*/
	var decimal: NSDecimalNumber? { get }


	/**
	Obtain `NSNumber` object of the element if possible.
	
	- Returns: `NSNumber` object or nil.
	*/
	var number: NSNumber? { get }
}
