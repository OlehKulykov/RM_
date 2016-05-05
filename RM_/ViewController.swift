//
//  ViewController.swift
//  RM_
//
//  Created by Oleh Kulykov on 22/04/16.
//  Copyright © 2016 Oleh Kulykov. All rights reserved.
//

import UIKit

class RM_GroupedTableViewGroupBackgroundView1 : UIView, RM_GroupedTableViewBackground {

	var calculatedFrame: CGRect = CGRectZero

	override func layoutSubviews() {
		super.layoutSubviews()
	}
}

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let table = RM_GroupedTableView()
//		table.BackType = RM_GroupedTableViewGroupBackgroundView1
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

