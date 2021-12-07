//
//  CountryInputView.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import UIKit
import RxSwift

protocol CountryInputViewDelegate: AnyObject {
    func openCountryPicker()
}

final class CountryInputView: UIView, Renderable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var pickerContainerView: UIView!
    @IBOutlet private weak var countryNameLabel: UILabel!
    weak var delegate: CountryInputViewDelegate?
    private let disposeBag = DisposeBag()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        render(fromView: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        displayOption(nil)
        pickerContainerView.layer.borderColor = UIColor.black.cgColor
        pickerContainerView.layer.borderWidth = 1
    }

    var args: CountryInputViewArgs? {
        didSet {
            guard let args = args else {
                return
            }
            titleLabel.text = args.title
            args.edited.subscribe(onNext: { [weak self] value in
                guard let self = self else {return}
                self.displayOption(value)
            }).disposed(by: disposeBag)
        }
    }
    @IBAction func onPicketTap(_ sender: Any) {
        delegate?.openCountryPicker()
    }
}

private extension CountryInputView {
    func displayOption(_ countryOption: CountryOption?) {
        guard let countryOption = countryOption else {
            countryNameLabel.text = "Choose a country"
            return
        }
        countryNameLabel.text = countryOption.country.displayName
    }
}


