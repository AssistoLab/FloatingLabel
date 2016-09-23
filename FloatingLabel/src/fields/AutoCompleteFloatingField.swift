//
//  AutoCompleteFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 3/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

private let HeightPadding: CGFloat = 20
private let RowHeight: CGFloat = 44

open class AutoCompleteFloatingField: FloatingTextField {
	
	//MARK: - Properties
	
	//MARK: UI
	fileprivate let dropDown = DropDown()
	
	//MARK: Content
	open var dataSource = [String]()
	open var maxDisplayedItems: Int?
	
	fileprivate var filteredSource: [String] {
		get { return dropDown.dataSource }
		set { dropDown.dataSource = newValue }
	}
	
	//MARK: - Init's
	
	convenience init() {
		self.init(frame: Frame.initialFrame)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}

//MARK: - Initialization

extension AutoCompleteFloatingField {
	
	public override func setup() {
		super.setup()
		
		textField.autocorrectionType = .no
		textField.spellCheckingType = .no
		
		dropDown.anchorView = self
		dropDown.direction = .bottom
		dropDown.dismissMode = .automatic
		dropDown.selectionAction = { [unowned self] (index, item) in
			self.text = item
			self.dropDown.selectRow(at: nil)
			self.valueChangedAction?(self.value)
		}
	}
	
	override open func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		
		updateDropDownWidth()
	}
	
}

//MARK: - TextField


extension AutoCompleteFloatingField {
	
	override public func textFieldTextDidChangeNotification() {
		super.textFieldTextDidChangeNotification()
		
		if let newText = text?.lowercased(), !newText.isEmpty {
			let resultsDataSource = dataSource
				.filter { $0.lowercased().characters.starts(with: newText.characters) }
				.sorted { $0.lowercased() < $1.lowercased() }
			
			let endIndex = min(maxDisplayedItems ?? Int.max, resultsDataSource.count)
			
			if endIndex == 0 {
				filteredSource = []
			} else {
				filteredSource = Array(resultsDataSource[0..<endIndex])
			}
			
			if dropDown.isHidden {
				dropDown.show()
			}
		} else {
			dropDown.hide()
		}
	}
	
	override public func textFieldTextDidEndEditingNotification() {
		super.textFieldTextDidEndEditingNotification()
		dropDown.hide()
	}
	
}

//MARK: - DropDown

public extension AutoCompleteFloatingField {
	
	var maxHeightForDisplay: CGFloat {
		return (RowHeight * CGFloat(maxDisplayedItems!)) + HeightPadding
	}
	
	func showDropDown() {
		dropDown.show()
	}
	
	func hideDropDown() {
		dropDown.hide()
	}
	
	func updateDropDownWidth() {
		let separatorLineMaxY = separatorLine.superview!.convert(separatorLine.frame, to: dropDown.anchorView?.plainView).maxY
		dropDown.bottomOffset = CGPoint(x: Constraints.horizontalPadding, y: separatorLineMaxY)
		dropDown.width = separatorLine.bounds.width
	}
}
