//
//  FloatingFieldCollectionViewCell.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 10/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

open class FloatingFieldCollectionViewCell: UICollectionViewCell {
	
	//MARK: - Properties
	
	open var field: UIView!
	
}

//MARK: - UI

public extension FloatingFieldCollectionViewCell {
	
	func setupConstraints() {
		field.translatesAutoresizingMaskIntoConstraints = false
		
		// Not constraint to the bottom of the cell to avoid glitch when animating cell to show/hide helper text
		addConstraints(format: "H:|[field]|", views: ["field": field])
		addConstraints(format: "V:|[field]", views: ["field": field])
	}
	
}
