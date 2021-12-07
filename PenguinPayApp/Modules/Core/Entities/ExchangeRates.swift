//
//  ExchangeRates.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import Foundation

struct ExchangeRates: Codable { // model for decode response
    let base: String?
    let rates: [String: Double]?
}
