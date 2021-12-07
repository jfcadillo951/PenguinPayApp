//
//  CaseResult.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import Foundation

enum CaseResult<T> {
    case success(_ data: T)
    case failure(_ error: Error?)
}
