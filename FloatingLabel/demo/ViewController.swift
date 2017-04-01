//
//  ViewController.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 10/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet fileprivate weak var field: AutoCompleteFloatingField!
	@IBOutlet fileprivate weak var emailField: FloatingTextField!
	@IBOutlet fileprivate weak var phoneField: PhoneFloatingField!
	@IBOutlet fileprivate weak var dateField: DateFloatingField!
	@IBOutlet fileprivate weak var vehicleTypeField: ListFloatingField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let greenColor = UIColor(red: 0.1686, green: 0.8471, blue: 0.3961, alpha: 1.0)
		FloatingField.appearance().activeColor = greenColor
		
		Validation.messages[.required] = ("This field is required.", .error)
		Validation.messages[.emailAddress] = ("Incorrect email address (example: john@pinch.eu).", .error)
		Validation.messages[.phoneNumber] = ("Incorrect phone number.", .warning)
		
		setupFields()
	}
	
	func setupFields() {
		setupField()
		setupEmailField()
		setupPhoneField()
		setupDateField()
		setupVehicleTypeField()
	}
	
	func setupField() {
		field.placeholder = "You car's brand"
		field.dataSource = [
			"Ford",
			"Ferrari",
			"Mercedes",
			"Mercedes Benz",
			"Mercedes Cenz",
			"Mercedes Denz",
			"Mercedes Eenz",
			"Mercedes Fenz",
			"Mercedes Genz",
			"Mercedes Henz",
			"Lotus",
			"Lotus 1",
			"Lotidius",
			"Fiat",
			"Lamborghini",
			"BMW"
		]
	}
	
	func setupEmailField() {
//		emailField.placeholder = "Email Address"
	}
	
	func setupPhoneField() {
		phoneField.prefixPlaceholder = "Prefix"
		phoneField.suffixPlaceholder = "Phone number"
//		phoneField.errorText = "Incorrect phone number (example: +32 111 22 33 44)."
		
		phoneField.prefixHandler = { [unowned self] in
			self.phoneField.prefix = "+123"
		}
	}
	
	func setupDateField() {
		dateField.placeholder = "Date de naissance"
		dateField.picker.setDate(Date(), animated: false)
		dateField.picker.datePickerMode = .date
		dateField.formatter.dateStyle = .long
		dateField.formatter.timeStyle = .none
        dateField.valueChangedAction = { value in
            print("Value: \(value)")
        }
	}
	
	func setupVehicleTypeField() {
		vehicleTypeField.placeholder = "Type de véhicule"
		vehicleTypeField.dataSource = [
			"Voiture",
			"Moto",
			"Van",
			"Camion"
		]
		
		vehicleTypeField.validation = Validation(
			.custom({ (item) in
				return item != "Moto"
			}),
			message:  "Warning: Be careful if you have a motorcycle!",
			level: .warning)
		
	}
	
	//MARK: - Actions
	
	@IBAction func resign() {
		view.endEditing(false)
	}
	
	@IBAction func putText() {
		phoneField.text = "+32 494/40.81.18"
	}
	
}
