//
//  Helpers.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 4/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

internal func applyChanges(_ changes: @escaping Closure, _ animated: Bool, _ completion: Closure? = nil) {
	DispatchQueue.main.async {
		if animated {
			UIView.animate(
				withDuration: Animation.duration,
				delay: 0,
				options: Animation.options,
				animations: changes,
				completion: { finished in
					if finished,
						let completion = completion {
							completion()
					}
			})
		} else {
			// Animation of 0 seconds to cancel previous animations
			UIView.animate(withDuration: 0) {
				changes()
				
				if let completion = completion {
					completion()
				}
			}
		}
	}
}
