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
	
	public static var messages = [ValidationType: (message: String, level: ValidationLevel)]()
	public static var evaluations = [ValidationType: ValidationClosure]()
	
	public let type: ValidationType
	fileprivate var __message: String?
	fileprivate let __level: ValidationLevel?
	
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
			return .error
		}
	}

	public init(_ type: ValidationType, message: String? = nil, level: ValidationLevel? = .error) {
		self.type = type
		self.__message = message
		self.__level = level
	}
	
	public init(_ customClosure: @escaping ValidationClosure, message: String? = nil, level: ValidationLevel? = .error) {
		self.init(.custom(customClosure), message: message, level: level)
	}
	
	public func isValid(_ text: String) -> Bool {
		if let evaluation = Validation.evaluations[type] {
			return evaluation(text)
		} else {
			return type.evaluation(text)
		}
	}
	
}

//MARK: - ValidationType

public enum ValidationType {
	
	case required
	case emailAddress
	case phoneNumber
	case custom(ValidationClosure)
	
	fileprivate var evaluation: ValidationClosure {
		switch self {
		case .required:
			return { (text) in
				return !text.isEmpty
			}
		case .emailAddress:
			return { (text) in
				return text.isEmpty || DataValidationHelper.isValid(email: text)
			}
		case .phoneNumber:
			return { (text) in
				return text.isEmpty || DataValidationHelper.isValid(phone: text)
			}
		case let .custom(closure):
			return closure
		}
	}
	
}

//MARK: Hashable

extension ValidationType: Hashable {
	
	public var hashValue: Int {
		switch self {
		case .required:
			return 1
		case .emailAddress:
			return 2
		case .phoneNumber:
			return 3
		case .custom(_):
			return 4
		}
	}
	
}

public func ==(lhs: ValidationType, rhs: ValidationType) -> Bool {
	switch (lhs, rhs) {
	case (.custom, .custom):
		return false
	default:
		return lhs.hashValue == rhs.hashValue
	}
}

//MARK: - ValidationLevel

public enum ValidationLevel {
	
	case error
	case warning
	
}
