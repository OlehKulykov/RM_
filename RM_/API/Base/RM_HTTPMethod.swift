//
//  RM_HTTPMethod.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation


/**
HTTP request methods.
Each case have upper case method name string.
You could append other methods if required.
*/
enum RM_HTTPMethod: String {

	/// Represent GET http method.
	case GET = "GET"


	/// Represent POST http method.
	case POST = "POST"
}
