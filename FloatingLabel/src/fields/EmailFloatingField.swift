//
//  EmailFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 23/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public class EmailFloatingField: FloatingTextField {
	
	override public func setup() {
		super.setup()
		
		keyboardType = .EmailAddress
		autocapitalizationType = .None
		autocorrectionType = .No
		spellCheckingType = .No
		
		validation = Validation(.EmailAddress)
	}
	
}