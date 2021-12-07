//
//  TransferMoneyViewController.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import UIKit
import RxSwift
import MBProgressHUD

final class TransferMoneyViewController: UIViewController {

    @IBOutlet private weak var recipientInputView: InputTextView!
    @IBOutlet private weak var originAmountInputView: InputTextView!
    @IBOutlet private weak var destinyAmountInputView: InputTextView!

    var recipient: Recipient?
    private let viewModel = TransferMoneyViewModel()
    private let disposeBag = DisposeBag()
    private lazy var doneButton: UIBarButtonItem = {
        .init(title: "Transfer", style: .done, target: self, action: #selector(onContinueTap))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModels()
        if let value = recipient {
            viewModel.onViewDidLoad(value)
        }
    }

}

private extension TransferMoneyViewController {
    func setupUI() {
        recipientInputView.isUserInteractionEnabled = false
        destinyAmountInputView.isUserInteractionEnabled = false
        doneButton.isEnabled = false
        navigationItem.title = "Send"
        navigationItem.rightBarButtonItem = doneButton
    }
    func bindViewModels() {
        recipientInputView.args = .init(
            title: "Recipient:",
            edited: viewModel.recipientNameRelay,
            textState: viewModel.recipientNameStateRelay,
            keyboardType: nil)
        originAmountInputView.args = .init(
            title: "Send:",
            edited: viewModel.originAmountRelay,
            textState: viewModel.originAmountStateRelay,
            keyboardType: .numberPad)
        destinyAmountInputView.args = .init(
            title: "Will Receive:",
            edited: viewModel.destinyAmountRelay,
            textState: viewModel.destinyAmountStateRelay,
            keyboardType: nil)
        viewModel.isLoadingObservable.subscribe(onNext: { [weak self] value in
            guard let self = self else {return}
            if value {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }).disposed(by: disposeBag)
        viewModel.continueObservable.subscribe(onNext: { [weak self] value in
            guard let self = self else {return}
            self.doneButton.isEnabled = value
        }).disposed(by: disposeBag)
        viewModel.recipientNameRelay.subscribe(onNext: { [weak self] value in
            guard let self = self else {return}
            self.recipientInputView.set(text: value)
        }).disposed(by: disposeBag)
        viewModel.destinyAmountRelay.subscribe(onNext: { [weak self] value in
            guard let self = self else {return}
            self.destinyAmountInputView.set(text: value)
        }).disposed(by: disposeBag)
        viewModel.succesViewObservable.subscribe(onNext: { [weak self] value in
            guard let self = self else {return}
            self.displaySuccessTransfer()
        }).disposed(by: disposeBag)
        viewModel.errorRatesObservable.subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.displayErrorRates()
        }).disposed(by: disposeBag)
    }
    func displaySuccessTransfer() {
        let alert = UIAlertController(
            title: "Success Transfer",
            message: "Your transfer was successful!",
            preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    func displayErrorRates() {
        let alert = UIAlertController(
            title: "Error getting Rates",
            message: "Something were wrong",
            preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    @objc func onContinueTap() {
        viewModel.onContinue()
    }
    
}
