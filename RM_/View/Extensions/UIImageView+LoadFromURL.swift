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
	private struct AssociatedKey {
		/// Lazy static key, that used for the associated image url object.
		static var imageUrlKey = "imageUrl"
	}

	/**
	Public getter of the image url, provided to function `loadImageFromURL`.
	*/
	private(set) var imageUrl: NSURL? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKey.imageUrlKey) as? NSURL
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKey.imageUrlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}


	/// Actual loading image data using `NSURLSession` data task.
	private func loadImageFromURL(url: NSURL) {
		let task = NSURLSession.sharedSession().dataTaskWithURL(url) { [weak self] (data, response, error) in
			guard let
				receivedData = data,
				receivedImage = UIImage(data: receivedData)
				else {
					return
			}
			dispatch_async(dispatch_get_main_queue(), {
				if let imageUrl = self?.imageUrl where imageUrl == url {
					self?.image = receivedImage
				}
				self?.setNeedsDisplay()
			})
		}
		task.resume()
	}


	/**
	Load image from url with placeholder.

	- Parameter url: Image URL for download.

	- Parameter placeholder: Placeholder image for display during loading.
	*/
	public func loadImageFromURL(url: NSURL?, placeholder: UIImage?) {
		image = placeholder
		imageUrl = url

		guard let url = url else {
			return
		}

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { [weak self] in
			self?.loadImageFromURL(url)
			})
	}
	
}
