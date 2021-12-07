//
//  Country.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import UIKit

struct Country: Equatable {
    let name: String
    let currencyAbbreviation: String
    let phonePrefix: String
    let numberDigits: Int
    var displayName: String {
        name + " (\(phonePrefix))"
    }
}
