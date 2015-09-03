//
//  ComposeFieldsView.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 7/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public class ComposeFieldsView: UIView, Validatable {
	
	//MARK: - Properties
	
	//MARK: UI
	public var contentView: UIView! {
		didSet { setupConstraints() }
	}
	
	private var helperLabel = UILabel()
	
	//MARK: Constraints
	private var helperLabelHeightConstraint: NSLayoutConstraint!
	private weak var helperLabelBottomToSuperviewConstraint: NSLayoutConstraint!
	
	//MARK: Content
	public var helpText: String? {
		didSet { updateUI(animated: false) }
	}
	
	//FIXME: change validation
	public var validations = [Validation]()
	
	public var validation: Validation? {
		get { return validations.first }
		set { validations.replaceFirstItemBy(newValue) }
	}
	
	internal var helperState = HelperState.Hidden
	private var previousHelperState = HelperState.Hidden
	
	public var isValid: Bool {
		return checkValidity(text: "", validations: validations, level: .Error).isValid
	}
	
	private var failedValidation: Validation? {
		return checkValidity(text: "", validations: validations, level: .Error).failedValidation
	}
	
}

//MARK: - UI

private extension ComposeFieldsView {
	
	func setupConstraints() {
		// Helper label
		helperLabel.font = FloatingField.appearance().helperFont
		helperLabel.numberOfLines = HelperLabel.NumberOfLines
		helperLabel.clipsToBounds = true
		
		addSubview(helperLabel)
		helperLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
		
		addConstraints(
			format: "H:|-(padding)-[helperLabel]-(padding)-|",
			metrics: ["padding": Constraints.HorizontalPadding],
			views: ["helperLabel": helperLabel])
		
		helperLabelHeightConstraint = NSLayoutConstraint(
			item: helperLabel,
			attribute: .Height,
			relatedBy: .Equal,
			toItem: nil,
			attribute: .NotAnAttribute,
			multiplier: 1,
			constant: Constraints.Helper.HiddenHeight)
		helperLabel.addConstraint(helperLabelHeightConstraint)
		
		helperLabelBottomToSuperviewConstraint = NSLayoutConstraint(item: self,
			attribute: .Bottom,
			relatedBy: .Equal,
			toItem: helperLabel,
			attribute: .Bottom,
			multiplier: 1,
			constant: Constraints.Helper.HiddenBottomPadding)
		addConstraint(helperLabelBottomToSuperviewConstraint)
		
		// Content view
		setupContentViewConstraints()
	}
	
	func setupContentViewConstraints() {
		addSubview(contentView)
		contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
		
		addConstraints(format:"H:|[contentView]|", views: ["contentView": contentView])
		addConstraints(
			format: "V:|[contentView][helperLabel]",
			metrics: ["padding": Constraints.Separator.BottomPadding],
			views: [
				"helperLabel": helperLabel,
				"contentView": contentView
			])
	}
	
}

//MARK: - Update UI

internal extension ComposeFieldsView {
	
	func updateUI(#animated: Bool) {
		let changes: Closure = { [unowned self] in
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
		case .Help:
			if let text = helperText(helpText, helperLabel.text, previousHelperState) {
				showHelper(text: text)
			}
		case .Error, .Warning:
			let errorText = validationCheck.failedValidation?.message
			
			if let text = helperText(errorText, helperLabel.text, previousHelperState) {
				showHelper(text: text)
			}
		case .Hidden:
			hideHelper()
		}
	}
	
	func updateHelperUI() {
		let helperColor: UIColor?
		
		switch helperState {
		case .Help:
			helperColor = FloatingField.appearance().helpColor
		case .Error:
			helperColor = FloatingField.appearance().errorColor
		case .Warning:
			helperColor = FloatingField.appearance().warningColor
		case .Hidden:
			return
		}
		
		if let helperColor = helperColor {
			helperLabel.textColor = helperColor
		}
	}
	
	func showHelper(#text: String) {
		helperLabel.text = text
		
		if helperState == previousHelperState {
			return
		}
		
		performBatchUpdates { [unowned self] in
			self.helperLabel.alpha = 1
			self.helperLabel.removeConstraint(self.helperLabelHeightConstraint)
			self.helperLabelBottomToSuperviewConstraint.constant = Constraints.Helper.DisplayedBottomPadding
		}
	}
	
	func hideHelper() {
		if previousHelperState == .Hidden {
			return
		}
		
		performBatchUpdates { [unowned self] in
			self.helperLabel.alpha = 0
			self.helperLabel.addConstraint(self.helperLabelHeightConstraint)
			self.helperLabelBottomToSuperviewConstraint.constant = Constraints.Helper.HiddenBottomPadding
		}
	}
	
}

//MARK: - Validation

public extension ComposeFieldsView {
	
	public func validate() {
		updateUI(animated: true)
	}
	
}