//
//  RM_BackgroundedSectionTableView.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import UIKit

/**
Base table view section background view.
Use subclass to make view customization.
*/
public class RM_TableViewSectionBackground : UIView {

	/**
	Background section index.
	*/
	private(set) var section: Int = -1
}


/**
`RM_BackgroundedSectionTableView` table view delegate.
`RM_BackgroundedSectionTableView` have no special property/variable for this type, so, extend your `UITableViewDelegate` with this protocol.
*/
@objc
public protocol RM_BackgroundedSectionTableViewDelegate {
	/**
	Ask gelegate object to create section background view for the section by it's index.
	By default no section background, e.g. `nil`.
	
	- Parameter tableView: The table view that required for the section view.
	
	- Parameter section: Requested section index.
	
	- Returns: Initialized section background view or nil if no background needed. 
	*/
	optional func tableView(tableView: RM_BackgroundedSectionTableView, sectionBackground section: Int) -> RM_TableViewSectionBackground?


	/**
	Ask gelegate object for the section background edge insets. Provide positive values to decrease section background size from top, left, etc.
	Default - no insets.

	- Parameter tableView: The table view that required for the section insets.

	- Parameter section: Requested section index.
	
	- Returns: Section background edge insets.
	*/
	optional func tableView(tableView: RM_BackgroundedSectionTableView, sectionBackgroundEdgeInsets section: Int) -> UIEdgeInsets


	/**
	Ask gelegate object that section background should be placed also under section footer.
	Default is `false` - ignore section footer.

	- Parameter tableView: The table view that could place section background under footer.
 
	- Parameter section: Requested section index.
	
	- Returns: `true` - section background also locates under footer, `false` - ignore section footer.
	*/
	optional func tableView(tableView: RM_BackgroundedSectionTableView, sectionBackgroundUnderFooter section: Int) -> Bool


	/**
	Ask gelegate object that section background should be placed also under section header.
	Default is `false` - ignore section header.

	- Parameter tableView: The table view that could place section background under header.

	- Parameter section: Requested section index.

	- Returns: `true` - section background also locates under header, `false` - ignore section header.
	*/
	optional func tableView(tableView: RM_BackgroundedSectionTableView, sectionBackgroundUnderHeader section: Int) -> Bool
}


/**
Table view that manages custom backgrounds for sections.

- Note: To use this features your delegate object should also conforms to `RM_BackgroundedSectionTableViewDelegate` protocol.

- Warning: Need to redirect `scrollViewDidScroll(:)` event from your `UITableViewDelegate` to this
table view using `onDidScroll()` function. See example.

Example:

```swift
extension MyTableViewController: UITableViewDelegate {

	func scrollViewDidScroll(scrollView: UIScrollView) {
		// Just call 'onDidScroll()' of the table view
		tableView.onDidScroll()
	}
}

extension MyTableViewController: RM_BackgroundedSectionTableViewDelegate {

	func tableView(tableView: RM_BackgroundedSectionTableView, sectionBackground section: Int) -> RM_TableViewSectionBackground? {

		// Create custom background view that inherited from 'RM_TableViewSectionBackground'
		let background = MySectionBackgroundView()

		// Make customizations
		background.backgroundColor = UIColor.whiteColor()

		return background
	}
}
```
*/
public class RM_BackgroundedSectionTableView : UITableView {

	/// Removed all section background views from table view.
	private func removeBackgroundViews() {
		for subview in subviews {
			if let back = subview as? RM_TableViewSectionBackground {
				back.removeFromSuperview()
			}
		}
	}

	/// Create new section background view for each data source section.
	private func createBackgroundViews() {
		let count = dataSource?.numberOfSectionsInTableView?(self) ?? 0
		for section in 0..<count {
			createBackgroundViewForSection(section)
		}
	}

	/// Create single section background by it's index.
	private func createBackgroundViewForSection(section: Int) {
		guard let
			sectionDelegate = delegate as? RM_BackgroundedSectionTableViewDelegate,
			view = sectionDelegate.tableView?(self, sectionBackground: section)
			else {
				return
		}
		view.section = section
		self.addSubview(view)
		self.sendSubviewToBack(view)
	}

	/// Read all available background and update it's frames.
	private func updateSectionBackgroundFrames() {
		let sectionDelegate = delegate as? RM_BackgroundedSectionTableViewDelegate
		for subview in subviews {
			if let back = subview as? RM_TableViewSectionBackground {
				var frame = rectForSection(back.section)

				// Tune up section frame if needed. Depends on delegate.
				if let insets = sectionDelegate?.tableView?(self, sectionBackgroundEdgeInsets: back.section) {
					frame.origin.x += insets.left
					frame.origin.y += insets.top
					frame.size.width -= insets.left + insets.right
					frame.size.height -= insets.top + insets.bottom
				}

				// Ignore section header if needed. Depends on delegate.
				let includeHeader = sectionDelegate?.tableView?(self, sectionBackgroundUnderHeader: back.section) ?? false
				if !includeHeader {
					let header = rectForHeaderInSection(back.section)
					frame.origin.y += header.height
					frame.size.height -= header.height
				}

				// Ignore section footer if needed. Depends on delegate.
				let includeFooter = sectionDelegate?.tableView?(self, sectionBackgroundUnderFooter: back.section) ?? false
				if !includeFooter {
					let footer = rectForFooterInSection(back.section)
					frame.size.height -= footer.height
				}

				back.frame = frame
			}
		}
	}


	/**
	Inform table view that content was scrolled.
	
	- Warning: Call this function within `scrollViewDidScroll(:)` delegate function of the `UITableViewDelegate`
	*/
	public func onDidScroll() {
		updateSectionBackgroundFrames()
	}


	/**
	Reload table view data and section backgrounds.
	*/
	public override func reloadData() {
		super.reloadData()
		removeBackgroundViews()
		createBackgroundViews()
		setNeedsLayout()
	}


	/**
	Table view layout was changed and need to update section backgrounds frames.
	*/
	public override func layoutSubviews() {
		super.layoutSubviews()
		updateSectionBackgroundFrames()
	}
}
