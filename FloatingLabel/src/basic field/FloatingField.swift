
import UIKit

internal enum HelperState {
	
	case Hidden
	case Help
	case Error
	case Warning
	
	init(level: ValidationLevel) {
		switch level {
		case .Error:
			self = Error
		case .Warning:
			self = .Warning
		}
	}
	
}

@IBDesignable
public class FloatingField: UIView, TextFieldType, Helpable, Validatable {
	
	//MARK: - Properties
	
	//MARK: UI
	internal var floatingLabel = UILabel()
	internal var input: InputType!
	internal var separatorLine = UIView()
	internal var helperLabel = UILabel()
	
	override public var inputView: UIView? {
		get { return input.__inputView }
		set { input.__inputView = newValue }
	}
	
	//MARK: Constraints
	private var helperLabelHeightConstraint: NSLayoutConstraint!
	private weak var helperLabelBottomToSuperviewConstraint: NSLayoutConstraint!
	private weak var separatorLineHeightConstraint: NSLayoutConstraint!
	
	//MARK: Appearance
	@IBInspectable public dynamic var activeColor: UIColor = UIColor.blueColor() {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable public dynamic var idleColor: UIColor = UIColor.lightGrayColor() {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable public dynamic var textColor: UIColor = UIColor.blackColor() {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable public dynamic var floatingLabelColor: UIColor = UIColor.grayColor() {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable public dynamic var helpColor: UIColor = UIColor.grayColor() {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable public dynamic var errorColor: UIColor = UIColor.redColor() {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable public dynamic var warningColor: UIColor = UIColor.orangeColor() {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable public dynamic var helperFont = UIFont.systemFontOfSize(13) {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable public dynamic var floatingLabelFont = UIFont.systemFontOfSize(12) {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	@IBInspectable public dynamic var textFont = UIFont.systemFontOfSize(15) {
		didSet {
			customizeUI()
			updateUI(animated: false)
		}
	}
	
	//MARK: Content
	public var value: String? {
		get { return text }
		set { text = newValue }
	}
	
	public var valueChangedAction: ((String?) -> Void)?
	
	@IBInspectable public var helpText: String? {
		didSet { updateUI(animated: false) }
	}
	
	public var validations = [Validation]()
	
	public var validation: Validation? {
		get { return validations.first }
		set { validations.replaceFirstItemBy(newValue) }
	}
	
	internal var helperState = HelperState.Hidden
	private var previousHelperState = HelperState.Hidden
	internal var hasBeenEdited = false
	
	private var isEmpty: Bool {
		return input.__text?.isEmpty ?? false
	}
	
	public var isEditing: Bool {
		return input.__editing
	}
	
	internal var isFloatingLabelDisplayed: Bool {
		return floatingLabel.alpha > 0
	}
	
	public var isValid: Bool {
		if !hasBeenEdited {
			return true
		} else {
			return checkValidity(text: text, validations: validations, level: .Error).isValid
		}
	}
	
	public var failedValidation: Validation? {
		return checkValidity(text: "", validations: validations, level: .Error).failedValidation
	}
	
	private var didSetupConstraints = false
	
	//MARK: - Init's
	
	convenience init() {
		self.init(frame: Frame.InitialFrame)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required public init(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
		setup()
	}
	
}

//MARK: - Initialization

internal extension FloatingField {
	
	func setup() {
		setupUI()
	}
	
}

//MARK: - UI

extension FloatingField {
	
	private func setupUI() {
		updateConstraintsIfNeeded()
		
		#if TARGET_INTERFACE_BUILDER
			placeholder = "Floating label"
			text = "Some text"
		#endif
		
		customizeUI()
		updateUI(animated: false)
	}
	
	private func customizeUI() {
		floatingLabel.textColor = floatingLabelColor
		floatingLabel.font = floatingLabelFont
		floatingLabel.numberOfLines = FLoatingLabel.NumberOfLines
		floatingLabel.adjustsFontSizeToFitWidth = FLoatingLabel.AdjustsFontSizeToFitWidth
		floatingLabel.minimumScaleFactor = FLoatingLabel.MinimumScaleFactor
		
		input.__textColor = textColor
		input.__font = textFont
		input.__tintColor = activeColor
		
		helperLabel.font = helperFont
		helperLabel.numberOfLines = HelperLabel.NumberOfLines
		helperLabel.clipsToBounds = true
	}
	
	public override func updateConstraints() {
		if !didSetupConstraints {
			setupConstraints()
		}
		
		didSetupConstraints = true
		super.updateConstraints()
	}
	
	private func setupConstraints() {
		setTranslatesAutoresizingMaskIntoConstraints(false)
		
		// Floating label
		let floatingLabelContainer = UIView()
		let views = ["floatingLabel": floatingLabel]
		
		floatingLabelContainer.addSubview(floatingLabel)
		floatingLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
		floatingLabelContainer.addConstraints(format: "V:|[floatingLabel]|", views: views)
		floatingLabelContainer.addConstraints(format: "H:|[floatingLabel]|", views: views)
		
		// Separator
		let separatorContainer = UIView()
		separatorContainer.addConstraints(
			format: "V:[separatorContainer(height)]",
			metrics: ["height": Constraint.Separator.ActiveHeight],
			views: ["separatorContainer": separatorContainer])
		
		separatorContainer.addSubview(separatorLine)
		separatorLine.setTranslatesAutoresizingMaskIntoConstraints(false)
		separatorContainer.addConstraints(format: "H:|[separatorLine]|", views: ["separatorLine": separatorLine])
		separatorContainer.addConstraint(NSLayoutConstraint(
			item: separatorLine,
			attribute: .CenterY,
			relatedBy: .Equal,
			toItem: separatorContainer,
			attribute: .CenterY,
			multiplier: 1,
			constant: 0))
		separatorLineHeightConstraint = NSLayoutConstraint(
			item: separatorLine,
			attribute: .Height,
			relatedBy: .Equal,
			toItem: nil,
			attribute: .NotAnAttribute,
			multiplier: 1,
			constant: Constraint.Separator.IdleHeight)
		separatorLine.addConstraint(separatorLineHeightConstraint)
		
		// Helper label
		helperLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
		helperLabelHeightConstraint = NSLayoutConstraint(
			item: helperLabel,
			attribute: .Height,
			relatedBy: .Equal,
			toItem: nil,
			attribute: .NotAnAttribute,
			multiplier: 1,
			constant: Constraint.Helper.HiddenHeight)
		helperLabel.addConstraint(helperLabelHeightConstraint)
		
		// Global
		let metrics = ["padding": Constraint.HorizontalPadding]
		
		// Horizontal
		addSubview(floatingLabelContainer)
		floatingLabelContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
		addConstraints(
			format: "H:|-(padding)-[floatingLabelContainer]-(padding)-|",
			metrics: metrics,
			views: ["floatingLabelContainer": floatingLabelContainer])
		
		let inputAsView = input as! UIView
		
		addSubview(inputAsView)
		inputAsView.setTranslatesAutoresizingMaskIntoConstraints(false)
		addConstraints(
			format: "H:|-(padding)-[inputAsView]-(padding)-|",
			metrics: metrics,
			views: ["inputAsView": inputAsView])
		
		addSubview(separatorContainer)
		separatorContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
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
				"labelTopPadding": Constraint.FloatingLabel.TopPadding,
				"labelBottomPadding": Constraint.FloatingLabel.BottomPadding,
				"fieldBottomPadding": Constraint.TextField.BottomPadding,
				"separatorBottomPadding": Constraint.Separator.BottomPadding
			],
			views: [
				"label": floatingLabelContainer,
				"inputAsView": inputAsView,
				"separator": separatorContainer,
				"helper": helperLabel
			])
		
		helperLabelBottomToSuperviewConstraint = NSLayoutConstraint(item: self,
			attribute: .Bottom,
			relatedBy: .Equal,
			toItem: helperLabel,
			attribute: .Bottom,
			multiplier: 1,
			constant: Constraint.Helper.HiddenBottomPadding)
		addConstraint(helperLabelBottomToSuperviewConstraint)
	}
	
}

//MARK: - Update UI

internal extension FloatingField {
	
	func updateUI(#animated: Bool) {
		/* BEGIN HACK:
		 * Avoid text in the textfield to jump when edition did finished 
		 * (Happened only the first time)
		 * Happened because layoutIfNeeded is called in an animation few lines below
		*/
		layoutIfNeeded()
		/* END HACK */
		
		let changes: Closure = { [unowned self] in
			self.updateGlobalUI()
			self.updateFloatingLabel()
			self.updateHelper()
			
			self.layoutIfNeeded()
		}
		
		applyChanges(changes, animated)
	}
	
}

private extension FloatingField {
	
	//MARK: Global
	
	func updateGlobalUI() {
		let separatorHeight: CGFloat
		let separatorColor: UIColor
		
		if isEditing {
			separatorHeight = Constraint.Separator.ActiveHeight
			separatorColor = activeColor
		} else {
			separatorHeight = Constraint.Separator.IdleHeight
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
		floatingLabel.transform = CGAffineTransformIdentity
		floatingLabel.alpha = 1
	}
	
	func hideFloatingLabel() {
		floatingLabel.transform = Animation.FloatingLabelTransform
		floatingLabel.alpha = 0
	}
	
	//MARK: Helper label
	
	func updateHelper() {
		let validationCheck = checkValidity(text: text, validations: validations, level: nil)
		
		if !isEditing && !validationCheck.isValid,
			let failedValidation = validationCheck.failedValidation
		{
			previousHelperState = helperState
			helperState = HelperState(level: failedValidation.level)
		} else if validationCheck.isValid {
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
		var separatorColor: UIColor? = nil
		var separatorHeight: CGFloat? = nil
		
		switch helperState {
		case .Help:
			helperColor = helpColor
			
			if !isEditing {
				separatorColor = idleColor
				separatorHeight = Constraint.Separator.IdleHeight
			}
		case .Error:
			helperColor = errorColor
			separatorColor = errorColor
			separatorHeight = Constraint.Separator.ActiveHeight
		case .Warning:
			helperColor = warningColor
			separatorColor = warningColor
			separatorHeight = Constraint.Separator.ActiveHeight
		case .Hidden:
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
	
	func showHelper(#text: String) {
		helperLabel.text = text
		
		if helperState == previousHelperState {
			return
		}
		
		performBatchUpdates { [unowned self] in
			self.helperLabel.alpha = 1
			self.helperLabel.removeConstraint(self.helperLabelHeightConstraint)
			self.helperLabelBottomToSuperviewConstraint.constant = Constraint.Helper.DisplayedBottomPadding
		}
	}
	
	func hideHelper() {
		if previousHelperState == .Hidden {
			return
		}
		
		performBatchUpdates { [unowned self] in
			self.helperLabel.alpha = 0
			self.helperLabel.addConstraint(self.helperLabelHeightConstraint)
			self.helperLabelBottomToSuperviewConstraint.constant = Constraint.Helper.HiddenBottomPadding
		}
	}
	
}

//MARK: - UIView (UIConstraintBasedLayoutLayering)

public extension FloatingField {
	
	func contentWidth() -> CGFloat {
		let padding = Constraint.HorizontalPadding * 2
		input.invalidateIntrinsicContentSize()
		
		return max(input.intrinsicContentSize().width + padding, 40)
	}
	
	override func intrinsicContentSize() -> CGSize {
		return CGSize(width: UIViewNoIntrinsicMetric, height: 73)
	}
	
	override func contentHuggingPriorityForAxis(axis: UILayoutConstraintAxis) -> UILayoutPriority {
		switch axis {
		case .Horizontal:
			return 250
		case .Vertical:
			return 1000
		}
	}
	
	override func contentCompressionResistancePriorityForAxis(axis: UILayoutConstraintAxis) -> UILayoutPriority {
		switch axis {
		case .Horizontal:
			return 750
		case .Vertical:
			return 1000
		}
	}
	
	override func viewForBaselineLayout() -> UIView? {
		return input.viewForBaselineLayout()
	}
	
}

//MARK: - Touch events

public extension FloatingField {
	
	// If self is tapped, we assume the user wants the textfield so we return it
	override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		if pointInside(point, withEvent: event) {
			return input as? UIView
		} else {
			return super.hitTest(point, withEvent: event)
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
	
}

internal func checkValidity(#text: String?, #validations: [Validation], #level: ValidationLevel?) -> (isValid: Bool, failedValidation: Validation?) {
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

func baseHelperState(helpText: String?) -> HelperState {
	if let text = helpText where !text.isEmpty {
		return .Help
	} else {
		return .Hidden
	}
}

func helperText(text: String?, helperText: String?, previousHelperState: HelperState) -> String? {
	if text != helperText || previousHelperState == .Hidden,
		let text = text where !text.isEmpty
	{
		return text
	} else {
		return nil
	}
}