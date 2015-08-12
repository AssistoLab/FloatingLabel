//
//  Helpers.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 4/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal func applyChanges(changes: Closure, animated: Bool, completion: Closure? = nil) {
	if animated {
		UIView.animateWithDuration(
			Animation.Duration,
			delay: 0,
			options: Animation.Options,
			animations: changes,
			completion: { finished in
				if finished,
					let completion = completion {
						completion()
				}
		})
	} else {
		changes()
		
		if let completion = completion {
			completion()
		}
	}
}