//
//  DateFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 22/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

open class DateFloatingField: FloatingTextField {
	
	//MARK: - Properties
	
	//MARK: UI
	open let picker = UIDatePicker()
	open let formatter = DateFormatter()
	
	//MARK: Content
	open override weak var delegate: UITextFieldDelegate? {
		get { return self }
		set { }
	}
	
	//MARK: - Init's
	
	convenience init() {
		self.init(frame: Frame.initialFrame)
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
		rightViewMode = .always
		
		picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
		inputView = picker
		
		textField.delegate = self
	}
	
	@objc
	func dateChanged() {
		text = formatter.string(from: picker.date)
	}
	
}

//MARK: - UITextFieldDelegate

extension DateFloatingField: UITextFieldDelegate {
	
	public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		guard let dateFormat = formatter.dateFormat, !dateFormat.isEmpty else {
			fatalError("Oops! You forgot to provide a date format for the formatter property.")
		}
		
		dateChanged()
		return true
	}
	
	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return false
	}
	
}
