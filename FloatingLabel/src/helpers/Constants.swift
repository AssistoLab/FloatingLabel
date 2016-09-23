//
//  Constants.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 20/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal struct Frame {
	
	static let initialFrame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 70)
	
}

internal struct FLoatingLabel {
	
	static let minimumScaleFactor: CGFloat = 0.8
	static let numberOfLines = 1
	static let adjustsFontSizeToFitWidth = true
	
}

internal struct SingleChoiceText {
	
	static let numberOfLines = 0
	
}

internal struct HelperLabel {
	
	static let numberOfLines = 0
	
}

internal struct Animation {
	
	static let duration: TimeInterval = 0.3
	static let options: UIViewAnimationOptions = [.beginFromCurrentState, .allowUserInteraction, .layoutSubviews]
	static let floatingLabelTransform = CGAffineTransform(translationX: 0, y: 10)
	
}

public struct Constraints {
	
	public static var horizontalPadding: CGFloat = 15
	
	struct FloatingLabel {
		
		static let topPadding: Float = 15
		static let bottomPadding: Float = 8
		
	}
	
	struct TextField {
		
		static let bottomPadding: CGFloat = 8
		
	}
	
	struct Separator {
		
		static let activeHeight: CGFloat = 1
		static let idleHeight: CGFloat = 0.5
		static let bottomPadding: CGFloat = 8
		
	}
	
	struct Helper {
		
		static let hiddenHeight: CGFloat = 0
		static let hiddenBottomPadding: CGFloat = 0
		static let displayedBottomPadding: CGFloat = 8
		
	}
	
	struct PhoneField {
		
		struct Prefix {
			
			static let compressionResistancePriority: Float = 1000
			static let verticalHuggingPriority: Float = 0
			
		}
		
		struct Suffix {
			
			static let verticalHuggingPriority: Float = 0
			
		}
		
	}
	
	struct SingleChoiceField {
		
		static let verticalPadding: Float = 8
		static let switchCompressionResistancePriority: Float = 1000
		
	}
	
}

internal enum Icon: String {
	case Arrow = "arrow"
 
	func image() -> UIImage {
		let bundle = Bundle(for: FloatingField.self)
		
		guard let bundleURL = bundle.url(forResource: "FloatingLabel", withExtension: "bundle") else {
			return UIImage(named: self.rawValue)!
		}
		
		let resourceBundle = Bundle(url: bundleURL)
		
		return UIImage(named: self.rawValue, in: resourceBundle, compatibleWith: nil)!
	}
}
