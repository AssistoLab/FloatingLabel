//
//  ViewController.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 10/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet private weak var field: AutoCompleteFloatingField!
	@IBOutlet private weak var emailField: FloatingTextField!
	@IBOutlet private weak var phoneField: PhoneFloatingField!
	@IBOutlet private weak var dateField: DateFloatingField!
	@IBOutlet private weak var vehicleTypeField: ListFloatingField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let greenColor = UIColor(red: 0.1686, green: 0.8471, blue: 0.3961, alpha: 1.0)
		FloatingField.appearance().activeColor = greenColor
		FloatingField.appearance().warningColor = UIColor.yellowColor()
		
		Validation.messages[.Required] = ("This field is required.", .Error)
		Validation.messages[.EmailAddress] = ("Incorrect email address (example: john@pinch.eu).", .Error)
		Validation.messages[.PhoneNumber] = ("Incorrect phone number.", .Warning)
		
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
		dateField.picker.setDate(NSDate(), animated: false)
		dateField.picker.datePickerMode = .Date
		dateField.formatter.dateStyle = .LongStyle
		dateField.formatter.timeStyle = .NoStyle
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
			.Custom({ (item) in
				return item != "Moto"
			}),
			message:  "Cannot be a moto",
			level: .Warning)
		
	}
	
	//MARK: - Actions
	
	@IBAction func resign() {
		view.endEditing(false)
	}
	
	@IBAction func putText() {
		phoneField.text = "+32 494/40.81.18"
	}
	
}