//
//  CountryInputViewArgs.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import Foundation
import RxCocoa

struct CountryInputViewArgs {
    let title: String
    let edited: BehaviorRelay<CountryOption?>
}
