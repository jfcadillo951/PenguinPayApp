//
//  CountryOption.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import Foundation

enum CountryOption: CaseIterable {
    case kenya
    case nigeria
    case tanzania
    case uganda
    var country: Country {
        switch self {
        case .kenya:
            return .init(
                name: "Kenya", currencyAbbreviation: "KES", phonePrefix: "+254", numberDigits: 9)
        case .nigeria:
            return .init(
                name: "Nigeria", currencyAbbreviation: "NGN", phonePrefix: "+234", numberDigits: 7)
        case .tanzania:
            return .init(
                name: "Tanzania", currencyAbbreviation: "TZS", phonePrefix: "+255", numberDigits: 9)
        case .uganda:
            return .init(
                name: "Uganda", currencyAbbreviation: "UGX", phonePrefix: "+256", numberDigits: 7)
        }
    }
}
