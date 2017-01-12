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

- Note: During the network request `RM_NetworkIndicator` visibility will be updated.

Example: pseudo code for the basic GET request.

```swift
// hold strongly api instance.
let api = RM_APIRequest<RM_JSONElement>(url: "MyURL.json")

// make a request to API.
api.request { result in
	// process result as RM_Result<RM_JSONElement> in a session thread.
}
```
*/
open class RM_APIRequest<Parser: RM_ParsableElementType> {

	/**
	API request timeout in seconds for the instance.
	*/
	open var timeout: TimeInterval = 40


	/**
	The API request URL.
	*/
	fileprivate(set) var url: URL!


	/**
	Request HTTP method. For available types look at `RM_HTTPMethod` enumerator.
	*/
	fileprivate(set) var method: RM_HTTPMethod!


	/// Current stored completion handler.
	internal var completionHandler: ((RM_Result<Parser>) -> Void)?


	/// Current session data task for the requent.
	fileprivate var dataTask: URLSessionTask?


	/**
	Initialize API request instance with URL and HTTP method.

	- Parameter url: The request URL.
	
	- Parameter method: HTTP method of the request. The default value is `GET`.
	*/
	public init(url: String, HTTPMethod method: RM_HTTPMethod = .GET) {
		self.url = URL(string: url)
		self.method = method
	}


	/**
	Create mutable URL request object and setup with url, HTTP method, timeout and cache policy.
	By the default, cache policy is `ReloadIgnoringLocalCacheData`.

	You could override this method in subclasses and setup with extra data, like application spefic
	HTTP headers for uniq identification, etc.

	- Returns: Mutable URL request object or nil if no url provided.
	*/
	internal func createURLRequest() -> URLRequest? {
		guard let url = self.url else {
			return nil
		}
        
		var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout > 0 ? timeout : DBL_MAX)
		request.httpMethod = method.rawValue
		return request
	}


	/**
	Cancels the API request. After this call you will not be informed with a result via completion handler.
	*/
	open func cancel() {
		completionHandler = nil
		if let task = dataTask {
			dataTask = nil
			task.cancel()
			RM_APIRequest.setNetworkIndicatorVisibility(task)
		}
	}


	/**
	Start API request with a completion handler. You could call this method any times it's needed.
	
	- Parameter completionHandler: The completion handler with a result of the operation.
	Called from session thread. 

	- Note: Before new request with this method, previvous request will be canceled.

	Example: You could use result from the responce like
	
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
	open func request(_ completionHandler: @escaping (RM_Result<Parser>) -> Void) {
		cancel()
		self.completionHandler = completionHandler
        
		guard let request = createURLRequest() else {
			//TODO: we can't create required request data.
			completionHandler(.failure(NSError(domain: "", code: 0, userInfo: nil)))
			return
		}
        
        dataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, responce, error) in
            self?.processTaskResult(data: data, response: responce, error: error)
        }
		dataTask!.resume()
		RM_APIRequest.setNetworkIndicatorVisibility(dataTask!)
	}


	/// Process received information from the task. At the end need to call `informResult`.
	fileprivate func processTaskResult(data: Data?, response: URLResponse?, error: Error?) {
		if let error = error {
			informResult(.failure(error))
			return
		}

		guard let
			data = data,
			let parser = RM_JSONElement(data: data) as? Parser
		else {
			let error = NSError(domain: "\(self)", code: 0, userInfo: [NSLocalizedDescriptionKey : RM_LocalizationKey.APIRequestCantHandleResponce.localized])
			informResult(.failure(error))
			return
		}

		informResult(.success(parser))
	}


	/// Call the completion handler(if not canceled) with an operation result
	/// and clean up request specific data, like task and handler.
	fileprivate func informResult(_ result: RM_Result<Parser>) {
		guard let
			handler = completionHandler,
			let task = dataTask
		else {
			return
		}

		completionHandler = nil
		dataTask = nil

		RM_APIRequest.setNetworkIndicatorVisibility(task)

		handler(result)
	}

	/// Set `RM_NetworkIndicator` visibility based on task status.
	/// - Parameter task: The network session task.
	fileprivate static func setNetworkIndicatorVisibility(_ task: URLSessionTask) {
		switch task.state {
		case .running, .suspended:
			RM_NetworkIndicator.visible = true
		default:
			RM_NetworkIndicator.visible = false
		}
	}

}
