//
//  PickerFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 22/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

open class PickerFloatingField: FloatingTextField {
	
	//MARK: - Properties
	
	//MARK: UI
	fileprivate let picker = UIPickerView()
	
	//MARK: Content
	open var dataSource = [String]() {
		didSet { picker.reloadAllComponents() }
	}
	
	open override var delegate: UITextFieldDelegate? {
		get { return self }
		set { }
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

public extension PickerFloatingField {
	
	override func setup() {
		rightView = UIImageView(image: Icon.Arrow.image().template())
		rightViewMode = .always
		
		picker.dataSource = self
		picker.delegate = self
		inputView = picker
		
		textField.disableEditionByUser()
		textField.delegate = self
		
		super.setup()
	}
	
}

//MARK: - UITextFieldDelegate

extension PickerFloatingField: UITextFieldDelegate {
	
	public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		let newIndex = picker.selectedRow(inComponent: 0)
		text = dataSource[newIndex]
		
		return true
	}
	
	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return false
	}
	
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension PickerFloatingField: UIPickerViewDataSource, UIPickerViewDelegate {
	
	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return dataSource.count
	}
	
	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return dataSource[row]
	}
	
	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		text = dataSource[row]
	}
	
}
