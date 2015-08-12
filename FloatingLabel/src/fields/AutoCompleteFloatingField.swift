//
//  AutoCompleteFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 3/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

public class AutoCompleteFloatingField: FloatingTextField {
	
	//MARK: - Properties
	
	//MARK: UI
	private let dropDown = DropDown()
	
	//MARK: Content
	public var dataSource = [String]()
	
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
	
	required public init(coder aDecoder: NSCoder) {
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
			self.dropDown.selectRowAtIndex(-1)
		}
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		let separatorLineMaxY = separatorLine.superview!.convertRect(separatorLine.frame, toView: dropDown.anchorView).maxY
		dropDown.bottomOffset = CGPoint(x: Constraint.HorizontalPadding, y: separatorLineMaxY)
		dropDown.width = separatorLine.bounds.width
	}
	
}

//MARK: - TextField

internal extension AutoCompleteFloatingField {
	
	override func textFieldTextDidChangeNotification() {
		super.textFieldTextDidChangeNotification()
		
		if let newText = text?.lowercaseString where count(newText) > 1 {
			filteredSource = dataSource
				.filter { startsWith($0.lowercaseString, newText) }
				.sorted { $0.lowercaseString < $1.lowercaseString }
			
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