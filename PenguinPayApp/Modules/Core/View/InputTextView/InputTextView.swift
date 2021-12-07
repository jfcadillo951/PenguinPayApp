//
//  InputTextView.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import UIKit
import RxSwift

protocol InputTextViewDelegate: AnyObject {
    func beginEditInput()
}

final class InputTextView: UIView, Renderable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    weak var delegate: InputTextViewDelegate?

    private let disposeBag = DisposeBag()

    required init?(coder: NSCoder) { // necessary for render
        super.init(coder: coder)
        render(fromView: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
        inputTextField.text = ""
        inputTextField.addTarget(
            self,
            action: #selector(inputTextFieldBeginChange(_:)),
            for: .editingDidBegin)
        inputTextField.addTarget(
            self,
            action: #selector(inputTextFieldDidChange(_:)),
            for: .editingChanged)
        errorLabel.textColor = .red
    }

    var args: InputTextViewArgs? {
        didSet {
            guard let args = args else {
                return
            }
            titleLabel.text = args.title
            if let keyboardType = args.keyboardType {
                inputTextField.keyboardType = keyboardType
            }
            args.textState.subscribe(onNext: { [weak self] value in
                guard let self = self else {return}
                switch value {
                case .wrong(let text):
                    self.errorLabel.text = text
                default:
                    self.errorLabel.text = ""
                }
            }).disposed(by: disposeBag)
        }
    }

    func set(text: String) {
        inputTextField.text = text
    }

    override func resignFirstResponder() -> Bool {
        inputTextField.resignFirstResponder()
    }
    override var isUserInteractionEnabled: Bool {
        didSet {
            inputTextField.isUserInteractionEnabled = isUserInteractionEnabled
            inputTextField.borderStyle =  isUserInteractionEnabled ?  .roundedRect : .none
        }
    }
}

private extension InputTextView {
    @objc func inputTextFieldDidChange(_ textField: UITextField) {
        args?.edited.accept(textField.text ?? "")
    }
    @objc func inputTextFieldBeginChange(_ textField: UITextField) {
        delegate?.beginEditInput()
    }
}
