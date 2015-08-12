//
//  Array+Extension.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 11/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal extension Array {
	
	mutating func replaceFirstItemBy(item: T?) {
		let isEmpty = count <= 0
		
		if let item = item {
			if isEmpty {
				append(item)
			} else {
				self[0] = item
			}
		} else if !isEmpty {
			removeAtIndex(0)
		}
	}
	
}
