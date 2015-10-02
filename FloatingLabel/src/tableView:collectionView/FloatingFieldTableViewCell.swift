//
//  FloatingFieldTableViewCell.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 10/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public class FloatingFieldTableViewCell: UITableViewCell {
	
	//MARK: - Properties
	
	public weak var tableView: UITableView?
	
	public var field: UIView = UIView() {
		didSet {
			oldValue.removeFromSuperview()
			setupConstraints()
		}
	}
	
}

//MARK: - UI

private extension FloatingFieldTableViewCell {
	
	func setupConstraints() {
		// Helper label
		contentView.addSubview(field)
		field.translatesAutoresizingMaskIntoConstraints = false
		
		addUniversalConstraints(format: "|[field]|", views: ["field": field])
	}
	
}