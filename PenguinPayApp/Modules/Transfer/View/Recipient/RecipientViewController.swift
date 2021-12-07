//
//  RecipientViewController.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import UIKit
import RxSwift

final class RecipientViewController: UIViewController {
    @IBOutlet private weak var firstNameInputView: InputTextView!
    @IBOutlet private weak var lastNameInputView: InputTextView!
    @IBOutlet private weak var countryInputView: CountryInputView!
    @IBOutlet private weak var phoneInputView: InputTextView!
    @IBOutlet private weak var pickerContainerView: UIStackView!
    @IBOutlet private weak var pickerView: UIPickerView!
    private var viewModel = RecipientViewModel()
    private let disposeBag = DisposeBag()
    private var countryOptions: [String] = []
    private lazy var doneButton: UIBarButtonItem = {
        .init(title: "Continue", style: .done, target: self, action: #selector(onContinueTap))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModels()
        viewModel.onViewDidLoad()
    }
}

private extension RecipientViewController {
    func setupUI() {
        firstNameInputView.delegate = self
        lastNameInputView.delegate = self
        countryInputView.delegate = self
        phoneInputView.delegate = self
        pickerContainerView.isHidden = true
        pickerView.dataSource = self
        pickerView.delegate = self
        doneButton.isEnabled = false
        navigationItem.title = "New Recipient"
        navigationItem.rightBarButtonItem = doneButton
    }
    func bindViewModels() {
        firstNameInputView.args = .init(
            title: "First Name:",
            edited: viewModel.firstNameRelay,
            textState: viewModel.firstNameStateRelay,
            keyboardType: .alphabet)
        lastNameInputView.args = .init(
            title: "Last Name:",
            edited: viewModel.lastNameRelay,
            textState: viewModel.lastNameStateRelay,
            keyboardType: .alphabet)
        countryInputView.args = .init(
            title: "Select Country:", edited: viewModel.contryOptionRelay)
        phoneInputView.args = .init(
            title: "Enter Phone:",
            edited: viewModel.phoneRelay,
            textState: viewModel.phoneStateRelay,
            keyboardType: .phonePad)
        viewModel.contryOptionsObservable.subscribe(onNext: { [weak self] value in
            guard let self = self else {return}
            self.countryOptions = value
            self.displayPicker()
        }).disposed(by: disposeBag)
        viewModel.continueObservable.subscribe(onNext: { [weak self] value in
            guard let self = self else {return}
            self.doneButton.isEnabled = value
        }).disposed(by: disposeBag)
        viewModel.openNextViewObservable.subscribe(onNext: { [weak self] value in
            guard let self = self else {return}
            let viewController = TransferMoneyViewController()
            viewController.recipient = value
            self.navigationController?.pushViewController(viewController, animated: true)
        }).disposed(by: disposeBag)
    }
    func displayPicker() {
        pickerView.reloadAllComponents()
        pickerContainerView.isHidden = false
    }
    @objc func onContinueTap() {
        viewModel.onContinue()
    }
    @IBAction func onPickerDoneTap(_ sender: Any) {
        viewModel.onContryTap(pickerView.selectedRow(inComponent: 0))
        pickerContainerView.isHidden = true
    }
}

extension RecipientViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        countryOptions.count
    }
}

extension RecipientViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        countryOptions[row]
    }
}

extension RecipientViewController: CountryInputViewDelegate {
    func openCountryPicker() {
        _ = firstNameInputView.resignFirstResponder()
        _ = lastNameInputView.resignFirstResponder()
        _ = phoneInputView.resignFirstResponder()
        viewModel.onOpenPickerTap()
    }
}

extension RecipientViewController: InputTextViewDelegate {
    func beginEditInput() {
        pickerContainerView.isHidden = true
    }
}
