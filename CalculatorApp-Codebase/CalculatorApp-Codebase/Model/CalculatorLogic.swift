//
//  CalculatorLogic.swift
//  CalculatorApp-Codebase
//
//  Created by t0000-m0112 on 2024-11-20.
//

import UIKit

// MARK: CalculatorLogic Class
/// Handles all the calculation logic, including managing expressions and results.
class CalculatorLogic {
    weak var delegate: CalculatorLogicDelegate?
    
    // MARK: Properties
    private var isLastInputOperator = false
    private var isCurrentInputOperator = false
    private var expression = "0" {
        didSet {
            delegate?.didUpdateExpression(expression)
        }
    }
}

// MARK: - Input Handler
/// Handles input actions and updates the expression accordingly.
extension CalculatorLogic {
    internal func buttonAction(from sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        switch buttonTitle {
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            appendNumberToExpression(buttonTitle)
            handleFirstZeroIfNeeded()
        case "+", "-", "×", "÷":
            handleLastCharIfNeeded()
            appendOperatorToExpression(buttonTitle)
        case "AC":
            resetExpression()
        case "=":
            calculateExpression()
        default:
            break
        }
    }
}

// MARK: - Input Validation (Exception Handling)
/// Validates and corrects invalid input cases like duplicated operators or starting zero.
extension CalculatorLogic {
    // Expressions with duplicated operators
    private func handleLastCharIfNeeded() {
        if isLastInputOperator && isCurrentInputOperator {
            self.expression.removeLast()
        }
    }
    
    // Expressions with starting zero
    private func handleFirstZeroIfNeeded() {
        if self.expression.count > 1 && self.expression[expression.startIndex] == "0" {
            if expression[expression.index(expression.startIndex, offsetBy: 1)].isNumber {
                self.expression.removeFirst()
            }
        }
    }
}

// MARK: - Expression Modification
/// Modifies the current expression by appending numbers or operators.
extension CalculatorLogic {
    internal func appendNumberToExpression(_ input: String) {
        self.isCurrentInputOperator = false
        self.expression.append(input)
        self.isLastInputOperator = false
    }
    
    internal func appendOperatorToExpression(_ input: String) {
        self.isCurrentInputOperator = true
        self.expression.append(input)
        self.isLastInputOperator = true
    }
    
    internal func resetExpression() {
        self.isCurrentInputOperator = false
        self.expression = "0"
        self.isLastInputOperator = false
    }
    
    internal func calculateExpression() {
        if let result = calculate(expression) {
            self.isCurrentInputOperator = false
            self.expression = String(result)
            self.isLastInputOperator = false
        }
    }
}

// MARK: - Math Engine
/// Handles the mathematical calculations based on the current expression.
extension CalculatorLogic {
    private func calculate(_ expression: String) -> Int? {
        let expression = NSExpression(format: changeMathSymbols(expression))
        if let result = expression.expressionValue(with: nil, context: nil) as? Int {
            return result
        } else {
            return nil
        }
    }
    
    private func changeMathSymbols(_ expression: String) -> String {
        expression
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
    }
}
