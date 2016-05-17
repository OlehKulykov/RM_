//
//  RM_Result.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation


/**
Type of operation result, which are success or failure with additional object.

`T` - Associated value type of object provided with ```Success``` case.
*/
enum RM_Result<T> {

	/**
	Operation was successful with provided result type.
	*/
	case Success(T)


	/**
	Operation was failed with error. Use ```NSLocalizedDescriptionKey``` of the error to get human readable description.
	*/
	case Failure(NSError)
}
