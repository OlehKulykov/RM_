//
//  RM_BackgroundedSectionTableView.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import UIKit

public class RM_TableViewSectionBackground : UIView {

	public var calculatedFrame = CGRectZero
}

@objc
public protocol RM_GroupedTableViewDelegate {
	optional func tableView(tableView: RM_BackgroundedSectionTableView, sectionBackground section: Int) -> RM_TableViewSectionBackground?

	optional func tableView(tableView: RM_BackgroundedSectionTableView, sectionBackgroundEdgeInsets section: Int) -> UIEdgeInsets

	optional func tableView(tableView: RM_BackgroundedSectionTableView, sectionBackgroundUnderFooter section: Int) -> Bool

	optional func tableView(tableView: RM_BackgroundedSectionTableView, sectionBackgroundUnderHeader section: Int) -> Bool
}


public class RM_BackgroundedSectionTableView : UITableView {

	private func tagForSection(section: Int) -> Int {
		return -section - 100 // any value
	}

	private func removeBackgroundViews() {
		for subview in self.subviews {
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
		return viewWithTag(tagForSection(section)) as? RM_TableViewSectionBackground
	}

	private func createBackgroundViewForSection(section: Int) {
		if backgroundViewForSection(section) == nil {
			guard let view = (delegate as? RM_GroupedTableViewDelegate)?.tableView?(self, sectionBackground: section) else {
				return
			}
			view.tag = tagForSection(section)
			self.addSubview(view)
			self.sendSubviewToBack(view)
		}
	}

	private func calculateSectionBackgroundFrames() {
		let sectionDelegate = delegate as? RM_GroupedTableViewDelegate
		for section in 0..<numberOfSectionsInDataSource {
			if let back = backgroundViewForSection(section) {
				var frame = rectForSection(section)

				let insets = sectionDelegate?.tableView?(self, sectionBackgroundEdgeInsets: section) ?? UIEdgeInsetsZero

				frame.origin.x += insets.left
				frame.origin.y += insets.top
				frame.size.width -= insets.left + insets.right
				frame.size.height -= insets.top + insets.bottom

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
