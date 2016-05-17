//
//  RM_JSONElement.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation


/**
Enumerator which represent JSON element.

For each element, except Null, it's possible to get casted dictionary, array or primitive value object.
Enumerator type can be any of types supported by the ```NSJSONSerialization``` like:
```NSArray```, ```NSDictionary```, ```NSString```, ```NSNumber``` or ```NSNull```.

That's why it's possible to get/cast to this type or initialize element from this type.
*/
enum RM_JSONElement: RM_ParsableElementType {

	//MARK: JSON element types.

	/// Element is ```NSDictionary```.
	case Dictionary(NSDictionary)


	/// Element is ```NSArray```.
	/// Use ```.array``` dynamic variable to get/cast stored object to an array of ```AnyObject```'s.
	case Array([AnyObject])


	/// Element is NSString or NSNumber.
	/// Use ```.decimal```, ```.number```, ```.integer```, ```.double```, ```.bool``` dynamic variables.
	/// to get/cast to an appropriate type.
	case Object(AnyObject)


	/// Element is ```NSNull``` or any other unsupported type.
	case Null


	//MARK: Initializers

	/**
	Initialize JSON element from JSON data.
	
	- Parameter data: The data object containing JSON data. Root could be dictionary or array.
	
	- Returns: Initialized element or nil if data is not JSON or an error occurs.
	*/
	init?(data: NSData) {
		guard let object = try? NSJSONSerialization.JSONObjectWithData(data, options: []) else {
			return nil
		}
		self.init(object: object)
	}


	/**
	Initialize JSON element from any supported object.
	
	- Parameter object: Any of next objects: ```NSArray```, ```NSDictionary```, ```NSString```, ```NSNumber```.
	*/
	init(object: AnyObject) {
		if let dictionary = object as? NSDictionary {
			self = .Dictionary(dictionary)
		} else if let array = object as? [AnyObject] {
			self = .Array(array)
		} else {
			self = .Object(object)
		}
	}


	/**
	Index based subscription to get JSON element by it's array index in a case of array type element.
	
	- Parameter arrayIndex: Array index of the element, could be out on bounds.
	In a case if index out of bounds result will be Null element.
	
	- Returns: JSON element by array index or Null.
	*/
	subscript(arrayIndex: Int) -> RM_JSONElement {
		switch self {
		case .Array(let data):
			if data.startIndex <= arrayIndex && arrayIndex < data.endIndex {
				return RM_JSONElement(object: data[arrayIndex])
			}
		default:
			break
		}
		return .Null
	}


	/**
	Key-based subscription to get JSON element by it's key in a case of dictionary element type.
	
	- Parameter key: Object string key.
	
	- Returns: JSON element for key or Null if no such value for key present or element is not dictionary.
	*/
	subscript(key: String) -> RM_JSONElement {
		switch self {
		case .Dictionary(let data):
			if let value = data[key] {
				return RM_JSONElement(object: value)
			}
		default:
			break
		}
		return .Null
	}


	/**
	Get/cast element value as array of maped JSON elements.
	Could be used to check is this object is array or not.
	
	- Returns: Array or nil.
	*/
	var array: [RM_JSONElement]? {
		switch self {
		case .Array(let data):
			return data.map { RM_JSONElement(object: $0) }
		default:
			return nil
		}
	}


	/**
	Obtain string value of the object if element is string or could be casted to string.
	
	- Returns: String or nil.
	*/
	var string: String? {
		switch self {
		case .Object(let data):
			return data as? String
		default:
			return nil
		}
	}


	/**
	Obtain integer value of the object if possible(can be converted from number or string).
	
	- Returns: Integer value or nil.
	*/
	var integer: Int? {
		return self.number?.integerValue
	}


	/**
	Obtain double value of the object if possible(can be converted from number or string).
	
	- Returns: Double value or nil.
	*/
	var double: Double? {
		return self.number?.doubleValue
	}


	/**
	Obtain boolean value of the object if possible(can be converted from number or string).
	
	- Returns: Boolean value or nil.
	*/
	var bool: Bool? {
		return self.number?.boolValue
	}


	/**
	Obtain ```NSDecimalNumber``` object of the element if possible.
	Object should be one of the next types: ```NSNumber```, ```NSDecimalNumber``` or string.
	
	- Returns: ```NSDecimalNumber``` object or nil.
	*/
	var decimal: NSDecimalNumber? {
		switch self {
		case .Object(let data):
			if let number = data as? NSDecimalNumber {
				return number
			} else if let number = data as? NSNumber {
				return NSDecimalNumber(decimal: number.decimalValue)
			} else if let string = self.string {
				return RM_JSONElement.decimalNumberFormatter.numberFromString(string) as? NSDecimalNumber
			}
		default:
			break
		}
		return nil
	}


	/**
	Obtain ```NSNumber``` object of the element if possible.
	Object should be one of the next types: ```NSNumber```, ```NSDecimalNumber``` or string.
	
	- Returns: ```NSNumber``` object or nil.
	*/
	var number: NSNumber? {
		switch self {
		case .Object(let data):
			if let number = data as? NSNumber {
				return number
			}
			if let string = self.string {
				return RM_JSONElement.numberFormatter.numberFromString(string)
			}
		default:
			break
		}
		return nil
	}


	//MARK: Private number formatters

	/// Decimal number formatter from string to NSDecimalNumber.
	private static var decimalNumberFormatter: NSNumberFormatter = {
		let formatter = NSNumberFormatter()
		formatter.numberStyle = .DecimalStyle
		formatter.generatesDecimalNumbers = true
		return formatter
	}()


	/// Number formatter from string to NSNumber.
	private static var numberFormatter: NSNumberFormatter = {
		let formatter = NSNumberFormatter()
		formatter.numberStyle = .DecimalStyle
		return formatter
	}()

}
