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
		
		case basicField = 0
		case multilineField
		case emailField
		case passwordlineField
		case actionField
		case phoneField
		case singleChoiceField
		case pickerField
		case listField
		case autoCompletionField
		
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
				.custom({ (text) in
					return text != "Test error"
				}),
				message: "Error: you wrote \"Test error\"",
				level: .error
			),
			Validation(
				.custom({ (text) in
					return text != "Test warning"
				}),
				message: "Warning: you wrote \"Test warning\"",
				level: .warning
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
		Validation.messages[.phoneNumber] = ("Your phone number is incorrect. Please enter a correct format (eg. +32123456", .error)
		
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
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let cell = Cell(rawValue: indexPath.row)
		let field = fieldForCell(cell)
		
		if let field = field {
			return field.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + 1
		} else {
			return 44
		}
	}
	
	func fieldForCell(_ cell: Cell?) -> UIView? {
		if let cell = cell {
			switch cell {
			case .basicField:
				return basicTextField
			case .multilineField:
				return multilineTextField
			case .emailField:
				return emailField
			case .passwordlineField:
				return passwordField
			case .actionField:
				return actionField
			case .phoneField:
				return phoneField
			case .singleChoiceField:
				return singleChoiceField
			case .pickerField:
				return pickerField
			case .listField:
				return listField
			case .autoCompletionField:
				return autoCompletionField
			}
		} else {
			return nil
		}
	}
	
}
