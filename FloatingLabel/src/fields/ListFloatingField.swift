//
//  ListFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 27/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

open class ListFloatingField: ActionFloatingField {

	//MARK: - Properties

	//MARK: UI
	open let dropDown = DropDown()

	//MARK: Content
	open var dataSource: [String] {
		get { return dropDown.dataSource }
		set { dropDown.dataSource = newValue }
	}

	/**
	The localization keys for the data source for the drop down.

	Changing this value automatically reloads the drop down.
	This has uses for setting accibility identifiers on the drop down cells (same ones as the localization keys).
	*/
	open var localizationKeysDataSource: [String] {
		get { return dropDown.localizationKeysDataSource }
		set { dropDown.localizationKeysDataSource = newValue }
	}

	open var selectedItem: String?

	open var selectedRow: Index? {
		get {
			return dropDown.indexForSelectedRow
		}
		set {
			if let newValue = newValue,
				newValue >= 0 && newValue < dataSource.count
			{
				dropDown.selectRow(at: newValue)
			} else {
				dropDown.deselectRow(at: newValue)
			}
		}
	}

	open override var isEditing: Bool {
		return editing
	}

	fileprivate var editing = false {
		didSet { updateUI(animated: true) }
	}

	open var willShowAction: Closure? {
		willSet {
			dropDown.willShowAction = newValue
		}
	}

	//MARK: - Init's

	convenience init() {
		self.init(frame: Frame.initialFrame)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

}

//MARK: - Initialization

extension ListFloatingField {

	open override func setup() {
		super.setup()

		rightView = UIImageView(image: Icon.Arrow.image().template())
		rightViewMode = .always

		setNeedsUpdateConstraints()

		dropDown.anchorView = self
		dropDown.topOffset = CGPoint(x: Constraints.horizontalPadding, y: -bounds.height)

		dropDown.selectionAction = { [unowned self] (index, item) in
			self.editing = false

			self.selectedItem = item
			self.selectedRow = index
			self.text = item

			self.valueChangedAction?(item)
		}

		dropDown.cancelAction = { [unowned self] in
			self.editing = false
		}

		action = { [unowned self] in
			self.editing = true
			self.dropDown.show()
		}
	}

}

//MARK: - Initialization

extension ListFloatingField {

	override open func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		
		//HACK: layoutIfNeeded is needed on iOS 10 for the 'bound' values to be correct
		// Follows answer found at: http://stackoverflow.com/a/39790074/2571566
		layoutIfNeeded()
		
		let separatorLineMinY = separatorLine.superview!.convert(separatorLine.frame, to: dropDown.anchorView?.plainView).minY - 1
		dropDown.bottomOffset = CGPoint(x: Constraints.horizontalPadding, y: separatorLineMinY)
		dropDown.width = separatorLine.bounds.width
	}

	override open func updateUI(animated: Bool) {
		super.updateUI(animated: animated)

		if isFloatingLabelDisplayed {
			dropDown.topOffset.y = -bounds.height
		} else {
			let floatingLabelMinY = floatingLabel.superview!.convert(floatingLabel.frame, to: dropDown.anchorView?.plainView).minY
			dropDown.topOffset.y = -bounds.height + floatingLabelMinY
		}
	}

}
