//
//  ServerConstants.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import Foundation

struct ServerContants {
    static let apiKey = "{api-key}"
    enum Enpoint {
        private static let base = "https://openexchangerates.org/api"
        static let latestEndpoint = base + "/latest.json"
    }
}
