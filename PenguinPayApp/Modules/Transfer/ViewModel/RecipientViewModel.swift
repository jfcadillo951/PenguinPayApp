//
//  RecipientViewModel.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import Foundation
import RxSwift
import RxCocoa

final class RecipientViewModel {
    let firstNameRelay = BehaviorRelay<String>(value: "")
    let firstNameStateRelay = BehaviorRelay<TextState>(value: .empty)

    let lastNameRelay = BehaviorRelay<String>(value: "")
    let lastNameStateRelay = BehaviorRelay<TextState>(value: .empty)

    let contryOptionRelay = BehaviorRelay<CountryOption?>.init(value: nil)

    let phoneRelay = BehaviorRelay<String>(value: "")
    let phoneStateRelay = BehaviorRelay<TextState>(value: .empty)

    lazy var continueObservable = Observable.combineLatest(
        firstNameRelay,
        lastNameRelay,
        contryOptionRelay,
        phoneStateRelay
    ) { (firstName, lastName, countryOption, phoneState) -> Bool in
        guard let countryOption = countryOption else {
            return false
        }
        return !firstName.isEmpty && !lastName.isEmpty && phoneState == .ok
    }

    private let disposeBag = DisposeBag()
    
    private let contryOptionsSubject = PublishSubject<[String]>()
    var contryOptionsObservable: Observable<[String]> {
        contryOptionsSubject
    }

    private let openNextViewSubject = PublishSubject<Recipient>()
    var openNextViewObservable: Observable<Recipient> {
        openNextViewSubject
    }

    func onViewDidLoad() {
        firstNameRelay.subscribe(onNext: { [weak self] value in
            guard let self = self else {return}
            self.firstNameStateRelay.accept(!value.isEmpty ? .ok : .empty)
        }).disposed(by: disposeBag)
        lastNameRelay.subscribe(onNext: { [weak self] value in
            guard let self = self else {return}
            self.lastNameStateRelay.accept(!value.isEmpty ? .ok : .empty)
        }).disposed(by: disposeBag)
        phoneRelay.subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.validatePhone()
        }).disposed(by: disposeBag)
    }

    func onOpenPickerTap() {
        contryOptionsSubject.onNext(CountryOption.allCases.map({
            $0.country.displayName
        }))
    }

    func onContryTap(_ index: Int) {
        let option = CountryOption.allCases[index]
        contryOptionRelay.accept(option)
        validatePhone()
    }

    func onContinue() {
        guard let countryOption = contryOptionRelay.value else {
            return
        }
        let recipient = Recipient(
            firstName: firstNameRelay.value,
            lastName: lastNameRelay.value,
            country: countryOption.country,
            phone: phoneRelay.value)
        openNextViewSubject.onNext(recipient)
    }
}

private extension RecipientViewModel {
    func validatePhone() {
        if phoneRelay.value.isEmpty {
            phoneStateRelay.accept(.empty)
            return
        }
        guard let countryOption = contryOptionRelay.value else {
            phoneStateRelay.accept(.wrong("Select a country"))
            return
        }
        if !phoneRelay.value.isNumber {
            phoneStateRelay.accept(.wrong("Only phone numbers are allowed"))
            return
        }
        let isOk = phoneRelay.value.count == countryOption.country.numberDigits
        phoneStateRelay.accept(isOk ? .ok : .wrong("Phone size error"))
    }
}
