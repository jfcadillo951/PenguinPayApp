//
//  InputTextViewArgs.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import Foundation
import RxCocoa

struct InputTextViewArgs {
    let title: String
    let edited: BehaviorRelay<String>
    let textState: BehaviorRelay<TextState>
    let keyboardType: UIKeyboardType?
}
