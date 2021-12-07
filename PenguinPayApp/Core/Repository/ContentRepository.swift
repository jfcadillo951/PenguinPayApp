//
//  ContentRepository.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import Foundation

protocol ContentRepository {
    func getExchangeRates(_ onCompletion: @escaping (CaseResult<ExchangeRates>) -> Void)
}
