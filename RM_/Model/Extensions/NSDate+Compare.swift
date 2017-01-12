//
//  NSDate+Compare.swift
//  RM_
//
//  Created by Oleh Kulykov on 09/06/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//


import Foundation


/**
**Less than** operator

- Parameter x: Left date operand

- Parameter y: Rigth date operand

- Returns: `true` if `x` less than `y`, othervice `false`

Example:

```swift
if x < y {
// 'x' earlier than 'y'
}
```
*/
public func <(x: Date, y: Date) -> Bool {
	return x.compare(y) == ComparisonResult.orderedAscending
}


/**
**Less than or equal to** operator

- Parameter x: Left date operand

- Parameter y: Rigth date operand

- Returns: `true` if `x` less than or equal to `y`, othervice `false`

Example:

```swift
if x <= y {
// 'x' earlier than or equal to 'y'
}
```
*/
public func <=(x: Date, y: Date) -> Bool {
	let result = x.compare(y)
	return (result == ComparisonResult.orderedAscending) || (result == ComparisonResult.orderedSame)
}


/**
**Greater than** operator

- Parameter x: Left date operand

- Parameter y: Rigth date operand

- Returns: `true` if `x` greater than `y`, othervice `false`

Example:

```swift
if x > y {
// 'x' later than 'y'
}
```
*/
public func >(x: Date, y: Date) -> Bool {
	return x.compare(y) == ComparisonResult.orderedDescending
}


/**
**Greater than or equal to** operator

- Parameter x: Left date operand

- Parameter y: Rigth date operand

- Returns: true if `x` greater than or equal to `y`, othervice `false`

Example:

```swift
if x > y {
// 'x' later than or equal to 'y'
}
```
*/
public func >=(x: Date, y: Date) -> Bool {
	let result = x.compare(y)
	return (result == ComparisonResult.orderedDescending) || (result == ComparisonResult.orderedSame)
}


/**
**Equal to** operator

- Parameter x: Left date operand

- Parameter y: Rigth date operand

- Returns: `true` if `x` equal to `y`, othervice `false`

Example:

```swift
if x == y {
// 'x' same as, e.g equal to 'y'
}
```
*/
public func ==(x: Date, y: Date) -> Bool {
	return x.compare(y) == ComparisonResult.orderedSame
}


/**
**Not equal to** operator

- Parameter x: Left date operand

- Parameter y: Rigth date operand

- Returns: `true` if `x` not equal to `y`, othervice `false`

Example:

```swift
if x != y {
// 'x' not same as, e.g not equal to 'y'
}
```
*/
public func !=(x: Date, y: Date) -> Bool {
	return x.compare(y) != ComparisonResult.orderedSame
}


/**
Minimal(earliest) date from the list

- Parameter dates: Dates list

- Returns: Minimal(earliest) date or now if list is empty

Example:

```swift
min() // now date
min(now, now.dateByAddingTimeInterval(1)) // now date
min(now, now.dateByAddingTimeInterval(1), now.dateByAddingTimeInterval(2)) // now date
min(now, now.dateByAddingTimeInterval(1), now.dateByAddingTimeInterval(-2)) // now.dateByAddingTimeInterval(-2)
```
*/
//public func min<T : Date>(_ dates: T...) -> T {
//	var minimum: T? = nil
//	for date in dates {
//		guard let minDate = minimum else {
//			minimum = date
//			continue
//		}
//		if minDate.compare(date) == ComparisonResult.orderedDescending {
//			minimum = date
//		}
//	}
//	return minimum ?? T()
//}


/**
Maximal(latest) date from the list

- Parameter dates: Dates list

- Returns: Maximal(latest) date or now if list is empty

Example:

```swift
max() // now date
max(now, now.dateByAddingTimeInterval(1)) // now.dateByAddingTimeInterval(1)
max(now, now.dateByAddingTimeInterval(1), now.dateByAddingTimeInterval(2)) // now.dateByAddingTimeInterval(2)
```
*/
//public func max<T : Date>(_ dates: T...) -> T {
//	var maximum: T? = nil
//	for date in dates {
//		guard let maxDate = maximum else {
//			maximum = date
//			continue
//		}
//		if maxDate.compare(date) == ComparisonResult.orderedAscending {
//			maximum = date
//		}
//	}
//	return maximum ?? T()
//}

