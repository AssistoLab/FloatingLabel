//
//  PasswordFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 8/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

open class PasswordFloatingField: FloatingTextField {
	
	override open func setup() {
		super.setup()
		passwordModeEnabled = true
	}
	
}
