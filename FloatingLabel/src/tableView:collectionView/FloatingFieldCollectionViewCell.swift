//
//  FloatingFieldCollectionViewCell.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 10/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public class FloatingFieldCollectionViewCell: UICollectionViewCell {
	
	//MARK: - Properties
	
	public var field: UIView = UIView() {
		didSet {
			oldValue.removeFromSuperview()
			setupConstraints()
		}
	}
	
}

//MARK: - UI

private extension FloatingFieldCollectionViewCell {
	
	func setupConstraints() {
		contentView.addSubview(field)
		field.setTranslatesAutoresizingMaskIntoConstraints(false)
		
		addUniversalConstraints(format: "|[field]|", views: ["field": field])
	}
	
}