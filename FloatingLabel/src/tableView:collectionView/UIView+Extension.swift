//
//  UITableViewCell+Extension.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 11/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

internal extension UIView {
	
	func parentTableView() -> UITableView? {
		return findSuperviewOfClass(UITableView.self) as? UITableView
	}
	
	func parentCollectionView() -> UICollectionView? {
		return findSuperviewOfClass(UICollectionView.self) as? UICollectionView
	}
	
	fileprivate func findSuperviewOfClass(_ viewClass: AnyClass) -> UIView? {
		var view = self.superview
		
		while let superview = view, !superview.isKind(of: viewClass) {
			view = view?.superview
		}
		
		if let view = view, view.isKind(of: viewClass) {
			return view
		} else {
			return nil
		}
	}
	
	func performBatchUpdates(_ batchUpdates: @escaping Closure) {
		if let tableView = parentTableView() {
			tableView.beginUpdates()
			batchUpdates()
			layoutIfNeeded()
			tableView.endUpdates()
		} else if let collectionView = parentCollectionView() {
			collectionView.performBatchUpdates(batchUpdates, completion: nil)
		} else {
			batchUpdates()
		}
	}
	
}

//MARK: - Constraints

internal extension UIView {
	
	func addConstraints(format: String, options: NSLayoutFormatOptions = [], metrics: [String: Any]? = nil, views: [String: UIView]) {
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: views))
	}
	
	func addUniversalConstraints(format: String, options: NSLayoutFormatOptions = [], metrics: [String: Any]? = nil, views: [String: UIView]) {
		addConstraints(format: "H:\(format)", options: options, metrics: metrics, views: views)
		addConstraints(format: "V:\(format)", options: options, metrics: metrics, views: views)
	}
	
}
