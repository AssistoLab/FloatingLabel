//
//  ActionFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 20/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public class ActionFloatingField: FloatingTextField {
	
	//MARK: - Properties
	
	public var action: Closure!
	
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
	}
	
	required public init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}

//MARK: - Setup

internal extension ActionFloatingField {
	
	override func setup() {
		super.setup()
		
		textField.disableEditionByUser()
		textField.delegate = self
	}
	
}

//MARK: - UITextFieldDelegate

extension ActionFloatingField: UITextFieldDelegate {
	
	public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		action()
		return false
	}
	
	public override func canBecomeFirstResponder() -> Bool {
		return false
	}
	
	public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		return false
	}
	
}