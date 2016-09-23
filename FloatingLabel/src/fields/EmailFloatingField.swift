//
//  EmailFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 23/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

open class EmailFloatingField: FloatingTextField {
	
	override open func setup() {
		super.setup()
		
		keyboardType = .emailAddress
		autocapitalizationType = .none
		autocorrectionType = .no
		spellCheckingType = .no
		
		validation = Validation(.emailAddress)
	}
	
}
