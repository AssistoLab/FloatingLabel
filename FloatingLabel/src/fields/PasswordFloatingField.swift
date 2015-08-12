//
//  PasswordFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 8/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public class PasswordFloatingField: FloatingTextField {
	
	override internal func setup() {
		super.setup()
		passwordModeEnabled = true
	}
	
}