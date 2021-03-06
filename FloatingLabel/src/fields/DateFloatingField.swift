//
//  DateFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 22/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public class DateFloatingField: FloatingTextField {
	
	//MARK: - Properties
	
	//MARK: UI
	public let picker = UIDatePicker()
	public let formatter = NSDateFormatter()
	
	//MARK: Content
	public override weak var delegate: UITextFieldDelegate? {
		get { return self }
		set { }
	}
	
	//MARK: - Init's
	
	convenience init() {
		self.init(frame: Frame.InitialFrame)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupUI()
	}
	
}

//MARK: - Initialization

public extension DateFloatingField {
	
	override func setup() {
		super.setup()
		setupUI()
	}
	
}

//MARK: - UI

private extension DateFloatingField {
	
	func setupUI() {
		rightView = UIImageView(image: Icon.Arrow.image().template())
		rightViewMode = .Always
		
		picker.addTarget(self, action: #selector(dateChanged), forControlEvents: .ValueChanged)
		inputView = picker
		
		textField.delegate = self
	}
	
	@objc
	func dateChanged() {
		text = formatter.stringFromDate(picker.date)
	}
	
}

//MARK: - UITextFieldDelegate

extension DateFloatingField: UITextFieldDelegate {
	
	public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		guard let dateFormat = formatter.dateFormat where !dateFormat.isEmpty else {
			fatalError("Oops! You forgot to provide a date format for the formatter property.")
		}
		
		dateChanged()
		return true
	}
	
	public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		return false
	}
	
}