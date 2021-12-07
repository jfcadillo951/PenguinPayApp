//
//  TransferMoneyViewModel.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import Foundation
import RxSwift
import RxCocoa

final class TransferMoneyViewModel {

    private var recipient: Recipient?
    private let repository: ContentRepository
    init(repository: ContentRepository = ContentRepositoryImpl()) {
        self.repository = repository
    }

    let recipientNameRelay = BehaviorRelay<String>(value: "")
    let recipientNameStateRelay = BehaviorRelay<TextState>(value: .empty)

    let originAmountRelay = BehaviorRelay<String>(value: "")
    let originAmountStateRelay = BehaviorRelay<TextState>(value: .empty)

    let destinyAmountRelay = BehaviorRelay<String>(value: "")
    let destinyAmountStateRelay = BehaviorRelay<TextState>(value: .empty)

    private let disposeBag = DisposeBag()

    private let ratesRelay = BehaviorRelay<ExchangeRates?>(value: nil)

    lazy var continueObservable = Observable.combineLatest(
        recipientNameStateRelay,
        originAmountStateRelay,
        destinyAmountStateRelay,
        ratesRelay
    ) { (recipientName, originAmount, destinyAmount, rates) -> Bool in
        if recipientName != .ok {
            return false
        }
        if originAmount != .ok {
            return false
        }
        if destinyAmount != .ok {
            return false
        }
        if rates == nil {
            return false
        }
        return true
    }

    private let isLoadingSubject = PublishSubject<Bool>()
    var isLoadingObservable: Observable<Bool> {
        isLoadingSubject
    }

    private let succesViewSubject = PublishSubject<Void>()
    var succesViewObservable: Observable<Void> {
        succesViewSubject
    }

    private let errorRatesSubject = PublishSubject<Void>()
    var errorRatesObservable: Observable<Void> {
        errorRatesSubject
    }

    func onViewDidLoad(_ recipient: Recipient) {
        self.recipient = recipient
        callExchange()
        
        recipientNameRelay.accept("\(recipient.firstName) \(recipient.lastName)")
        recipientNameStateRelay.accept(.ok)

        originAmountRelay.subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.validateOriginAmount()
        }).disposed(by: disposeBag)
        originAmountStateRelay.subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.displayDestinyAmount()
        }).disposed(by: disposeBag)
    }

    func onContinue() {
        succesViewSubject.onNext(())
    }
}

private extension TransferMoneyViewModel {
    func callExchange() {
        isLoadingSubject.onNext(true)
        repository.getExchangeRates { [weak self] result in
            guard let self = self else {
                return
            }
            self.isLoadingSubject.onNext(false)
            switch result {
            case .success(let rates):
                self.ratesRelay.accept(rates)
            case .failure(_):
                self.errorRatesSubject.onNext(())
            }
        }
    }

    func validateOriginAmount() {
        if originAmountRelay.value.isEmpty {
            originAmountStateRelay.accept(.empty)
            return
        }
        guard let number = Int(originAmountRelay.value, radix: 2) else {
            originAmountStateRelay.accept(.wrong("Enter a valid binary"))
            return
        }
        if number <= 0 {
            originAmountStateRelay.accept(.wrong("Enter a valid amount"))
            return
        }
        originAmountStateRelay.accept(.ok)
    }
    func displayDestinyAmount() {
        switch originAmountStateRelay.value {
        case .empty:
            destinyAmountRelay.accept("")
            destinyAmountStateRelay.accept(.empty)
        case .wrong(_):
            destinyAmountRelay.accept("")
            destinyAmountStateRelay.accept(.empty)
        case .ok:
            let abbreviation = recipient?.country.currencyAbbreviation ?? ""
            var amount = Double(Int(originAmountRelay.value, radix: 2) ?? 0)
            let rate = ratesRelay.value?.rates?[abbreviation] ?? 0.0
            amount *= rate
            let displayAmount = Int(ceil(amount))
            destinyAmountRelay.accept(String(displayAmount, radix: 2) + " \(abbreviation)")
            destinyAmountStateRelay.accept(.ok)
        }
    }
}
