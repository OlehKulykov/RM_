//
//  RM_Font.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation
import UIKit


/**
Custom application provided fonts.
Each case is a string file name without extension of the font.

Example: create one of the provided custom fonts.

```swift
	// Create 'Lato bold' font with size 16.5
	let font = RM_Font.<KEY>.fontWithSize(16.5)
```
*/
enum RM_Font: String {

	//MARK: Font cases

	/// _Lato bold_ font name.
	case LatoBold = "Lato-Bold"

	/// _Lato light_ font name.
	case LatoLight = "Lato-Light"

	/// _Lato regular_ font name.
	case LatoRegular = "Lato-Regular"


	//MARK: Font creation from case

	/**
	Create custom font with size for key.

	- Parameter size: Font size in pixels.

	- Returns: Create custom font with a provided size.
	*/
	func fontWithSize(size: CGFloat) -> UIFont {
		return UIFont(name: self.rawValue, size: size)!
	}
}
