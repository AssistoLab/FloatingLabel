//
//  EmailFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 23/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public class EmailFloatingField: FloatingTextField {
	
	override internal func setup() {
		super.setup()
		
		textField.keyboardType = .EmailAddress
		textField.autocapitalizationType = .None
		textField.autocorrectionType = .No
		textField.spellCheckingType = .No
		
		validation = Validation(.EmailAddress)
	}
	
}