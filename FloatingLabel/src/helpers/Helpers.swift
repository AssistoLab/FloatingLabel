//
//  Helpers.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 4/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

internal func applyChanges(changes: Closure, _ animated: Bool, _ completion: Closure? = nil) {
	dispatch_async(dispatch_get_main_queue()) {
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
			// Animation of 0 seconds to cancel previous animations
			UIView.animateWithDuration(0) {
				changes()
				
				if let completion = completion {
					completion()
				}
			}
		}
	}
}