//
//  RM_BackgroundedSectionTableViewController.swift
//  RM_
//
//  Created by Oleh Kulykov on 27/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import UIKit

class RM_SectionBackground: RM_TableViewSectionBackground {

	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		cornerRadius = 4
		borderColor = UIColor.lightGrayColor()
		borderWidth = 0.5
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		setShadow(UIEdgeInsetsMake(1, 2.5, 6, 2.5), color: UIColor.blackColor(), radius: 4, opacity: 0.16)
	}
}

class RM_BackgroundedSectionTableViewController: UIViewController {

	@IBOutlet weak var tableView: RM_BackgroundedSectionTableView!

}


//MARK: TableView DataSource. Nothing special, just example
extension RM_BackgroundedSectionTableViewController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 3
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

		// Setup the cell with data
		if let textLabel = cell.textLabel {
			textLabel.text = "indexPath section: \(indexPath.section), row: \(indexPath.row)"
			textLabel.font = RM_Font.LatoRegular.fontWithSize(14)
			textLabel.textColor = UIColor(hexString: "#6D757A")
		}
		return cell
	}
}

extension RM_BackgroundedSectionTableViewController: RM_BackgroundedSectionTableViewDelegate, UIScrollViewDelegate {

	//MARK: UIScrollViewDelegate, inform tableview that the table view did scrolled
	func scrollViewDidScroll(scrollView: UIScrollView) {
		tableView.onDidScroll()
	}

	//MARK: RM_BackgroundedSectionTableViewDelegate, manage table view section backgrounds
	func tableView(tableView: RM_BackgroundedSectionTableView, sectionBackground section: Int) -> RM_TableViewSectionBackground? {
		let background = RM_SectionBackground()
		background.backgroundColor = UIColor.whiteColor()
		return background
	}

	func tableView(tableView: RM_BackgroundedSectionTableView, sectionBackgroundEdgeInsets section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsMake(0, 8, 0, 8)
	}

}
