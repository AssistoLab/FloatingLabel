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

public class AutoCompleteFloatingField: FloatingTextField {
	
	//MARK: - Properties
	
	//MARK: UI
	private let dropDown = DropDown()
	
	//MARK: Content
	public var dataSource = [String]()
	public var maxDisplayedItems: Int?
	
	private var filteredSource: [String] {
		get { return dropDown.dataSource }
		set { dropDown.dataSource = newValue }
	}
	
	//MARK: - Init's
	
	convenience init() {
		self.init(frame: Frame.InitialFrame)
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
	
	internal override func setup() {
		super.setup()
		
		textField.autocorrectionType = .No
		textField.spellCheckingType = .No
		
		dropDown.anchorView = self
		dropDown.direction = .Bottom
		dropDown.dismissMode = .Automatic
		dropDown.selectionAction = { [unowned self] (index, item) in
			self.text = item
			self.dropDown.selectRowAtIndex(nil)
			self.valueChangedAction?(self.value)
		}
	}
	
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		
		updateDropDownWidth()
	}
	
}

//MARK: - TextField

internal extension AutoCompleteFloatingField {
	
	override func textFieldTextDidChangeNotification() {
		super.textFieldTextDidChangeNotification()
		
		if let newText = text?.lowercaseString where !newText.isEmpty {
			let resultsDataSource = dataSource
				.filter { $0.lowercaseString.characters.startsWith(newText.characters) }
				.sort { $0.lowercaseString < $1.lowercaseString }
			
			let endIndex = min(maxDisplayedItems ?? Int.max, resultsDataSource.count)
			
			if endIndex == 0 {
				filteredSource = []
			} else {
				filteredSource = Array(resultsDataSource[0..<endIndex])
			}
			
			if dropDown.hidden {
				dropDown.show()
			}
		} else {
			dropDown.hide()
		}
	}
	
	override func textFieldTextDidEndEditingNotification() {
		super.textFieldTextDidEndEditingNotification()
		dropDown.hide()
	}
	
}

//MARK: - DropDown

internal extension AutoCompleteFloatingField {
	
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
		let separatorLineMaxY = separatorLine.superview!.convertRect(separatorLine.frame, toView: dropDown.anchorView).maxY
		dropDown.bottomOffset = CGPoint(x: Constraints.HorizontalPadding, y: separatorLineMaxY)
		dropDown.width = separatorLine.bounds.width
	}
}