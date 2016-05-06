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
	Calculated by the `RM_BackgroundedSectionTableView` section frame.
	*/
	private(set) var calculatedFrame: CGRect = CGRectZero


	/**
	Section index of the background.
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

- Note: To use this features your delegate object should also conforms to 'RM_BackgroundedSectionTableViewDelegate' protocol.

- Warning: Additionaly, need to redirect `scrollViewDidScroll(:)` event from your 'UITableViewDelegate' to this
table view using `onDidScroll()` function.

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

	private func removeBackgroundViews() {
		for subview in subviews {
			if let back = subview as? RM_TableViewSectionBackground {
				back.removeFromSuperview()
			}
		}
	}

	private var numberOfSectionsInDataSource: Int {
		return self.dataSource?.numberOfSectionsInTableView?(self) ?? 0
	}

	private func createBackgroundViews() {
		for section in 0..<numberOfSectionsInDataSource {
			createBackgroundViewForSection(section)
		}
	}

	private func backgroundViewForSection(section: Int) -> RM_TableViewSectionBackground? {
		for subview in subviews {
			if let back = subview as? RM_TableViewSectionBackground where back.section == section {
				return back
			}
		}
		return nil
	}

	private func createBackgroundViewForSection(section: Int) {
		if backgroundViewForSection(section) == nil {
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
	}

	private func calculateSectionBackgroundFrames() {
		let sectionDelegate = delegate as? RM_BackgroundedSectionTableViewDelegate
		for section in 0..<numberOfSectionsInDataSource {
			if let back = backgroundViewForSection(section) {
				var frame = rectForSection(section)

				if let insets = sectionDelegate?.tableView?(self, sectionBackgroundEdgeInsets: section) {
					frame.origin.x += insets.left
					frame.origin.y += insets.top
					frame.size.width -= insets.left + insets.right
					frame.size.height -= insets.top + insets.bottom
				}

				let includeHeader = sectionDelegate?.tableView?(self, sectionBackgroundUnderHeader: section) ?? false
				if !includeHeader {
					let header = rectForHeaderInSection(section)
					frame.origin.y += header.height
					frame.size.height -= header.height
				}

				let includeFooter = sectionDelegate?.tableView?(self, sectionBackgroundUnderFooter: section) ?? false
				if !includeFooter {
					let footer = rectForFooterInSection(section)
					frame.size.height -= footer.height
				}

				back.frame = frame
				back.calculatedFrame = frame
			}
		}
	}

	private func reloadBackgroundViews() {
		removeBackgroundViews()
		createBackgroundViews()
	}

	public func onDidScroll() {
		calculateSectionBackgroundFrames()
	}

	public override func reloadData() {
		super.reloadData()
		reloadBackgroundViews()
		setNeedsLayout()
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		calculateSectionBackgroundFrames()
		for section in 0..<numberOfSectionsInDataSource {
			if let back = backgroundViewForSection(section) {
				back.frame = back.calculatedFrame
			}
		}
	}
}
