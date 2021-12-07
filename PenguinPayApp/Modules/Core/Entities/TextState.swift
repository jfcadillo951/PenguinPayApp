//
//  TextState.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import Foundation

enum TextState: Equatable {
    case empty
    case wrong(_ text: String)
    case ok
}
