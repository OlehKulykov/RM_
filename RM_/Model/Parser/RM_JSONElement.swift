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
Enumerator type can be any of types supported by the `NSJSONSerialization` like:
`Array`, `Dictionary`, `String`, `NSNumber` or `NSNull`.

That's why it's possible to get/cast to this type or initialize element from this type.

Example: create JSON element from API data, read required array with products and
for each product get required and optional data.

```swift
// Init JSON element with data. For instance from API
guard let json = RM_JSONElement(data: APIData) else {
	return // Data doesn't contain JSON
}

// Get products array, each element is `RM_JSONElement`
guard let products = json["products"].array else {
	return // no products
}

// For each JSON element get required and optional data
for product in products {
	// Get required product `price` and `qu antity`
	guard let
		price = product["price"].decimal, // product price
		quantity = product["quantity"].integer // product quantity
		else {
			// There is no required product info
			continue // with next element
	}

	// Get optional product info, like `description`
	let description = product["description"].string

	// Do something with required and optional product info
}
```
*/
public enum RM_JSONElement: RM_ParsableElementType {

	//MARK: JSON element types.

    public typealias AnyType = Any
    public typealias DictionaryType = [String:RM_JSONElement.AnyType]
    public typealias ArrayType = [RM_JSONElement.AnyType]
    
	/// Element is `NSDictionary`.
    case dictionary(RM_JSONElement.DictionaryType)


	/// Element is `NSArray`.
	/// Use `.array` dynamic variable to get/cast stored object to an array of `Any`'s.
	case array(RM_JSONElement.ArrayType)


	/// Element is String or Number.
	/// Use `.decimal`, `.number`, `.integer`, `.double`, `.bool` dynamic variables.
	/// to get/cast to an appropriate type.
	case object(RM_JSONElement.AnyType)


	/// Element is `NSNull` or any other unsupported type.
	case null


	//MARK: Initializers

	/**
	Initialize JSON element from JSON data.
	
	- Parameter data: The data object containing JSON data. Root could be dictionary or array.
	
	- Returns: Initialized element or nil if data is not JSON or an error occurs.
	*/
	public init?(data: Data) {
		guard let object = try? JSONSerialization.jsonObject(with: data, options: []) else {
			return nil
		}
		self.init(object: object)
	}


	/**
	Initialize JSON element from any supported object.
	
	- Parameter object: Any of next objects: `Array`, `Dictionary`, `String`, `Number`.
	*/
	public init(object: RM_JSONElement.AnyType) {
        if let dictionary = object as? RM_JSONElement.DictionaryType {
			self = .dictionary(dictionary)
		} else if let array = object as? RM_JSONElement.ArrayType {
			self = .array(array)
		} else {
			self = .object(object)
		}
	}


	/**
	Index based subscription to get JSON element by it's array index in a case of array type element.
	
	- Parameter arrayIndex: Array index of the element, could be out on bounds.
	In a case if index out of bounds result will be Null element.
	
	- Returns: JSON element by array index or Null.
	*/
	public subscript(arrayIndex: Int) -> RM_JSONElement {
		switch self {
		case .array(let data):
			if data.startIndex <= arrayIndex && arrayIndex < data.endIndex {
				return RM_JSONElement(object: data[arrayIndex])
			}
		default:
			break
		}
		return .null
	}


	/**
	Key-based subscription to get JSON element by it's key in a case of dictionary element type.
	
	- Parameter key: Object string key.
	
	- Returns: JSON element for key or Null if no such value for key present or element is not dictionary.
	*/
	public subscript(key: String) -> RM_JSONElement {
		switch self {
		case .dictionary(let data):
			if let value = data[key] {
				return RM_JSONElement(object: value as RM_JSONElement.AnyType)
			}
		default:
			break
		}
		return .null
	}


	/**
	Get/cast element value as array of maped JSON elements.
	Could be used to check is this object is array or not.
	
	- Returns: Array or nil.
	*/
	public var array: [RM_JSONElement]? {
		switch self {
		case .array(let data):
			return data.map { RM_JSONElement(object: $0) }
		default:
			return nil
		}
	}


	/**
	Obtain string value of the object if element is string or could be casted to string.
	
	- Returns: String or nil.
	*/
	public var string: String? {
		switch self {
		case .object(let data):
			return data as? String
		default:
			return nil
		}
	}


	/**
	Obtain integer value of the object if possible(can be converted from number or string).
	
	- Returns: Integer value or nil.
	*/
	public var integer: Int? {
		return self.number?.intValue
	}


	/**
	Obtain double value of the object if possible(can be converted from number or string).
	
	- Returns: Double value or nil.
	*/
	public var double: Double? {
		return self.number?.doubleValue
	}


	/**
	Obtain boolean value of the object if possible(can be converted from number or string).
	
	- Returns: Boolean value or nil.
	*/
	public var bool: Bool? {
		return self.number?.boolValue
	}


	/**
	Obtain `NSDecimalNumber` object of the element if possible.
	Object should be one of the next types: `NSNumber`, `NSDecimalNumber` or string.
	
	- Returns: `NSDecimalNumber` object or nil.
	*/
	public var decimal: NSDecimalNumber? {
		switch self {
		case .object(let data):
			if let number = data as? NSDecimalNumber {
				return number
			} else if let number = data as? NSNumber {
				return NSDecimalNumber(decimal: number.decimalValue)
			} else if let string = self.string {
				return RM_JSONElement.decimalNumberFormatter.number(from: string) as? NSDecimalNumber
			}
		default:
			break
		}
		return nil
	}


	/**
	Obtain `NSNumber` object of the element if possible.
	Object should be one of the next types: `NSNumber`, `NSDecimalNumber` or string.
	
	- Returns: `NSNumber` object or nil.
	*/
	public var number: NSNumber? {
		switch self {
		case .object(let data):
			if let number = data as? NSNumber {
				return number
			}
			if let string = self.string {
				return RM_JSONElement.numberFormatter.number(from: string)
			}
		default:
			break
		}
		return nil
	}


	//MARK: Predefined number formatters

	/// Decimal number formatter from string to `NSDecimalNumber`.
	public static var decimalNumberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.numberStyle = .decimal
		formatter.generatesDecimalNumbers = true
		return formatter
	}()


	/// Number formatter from string to `NSNumber`.
	public static var numberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = false
		return formatter
	}()

}
