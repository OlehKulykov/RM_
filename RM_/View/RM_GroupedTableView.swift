//
//  RM_GroupedTableView.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import UIKit

protocol RM_GroupedTableViewBackground {

}

class RM_GroupedTableViewGroupBackgroundView : UIView, RM_GroupedTableViewBackground {

	var calculatedFrame: CGRect = CGRectZero

	override func layoutSubviews() {
		super.layoutSubviews()
	}
}

class RM_GroupedTableView : UITableView {

	//private var backClass:AnyClass? = RM_GroupedTableViewGroupBackgroundView

	func registerBackgroundClass(viewClass: AnyClass?) {
//		backClass = viewClass
	}

	var groupOffset: CGFloat = 0

	private func tagForSection(section: Int) -> Int {
		return -section - 100 // any value
	}

	private func removeBackgroundViews() {
		for subview in self.subviews {
			if let back = subview as? RM_GroupedTableViewGroupBackgroundView {
				back.removeFromSuperview()
			}
		}
	}

	private var numberOfSectionsInDataSource: Int {
		get {
			return self.dataSource?.numberOfSectionsInTableView?(self) ?? 0
		}
	}

	private func createBackgroundViews() {
		for section in 0..<numberOfSectionsInDataSource {
			self.createBackgroundViewForSection(section)
		}
	}

	private func backgroundViewForSection(section: Int) -> RM_GroupedTableViewGroupBackgroundView? {
		return viewWithTag(tagForSection(section)) as? RM_GroupedTableViewGroupBackgroundView
	}

	private func createBackgroundViewForSection(section: Int) {
		if backgroundViewForSection(section) == nil {
			let view = RM_GroupedTableViewGroupBackgroundView()
			view.tag = tagForSection(section)
			view.backgroundColor = UIColor.clearColor()
//			view.cornerRadius = 3
			self.addSubview(view)
			self.sendSubviewToBack(view)
		}
	}

	func calculateSectionBackgroundFrames() {
		for section in 0..<numberOfSectionsInDataSource {
			if let back = backgroundViewForSection(section) {
				var frame = rectForSection(section)
				frame.size.height -= rectForFooterInSection(section).height
				let doubleOffset = groupOffset * 2
				frame.origin.x = groupOffset
				frame.origin.y += groupOffset
				frame.size.width -= doubleOffset
				frame.size.height -= doubleOffset
				back.frame = frame
				back.calculatedFrame = frame
			}
		}
	}

	private func reloadBackgroundViews() {
		removeBackgroundViews()
		createBackgroundViews()
	}

	override func reloadData() {
		super.reloadData()
		reloadBackgroundViews()
		setNeedsLayout()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		calculateSectionBackgroundFrames()
		for section in 0..<self.numberOfSectionsInDataSource {
			if let back = backgroundViewForSection(section) {
				back.frame = back.calculatedFrame
			}
		}
	}
}
