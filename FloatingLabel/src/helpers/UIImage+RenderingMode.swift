//
//  UIImage+RenderingMode.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 7/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal extension UIImage {
	
	func original() -> UIImage {
		return withRenderingMode(.alwaysOriginal)
	}
	
	func template() -> UIImage {
		return withRenderingMode(.alwaysTemplate)
	}
	
}
