//
//  ActionFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 20/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

open class ActionFloatingField: FloatingTextField {
	
	//MARK: - Properties
	
	@objc open var action: Closure!
	
	open override weak var delegate: UITextFieldDelegate? {
		get { return self }
		set { }
	}
	
	//MARK: - Init's
	
	convenience init() {
		self.init(frame: Frame.initialFrame)
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}

//MARK: - Setup

extension ActionFloatingField {
	
	override open func setup() {
		super.setup()
		
		textField.disableEditionByUser()
		textField.delegate = self
	}
	
}

//MARK: - UITextFieldDelegate

extension ActionFloatingField: UITextFieldDelegate {
	
	public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		action()
		return false
	}
	
	open override var canBecomeFirstResponder: Bool {
		return false
	}
	
	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return false
	}
	
}
