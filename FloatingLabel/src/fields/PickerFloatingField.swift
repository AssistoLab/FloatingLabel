//
//  PickerFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 22/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public class PickerFloatingField: FloatingTextField {
	
	//MARK: - Properties
	
	//MARK: UI
	private let picker = UIPickerView()
	
	//MARK: Content
	public var dataSource = [String]() {
		didSet { picker.reloadAllComponents() }
	}
	
	public override var delegate: UITextFieldDelegate? {
		get { return self }
		set { }
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

internal extension PickerFloatingField {
	
	override func setup() {
		rightView = UIImageView(image: Icon.Arrow.image().template())
		rightViewMode = .Always
		
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
	
	public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		let newIndex = picker.selectedRowInComponent(0)
		text = dataSource[newIndex]
		
		return true
	}
	
	public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		return false
	}
	
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension PickerFloatingField: UIPickerViewDataSource, UIPickerViewDelegate {
	
	public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return dataSource.count
	}
	
	public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
		return dataSource[row]
	}
	
	public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		text = dataSource[row]
	}
	
}