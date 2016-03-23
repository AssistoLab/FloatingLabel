//
//  Constants.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 20/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal struct Frame {
	
	static let InitialFrame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 70)
	
}

internal struct FLoatingLabel {
	
	static let MinimumScaleFactor: CGFloat = 0.8
	static let NumberOfLines = 1
	static let AdjustsFontSizeToFitWidth = true
	
}

internal struct SingleChoiceText {
	
	static let NumberOfLines = 0
	
}

internal struct HelperLabel {
	
	static let NumberOfLines = 0
	
}

internal struct Animation {
	
	static let Duration: NSTimeInterval = 0.3
	static let Options: UIViewAnimationOptions = [.BeginFromCurrentState, .AllowUserInteraction, .LayoutSubviews]
	static let FloatingLabelTransform: CGAffineTransform = CGAffineTransformMakeTranslation(0, 10)
	
}

internal struct Constraints {
	
	static let HorizontalPadding: CGFloat = 10
	
	struct FloatingLabel {
		
		static let TopPadding: CGFloat = 15
		static let BottomPadding: CGFloat = 8
		
	}
	
	struct TextField {
		
		static let BottomPadding: CGFloat = 8
		
	}
	
	struct Separator {
		
		static let ActiveHeight: CGFloat = 1
		static let IdleHeight: CGFloat = 0.5
		static let BottomPadding: CGFloat = 8
		
	}
	
	struct Helper {
		
		static let HiddenHeight: CGFloat = 0
		static let HiddenBottomPadding: CGFloat = 0
		static let DisplayedBottomPadding: CGFloat = 8
		
	}
	
	struct PhoneField {
		
		struct Prefix {
			
			static let CompressionResistancePriority: Float = 1000
			static let VerticalHuggingPriority: Float = 0
			
		}
		
		struct Suffix {
			
			static let VerticalHuggingPriority: Float = 0
			
		}
		
	}
	
	struct SingleChoiceField {
		
		static let VerticalPadding: CGFloat = 8
		static let SwitchCompressionResistancePriority: Float = 1000
		
	}
	
}

internal enum Icon: String {
	case Arrow = "arrow"
 
	func image() -> UIImage {
		let bundle = NSBundle(identifier: "com.kevin.hirsch.FloatingLabel")!
		
		return UIImage(named: self.rawValue, inBundle: bundle, compatibleWithTraitCollection: nil)!
	}
}