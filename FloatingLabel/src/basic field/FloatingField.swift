
import UIKit
import DropDown

internal enum HelperState {
	
	case hidden
	case help
	case error
	case warning
	
	init(level: ValidationLevel) {
		switch level {
		case .error:
			self = .error
		case .warning:
			self = .warning
		}
	}
	
}

@IBDesignable
open class FloatingField: UIView, TextFieldType, Helpable, Validatable {
	
	//MARK: - Properties
	
	//MARK: UI
	internal var floatingLabel = UILabel()
	internal var input: InputType!
	internal var separatorLine = UIView()
	internal var helperLabel = UILabel()
	
	override open var inputView: UIView? {
		get { return input.__inputView }
		set { input.__inputView = newValue }
	}
	
	//MARK: Constraints
	fileprivate var helperLabelHeightConstraint: NSLayoutConstraint!
	fileprivate weak var helperLabelBottomToSuperviewConstraint: NSLayoutConstraint!
	fileprivate weak var separatorLineHeightConstraint: NSLayoutConstraint!
	
	//MARK: Appearance
	@IBInspectable open dynamic var activeColor = UIColor.blue {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable open dynamic var idleColor = UIColor.lightGray {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable open dynamic var textColor = UIColor.black {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable open dynamic var floatingLabelColor = UIColor.gray {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable open dynamic var helpColor = UIColor.gray {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable open dynamic var errorColor = UIColor.red {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable open dynamic var warningColor = UIColor.orange {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable open dynamic var helperFont = UIFont.systemFont(ofSize: 13) {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable open dynamic var floatingLabelFont = UIFont.systemFont(ofSize: 12) {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable open dynamic var textFont = UIFont.systemFont(ofSize: 15) {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	//MARK: Content
	open var value: String? {
		get { return text }
		set { text = newValue }
	}
	
	open var valueChangedAction: ((String?) -> Void)?
	
	@IBInspectable open var helpText: String? {
		didSet { updateUI(animated: false) }
	}
	
	open var validations = [Validation]()
	
	open var validation: Validation? {
		get { return validations.first }
		set { validations.replaceFirstItemBy(newValue) }
	}
	
	internal var helperState = HelperState.hidden
	fileprivate var previousHelperState = HelperState.hidden
	internal var hasBeenEdited = false
	open var forceValidation = false
	
	fileprivate var isEmpty: Bool {
		return input.__text?.isEmpty ?? false
	}
	
	open var isEditing: Bool {
		return input.__editing
	}
	
	internal var isFloatingLabelDisplayed: Bool {
		return floatingLabel.alpha > 0
	}
	
	open var isValid: Bool {
		if !hasBeenEdited {
			return true
		} else {
			return checkValidity(text: text, validations: validations, level: .error).isValid
		}
	}
	
	fileprivate var didSetupConstraints = false
	
	//MARK: - Init's
	
	convenience init() {
		self.init(frame: Frame.initialFrame)
	}
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required public init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
		setup()
	}


	//MARK: - Update UI

	func updateUI(animated: Bool) {
		/* BEGIN HACK:
		* Avoid text in the textfield to jump when edition did finished
		* (Happened only the first time)
		* Happened because layoutIfNeeded is called in an animation few lines below
		*/
		layoutIfNeeded()
		/* END HACK */

		let changes: Closure = {
			self.updateGlobalUI()
			self.updateFloatingLabel()
			self.updateHelper()

			self.layoutIfNeeded()
		}

		applyChanges(changes, animated)
	}
	
}

//MARK: - Initialization

extension FloatingField {
	
	@objc open func setup() {
		setupUI()
	}
	
}

//MARK: - UI

extension FloatingField {
	
	fileprivate func setupUI() {
		updateConstraintsIfNeeded()
		
		#if TARGET_INTERFACE_BUILDER
			placeholder = "Floating label"
			text = "Some text"
		#endif
		
		customizeUI()
		updateUI(animated: false)
	}
	
	fileprivate func customizeUI() {
		floatingLabel.textColor = floatingLabelColor
		floatingLabel.font = floatingLabelFont
		floatingLabel.numberOfLines = FLoatingLabel.numberOfLines
		floatingLabel.adjustsFontSizeToFitWidth = FLoatingLabel.adjustsFontSizeToFitWidth
		floatingLabel.minimumScaleFactor = FLoatingLabel.minimumScaleFactor
		
		input.__textColor = textColor
		input.__font = textFont
		input.__tintColor = activeColor
		
		helperLabel.font = helperFont
		helperLabel.numberOfLines = HelperLabel.numberOfLines
		helperLabel.clipsToBounds = true
	}
	
	open override func updateConstraints() {
		if !didSetupConstraints {
			setupConstraints()
		}
		
		didSetupConstraints = true
		super.updateConstraints()
	}
	
	fileprivate func setupConstraints() {
		translatesAutoresizingMaskIntoConstraints = false
		
		// Floating label
		let floatingLabelContainer = UIView()
		let views = ["floatingLabel": floatingLabel]
		
		floatingLabelContainer.addSubview(floatingLabel)
		floatingLabel.translatesAutoresizingMaskIntoConstraints = false
		floatingLabelContainer.addConstraints(format: "V:|[floatingLabel]|", views: views)
		floatingLabelContainer.addConstraints(format: "H:|[floatingLabel]|", views: views)
		
		// Separator
		let separatorContainer = UIView()
		separatorContainer.addConstraints(
			format: "V:[separatorContainer(height)]",
			metrics: ["height": Constraints.Separator.activeHeight],
			views: ["separatorContainer": separatorContainer])
		
		separatorContainer.addSubview(separatorLine)
		separatorLine.translatesAutoresizingMaskIntoConstraints = false
		separatorContainer.addConstraints(format: "H:|[separatorLine]|", views: ["separatorLine": separatorLine])
		separatorContainer.addConstraint(NSLayoutConstraint(
			item: separatorLine,
			attribute: .centerY,
			relatedBy: .equal,
			toItem: separatorContainer,
			attribute: .centerY,
			multiplier: 1,
			constant: 0))
		separatorLineHeightConstraint = NSLayoutConstraint(
			item: separatorLine,
			attribute: .height,
			relatedBy: .equal,
			toItem: nil,
			attribute: .notAnAttribute,
			multiplier: 1,
			constant: Constraints.Separator.idleHeight)
		separatorLine.addConstraint(separatorLineHeightConstraint)
		
		// Helper label
		helperLabel.translatesAutoresizingMaskIntoConstraints = false
		helperLabelHeightConstraint = NSLayoutConstraint(
			item: helperLabel,
			attribute: .height,
			relatedBy: .equal,
			toItem: nil,
			attribute: .notAnAttribute,
			multiplier: 1,
			constant: Constraints.Helper.hiddenHeight)
		helperLabel.addConstraint(helperLabelHeightConstraint)
		
		// Global
		let metrics = ["padding": Constraints.horizontalPadding]
		
		// Horizontal
		addSubview(floatingLabelContainer)
		floatingLabelContainer.translatesAutoresizingMaskIntoConstraints = false
		addConstraints(
			format: "H:|-(padding)-[floatingLabelContainer]-(padding)-|",
			metrics: metrics,
			views: ["floatingLabelContainer": floatingLabelContainer])
		
		let inputAsView = input as! UIView
		
		addSubview(inputAsView)
		inputAsView.translatesAutoresizingMaskIntoConstraints = false
		addConstraints(
			format: "H:|-(padding)-[inputAsView]-(padding)-|",
			metrics: metrics,
			views: ["inputAsView": inputAsView])
		
		addSubview(separatorContainer)
		separatorContainer.translatesAutoresizingMaskIntoConstraints = false
		addConstraints(
			format: "H:|-(padding)-[separatorContainer]-(padding)-|",
			metrics: metrics,
			views: ["separatorContainer": separatorContainer])
		
		addSubview(helperLabel)
		addConstraints(
			format: "H:|-(padding)-[helperLabel]-(padding)-|",
			metrics: metrics,
			views: ["helperLabel": helperLabel])
		
		// Vertical
		addConstraints(
			format: "V:|-(labelTopPadding)-[label]-(labelBottomPadding)-[inputAsView]-(fieldBottomPadding)-[separator]-(separatorBottomPadding)-[helper]",
			metrics: [
				"labelTopPadding": Constraints.FloatingLabel.topPadding,
				"labelBottomPadding": Constraints.FloatingLabel.bottomPadding,
				"fieldBottomPadding": Constraints.TextField.bottomPadding,
				"separatorBottomPadding": Constraints.Separator.bottomPadding
			],
			views: [
				"label": floatingLabelContainer,
				"inputAsView": inputAsView,
				"separator": separatorContainer,
				"helper": helperLabel
			])
		
		helperLabelBottomToSuperviewConstraint = NSLayoutConstraint(item: self,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: helperLabel,
			attribute: .bottom,
			multiplier: 1,
			constant: Constraints.Helper.hiddenBottomPadding)
		addConstraint(helperLabelBottomToSuperviewConstraint)
	}
	
}

private extension FloatingField {
	
	//MARK: Global
	
	func updateGlobalUI() {
		let separatorHeight: CGFloat
		let separatorColor: UIColor
		
		if isEditing {
			separatorHeight = Constraints.Separator.activeHeight
			separatorColor = activeColor
		} else {
			separatorHeight = Constraints.Separator.idleHeight
			separatorColor = idleColor
		}
		
		separatorLineHeightConstraint.constant = separatorHeight
		separatorLine.backgroundColor = separatorColor
	}
	
	//MARK: Floating label
	
	func updateFloatingLabel() {
		if isEmpty {
			hideFloatingLabel()
		} else if !isFloatingLabelDisplayed {
			showFloatingLabel()
		}
	}
	
	func showFloatingLabel() {
		floatingLabel.transform = CGAffineTransform.identity
		floatingLabel.alpha = 1
	}
	
	func hideFloatingLabel() {
		floatingLabel.transform = Animation.floatingLabelTransform
		floatingLabel.alpha = 0
	}
	
	//MARK: Helper label
	
	func updateHelper() {
		let validationCheck = checkValidity(text: text, validations: validations, level: nil)
		
		if (!isEditing || forceValidation) && hasBeenEdited && !validationCheck.isValid,
			let failedValidation = validationCheck.failedValidation
		{
			previousHelperState = helperState
			helperState = HelperState(level: failedValidation.level)
		} else if !hasBeenEdited || validationCheck.isValid {
			previousHelperState = helperState
			helperState = baseHelperState(helpText)
		}
		
		forceValidation = false
		
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
		var separatorColor: UIColor? = nil
		var separatorHeight: CGFloat? = nil
		
		switch helperState {
		case .help:
			helperColor = helpColor
			
			if !isEditing {
				separatorColor = idleColor
				separatorHeight = Constraints.Separator.idleHeight
			}
		case .error:
			helperColor = errorColor
			separatorColor = errorColor
			separatorHeight = Constraints.Separator.activeHeight
		case .warning:
			helperColor = warningColor
			separatorColor = warningColor
			separatorHeight = Constraints.Separator.activeHeight
		case .hidden:
			return
		}
		
		if let helperColor = helperColor {
			helperLabel.textColor = helperColor
		}
		if let separatorColor = separatorColor {
			separatorLine.backgroundColor = separatorColor
		}
		if let separatorHeight = separatorHeight {
			separatorLineHeightConstraint.constant = separatorHeight
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

//MARK: - UIView (UIConstraintBasedLayoutLayering)

extension FloatingField {
	
	func contentWidth() -> CGFloat {
		let padding = Constraints.horizontalPadding * 2
		input.invalidateIntrinsicContentSize()
		
		return max(input.intrinsicContentSize.width + padding, 40)
	}
	
	override open var intrinsicContentSize : CGSize {
		let floatingLabelHeight = NSString(string: floatingLabel.text ?? "").boundingRect(
			with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
			options: NSStringDrawingOptions.usesLineFragmentOrigin,
			attributes: [NSAttributedStringKey.font: floatingLabelFont],
			context: nil).height
		let textHeight = input.intrinsicContentSize.height
		let spaces: CGFloat = 40
		let height = spaces + floatingLabelHeight + textHeight
		
		return CGSize(width: UIViewNoIntrinsicMetric, height: height)
	}
	
	override open func contentHuggingPriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority {
		switch axis {
		case .horizontal:
			return UILayoutPriority(rawValue: 250)
		case .vertical:
			return UILayoutPriority(rawValue: 1000)
		}
	}
	
	override open func contentCompressionResistancePriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority {
		switch axis {
		case .horizontal:
			return UILayoutPriority(rawValue: 750)
		case .vertical:
			return UILayoutPriority(rawValue: 1000)
		}
	}
	
	override open func forBaselineLayout() -> UIView {
		return input.forBaselineLayout()
	}
	
}

//MARK: - Touch events

extension FloatingField {
	
	// If self is tapped, we assume the user wants the textfield so we return it
	override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		if self.point(inside: point, with: event) {
			return input as? UIView
		} else {
			return super.hitTest(point, with: event)
		}
	}
	
}

//MARK: - Validation

public extension FloatingField {
	
	public func validate() {
		// Avoid skipping validation because text was not edited yet
		hasBeenEdited = true
		
		updateUI(animated: true)
	}
	
	public func validate(_ force: Bool) {
		// Avoid skipping validation because text was not edited yet
		hasBeenEdited = true
		
		forceValidation = force
		updateUI(animated: true)
	}
	
}

public func checkValidity(text: String?, validations: [Validation], level: ValidationLevel?) -> (isValid: Bool, failedValidation: Validation?) {
	for validation in validations {
		let shouldPassLevelValidation = level == nil
		let isWantedLevel = validation.level == level
		let isLevelValid = shouldPassLevelValidation || isWantedLevel
		
		if isLevelValid && !validation.isValid(text ?? "") {
			return (false, validation)
		}
	}
	
	return (true, nil)
}


//MARK: - Helpers

func baseHelperState(_ helpText: String?) -> HelperState {
	if let text = helpText, !text.isEmpty {
		return .help
	} else {
		return .hidden
	}
}

func helperText(_ text: String?, _ helperText: String?, _ previousHelperState: HelperState) -> String? {
	if text != helperText || previousHelperState == .hidden,
		let text = text, !text.isEmpty
	{
		return text
	} else {
		return nil
	}
}
