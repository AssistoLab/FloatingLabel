//
//  ValidationType.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 17/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import Foundation

public typealias ValidationClosure = (String) -> Bool

public struct Validation {
	
	public static var messages = [ValidationType: (String, ValidationLevel)]()
	public static var evaluations = [ValidationType: ValidationClosure]()
	
	public let type: ValidationType
	private var __message: String?
	private let __level: ValidationLevel?
	
	public var message: String? {
		get {
			if let message = __message {
				return message
			} else if let (message, _) = Validation.messages[type] {
				return message
			} else {
				return nil
			}
		}
		set {
			__message = newValue
		}
	}
	
	public var level: ValidationLevel {
		if let level = __level {
			return level
		} else if let (_, level) = Validation.messages[type] {
			return level
		} else {
			return .Error
		}
	}

	init(_ type: ValidationType, message: String? = nil, level: ValidationLevel? = .Error) {
		self.type = type
		self.__message = message
		self.__level = level
	}
	
	init(_ customClosure: ValidationClosure, message: String? = nil, level: ValidationLevel? = .Error) {
		self.init(.Custom(customClosure), message: message, level: level)
	}
	
	public func isValid(text: String) -> Bool {
		if let evaluation = Validation.evaluations[type] {
			return evaluation(text)
		} else {
			return type.evaluation(text)
		}
	}
	
}

//MARK: - ValidationType

public enum ValidationType {
	
	case Required
	case EmailAddress
	case PhoneNumber
	case Custom(ValidationClosure)
	
	private var evaluation: ValidationClosure {
		switch self {
		case .Required:
			return { (text) in
				return !text.isEmpty
			}
		case .EmailAddress:
			return { (text) in
				return text.isEmpty || DataValidationHelper.isAddressEmailValid(text)
			}
		case .PhoneNumber:
			return { (text) in
				return text.isEmpty || DataValidationHelper.isPhoneNumberValid(text)
			}
		case let .Custom(closure):
			return closure
		}
	}
	
}

//MARK: Hashable

extension ValidationType: Hashable {
	
	public var hashValue: Int {
		switch self {
		case .Required:
			return 1
		case .EmailAddress:
			return 2
		case .PhoneNumber:
			return 3
		case .Custom(_):
			return 4
		}
	}
	
}

public func ==(lhs: ValidationType, rhs: ValidationType) -> Bool {
	switch (lhs, rhs) {
	case (.Custom, .Custom):
		return false
	default:
		return lhs.hashValue == rhs.hashValue
	}
}

//MARK: - ValidationLevel

public enum ValidationLevel {
	
	case Error
	case Warning
	
}