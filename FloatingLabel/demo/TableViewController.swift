//
//  TableViewController.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 11/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
	
	enum Cell: Int {
		
		case BasicField = 0
		case MultilineField
		case EmailField
		case PasswordlineField
		case ActionField
		case PhoneField
		case SingleChoiceField
		case PickerField
		case ListField
		case AutoCompletionField
		
	}
	
	@IBOutlet weak var basicTextField: FloatingTextField!
	@IBOutlet weak var multilineTextField: FloatingMultiLineTextField!
	@IBOutlet weak var emailField: EmailFloatingField!
	@IBOutlet weak var passwordField: PasswordFloatingField!
	@IBOutlet weak var actionField: ActionFloatingField!
	@IBOutlet weak var phoneField: PhoneFloatingField!
	@IBOutlet weak var singleChoiceField: SingleChoiceFloatingField!
	@IBOutlet weak var pickerField: PickerFloatingField!
	@IBOutlet weak var listField: ListFloatingField!
	@IBOutlet weak var autoCompletionField: AutoCompleteFloatingField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupBasicField()
		setupMultilineField()
		setupEmailField()
		setupPasswordField()
		setupActionField()
		setupPhoneField()
		setupSingleChoiceField()
		setupPickerField()
		setupListField()
		setupAutoCompletionField()
    }
	
//	override func viewDidAppear(animated: Bool) {
//		super.viewDidAppear(animated)
//		tableView.reloadData()
//	}
	
	func setupBasicField() {
		basicTextField.validations = [
			Validation(
				.Custom({ (text) in
					return text != "Test error"
				}),
				message: "Error: you wrote \"Test error\"",
				level: .Error
			),
			Validation(
				.Custom({ (text) in
					return text != "Test warning"
				}),
				message: "Warning: you wrote \"Test warning\"",
				level: .Warning
			)
		]
	}
	
	func setupMultilineField() {
		
	}
	
	func setupEmailField() {
		
	}
	
	func setupPasswordField() {
		
	}
	
	func setupActionField() {
		struct Static {
			static var counter = 0
		}
		
		actionField.action = { [unowned self] in
			self.actionField.text = "Click count: \(Static.counter + 1)"
		}
	}
	
	func setupPhoneField() {
		Validation.messages[.PhoneNumber] = ("Your phone number is incorrect. Please enter a correct format (eg. +32123456", .Error)
		
		struct Static {
			static var counter = 30
		}
		
		phoneField.prefixHandler = { [unowned self] in
			self.phoneField.prefix = "+\(Static.counter)"
			Static.counter += 1
		}
	}
	
	func setupSingleChoiceField() {
		
	}
	
	func setupPickerField() {
		pickerField.dataSource = [
			"Car",
			"Motorcycle",
			"Van",
			"Truck"
		]
	}
	
	func setupListField() {
		listField.dataSource = [
			"Car",
			"Motorcycle",
			"Van",
			"Truck"
		]
	}
	
	func setupAutoCompletionField() {
		autoCompletionField.dataSource = [
			"Ford",
			"Ferrari",
			"Mercedes",
			"Mercedes Benz",
			"Mercedes Cenz",
			"Mercedes Denz",
			"Lotus",
			"Lotus 1",
			"Lotidius",
			"Fiat",
			"Lamborghini",
			"BMW"
		]
	}
	
}

extension TableViewController {
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		let cell = Cell(rawValue: indexPath.row)
		let field = fieldForCell(cell)
		
		if let field = field {
			return field.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 1
		} else {
			return 44
		}
	}
	
	func fieldForCell(cell: Cell?) -> UIView? {
		if let cell = cell {
			switch cell {
			case .BasicField:
				return basicTextField
			case .MultilineField:
				return multilineTextField
			case .EmailField:
				return emailField
			case .PasswordlineField:
				return passwordField
			case .ActionField:
				return actionField
			case .PhoneField:
				return phoneField
			case .SingleChoiceField:
				return singleChoiceField
			case .PickerField:
				return pickerField
			case .ListField:
				return listField
			case .AutoCompletionField:
				return autoCompletionField
			}
		} else {
			return nil
		}
	}
	
}