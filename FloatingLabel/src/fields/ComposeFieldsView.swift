//
//  ComposeFieldsView.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 7/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

open class ComposeFieldsView: UIView, Validatable {
	
	//MARK: - Properties
	
	//MARK: UI
	open var contentView: UIView! {
		didSet {
			setupConstraints()
			updateUI(animated: false)
		}
	}
	
	fileprivate var helperLabel = UILabel()
	
	//MARK: Constraints
	fileprivate var helperLabelHeightConstraint: NSLayoutConstraint!
	fileprivate weak var helperLabelBottomToSuperviewConstraint: NSLayoutConstraint!
	
	//MARK: Content
	open var helpText: String? {
		didSet { updateUI(animated: false) }
	}
	
	//FIXME: change validation
	open var validations = [Validation]()
	
	open var validation: Validation? {
		get { return validations.first }
		set { validations.replaceFirstItemBy(newValue) }
	}
	
	internal var helperState = HelperState.hidden
	fileprivate var previousHelperState = HelperState.hidden
	
	open var isValid: Bool {
		return checkValidity(text: "", validations: validations, level: .error).isValid
	}
	
	fileprivate var failedValidation: Validation? {
		return checkValidity(text: "", validations: validations, level: .error).failedValidation
	}
	
}

//MARK: - UI

private extension ComposeFieldsView {
	
	func setupConstraints() {
		// Helper label
		helperLabel.font = FloatingField.appearance().helperFont
		helperLabel.numberOfLines = HelperLabel.numberOfLines
		helperLabel.clipsToBounds = true
		
		addSubview(helperLabel)
		helperLabel.translatesAutoresizingMaskIntoConstraints = false
		
		addConstraints(
			format: "H:|-(padding)-[helperLabel]-(padding)-|",
			metrics: ["padding": Constraints.horizontalPadding],
			views: ["helperLabel": helperLabel])
		
		helperLabelHeightConstraint = NSLayoutConstraint(
			item: helperLabel,
			attribute: .height,
			relatedBy: .equal,
			toItem: nil,
			attribute: .notAnAttribute,
			multiplier: 1,
			constant: Constraints.Helper.hiddenHeight)
		helperLabel.addConstraint(helperLabelHeightConstraint)
		
		helperLabelBottomToSuperviewConstraint = NSLayoutConstraint(item: self,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: helperLabel,
			attribute: .bottom,
			multiplier: 1,
			constant: Constraints.Helper.hiddenBottomPadding)
		addConstraint(helperLabelBottomToSuperviewConstraint)
		
		// Content view
		setupContentViewConstraints()
	}
	
	func setupContentViewConstraints() {
		addSubview(contentView)
		contentView.translatesAutoresizingMaskIntoConstraints = false
		
		addConstraints(format:"H:|[contentView]|", views: ["contentView": contentView])
		addConstraints(
			format: "V:|[contentView][helperLabel]",
			metrics: ["padding": Constraints.Separator.bottomPadding],
			views: [
				"helperLabel": helperLabel,
				"contentView": contentView
			])
	}
	
}

//MARK: - Update UI

internal extension ComposeFieldsView {
	
	func updateUI(animated: Bool) {
		let changes: Closure = {
			self.updateHelper()
			
			self.layoutIfNeeded()
		}
		
		applyChanges(changes, animated)
	}
	
}

private extension ComposeFieldsView {
	
	func updateHelper() {
		let validationCheck = checkValidity(text: "", validations: validations, level: nil)
		
		if !validationCheck.isValid,
			let failedValidation = validationCheck.failedValidation
		{
			previousHelperState = helperState
			helperState = HelperState(level: failedValidation.level)
		} else if isValid {
			previousHelperState = helperState
			helperState = baseHelperState(helpText)
		}
		
		updateHelperUI()
		
		switch helperState {
		case .help:
			if let text = helperText(helpText, helperLabel.text, previousHelperState) {
				showHelper(text: text)
			}
		case .error, .warning:
			let errorText = validationCheck.failedValidation?.message
			
			if let text = helperText(errorText, helperLabel.text, previousHelperState) {
				showHelper(text: text)
			}
		case .hidden:
			hideHelper()
		}
	}
	
	func updateHelperUI() {
		let helperColor: UIColor?
		
		switch helperState {
		case .help:
			helperColor = FloatingField.appearance().helpColor
		case .error:
			helperColor = FloatingField.appearance().errorColor
		case .warning:
			helperColor = FloatingField.appearance().warningColor
		case .hidden:
			return
		}
		
		if let helperColor = helperColor {
			helperLabel.textColor = helperColor
		}
	}
	
	func showHelper(text: String) {
		helperLabel.text = text
		
		if helperState == previousHelperState {
			return
		}
		
		performBatchUpdates { [unowned self] in
			self.helperLabel.alpha = 1
			self.helperLabel.removeConstraint(self.helperLabelHeightConstraint)
			self.helperLabelBottomToSuperviewConstraint.constant = Constraints.Helper.displayedBottomPadding
		}
	}
	
	func hideHelper() {
		if previousHelperState == .hidden {
			return
		}
		
		performBatchUpdates { [unowned self] in
			self.helperLabel.alpha = 0
			self.helperLabel.addConstraint(self.helperLabelHeightConstraint)
			self.helperLabelBottomToSuperviewConstraint.constant = Constraints.Helper.hiddenBottomPadding
		}
	}
	
}

//MARK: - Validation

public extension ComposeFieldsView {
	
	public func validate() {
		updateUI(animated: true)
	}
	
}
