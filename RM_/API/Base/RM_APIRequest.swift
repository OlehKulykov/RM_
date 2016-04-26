//
//  RM_APIRequest.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation


/**
API request to communicate with server API.

Can be used with any available parser to convert received raw data
into internal, parsable `RM_ParsableElement` presentation.

Example: pseudo code for the basic GET request.

```swift
	// hold strongly api instance.
	let api = RM_APIRequest<RM_JSONElement>(url: "MyURL.json")

	// make a request to API.
	api.request { result in
		// process result as RM_Result<RM_JSONElement> in a session thread.
	}
````
*/
class RM_APIRequest<Parser: RM_ParsableElementType> {

	/**
	API request timeout in seconds for the instance.
	*/
	var timeout: NSTimeInterval = 40


	/**
	The API request URL.
	*/
	private(set) var url: NSURL!


	/**
	Request HTTP method. For available types look at `RM_HTTPMethod` enumerator.
	*/
	private(set) var method: RM_HTTPMethod!


	/// Current stored completion handler.
	private var completionHandler: (RM_Result<Parser> -> Void)?


	/// Current session task for the requent.
	private var task: NSURLSessionTask?


	/**
	Initialize API request instance with URL and HTTP method.

	- Parameters:
		- url: The request URL.
		- method: HTTP method of the request. The default value is `GET`.
	*/
	init(url: String, HTTPMethod method: RM_HTTPMethod = .GET) {
		self.url = NSURL(string: url)
		self.method = method
	}


	/**
	Create mutable URL request object and setup with url, HTTP method, timeout and cache policy.
	By the default, cache policy is `ReloadIgnoringLocalCacheData`.

	You could override this method in subclasses and setup with extra data, like application spefic
	HTTP headers for uniq identification, etc.

	- Returns: Mutable URL request object or nil if no url provided.
	*/
	func createURLRequest() -> NSMutableURLRequest? {
		guard let url = self.url else {
			return nil
		}

		let request = NSMutableURLRequest(URL: url,
		                                  cachePolicy: .ReloadIgnoringLocalCacheData,
		                                  timeoutInterval: timeout > 0 ? timeout : DBL_MAX)
		request.HTTPMethod = method.rawValue
		return request
	}


	/**
	Cancels the API request. After this call you will not be informed with a result via completion handler.
	*/
	func cancel() {
		completionHandler = nil
		task?.cancel()
		task = nil
	}


	/**
	Start API request with a completion handler. You could call this method any times it's needed.
	
	- Parameter completionHandler: The completion handler with a result of the operation.
	Called from session thread. 

	- Note: Before new request with this method, previvous request will be canceled.

	- Example: You could use result from the responce like
	
	```swift
		// hold strongly api instance.
		let api = RM_APIRequest<RM_JSONElement>(url: "MyURL.json")
		// make a request to API.
		api.request { result in
			switch result {
			case .Success(let json):
				print("API json result: \(json)")
			case .Failure(let error):
				print("API error: \(error)")
			}
		}
	```
	*/
	func request(completionHandler: RM_Result<Parser> -> Void) {
		cancel()
		self.completionHandler = completionHandler

		guard let request = createURLRequest() else {
			//TODO: we can't create required request data.
			completionHandler(.Failure(NSError(domain: "", code: 0, userInfo: nil)))
			return
		}

		task = NSURLSession.sharedSession().dataTaskWithRequest(request) { [weak self] (data, response, error) in
			self?.processTaskResult(data, response: response, error: error)
		}
		task?.resume()
	}


	/// Process received information from the task. At the end need to call `informResult`.
	private func processTaskResult(data: NSData?, response: NSURLResponse?, error: NSError?) {
		if let error = error {
			informResult(.Failure(error))
			return
		}

		guard let
			data = data,
			parser = RM_JSONElement(data: data) as? Parser
		else {
			let error = NSError(domain: "\(self)", code: 0, userInfo: [NSLocalizedDescriptionKey : RM_LocalizationKey.APIRequestCantHandleResponce.localized])
			informResult(.Failure(error))
			return
		}

		informResult(.Success(parser))
	}


	/// Call the completion handler(if not canceled) with an operation result
	/// and clean up request specific data, like task and handler.
	private func informResult(result: RM_Result<Parser>) {
		guard let handler = completionHandler else {
			return
		}

		completionHandler = nil
		task = nil

		handler(result)
	}

}