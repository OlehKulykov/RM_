//
//  UIImageView+LoadFromURL.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import UIKit


extension UIImageView {

	/// Private struct with lazy static url key.
	fileprivate struct AssociatedKey {
		/// Lazy static key, that used for the associated image url object.
		static var imageUrlKey = "imageUrl"
	}

	/**
	Public getter of the image url, provided to function `loadImageFromURL`.
	*/
	fileprivate(set) var imageUrl: URL? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKey.imageUrlKey) as? URL
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKey.imageUrlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}


	/// Actual loading image data using `NSURLSession` data task.
	fileprivate func loadImageFromURL(_ url: URL) {
		let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
			guard let
				receivedData = data,
				let receivedImage = UIImage(data: receivedData)
				else {
					return
			}
			DispatchQueue.main.async {
				if let imageUrl = self?.imageUrl, imageUrl == url {
					self?.image = receivedImage
				}
				self?.setNeedsDisplay()
			}
		}) 
		task.resume()
	}


	/**
	Load image from url with placeholder.

	- Parameter url: Image URL for download.

	- Parameter placeholder: Placeholder image for display during loading.
	*/
	public func loadImageFromURL(_ url: URL?, placeholder: UIImage?) {
		image = placeholder
		imageUrl = url

		if let url = url {
			// Create and start data task within background
			DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async { [weak self] in
				self?.loadImageFromURL(url)
				}
		}
	}
	
}
