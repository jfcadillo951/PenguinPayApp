//
//  ContentRepositoryImpl.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import Foundation

final class ContentRepositoryImpl: ContentRepository {
    func getExchangeRates(_ onCompletion: @escaping (CaseResult<ExchangeRates>) -> Void) {
        let urlString = ServerContants.Enpoint.latestEndpoint + "?app_id=\(ServerContants.apiKey)"
        guard let url = URL(string: urlString) else {
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                onCompletion(.failure(error))
                return
            }
            guard let data = data else {
                onCompletion(.failure(nil))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(ExchangeRates.self, from: data)
                onCompletion(.success(decoded))
            } catch {
                onCompletion(.failure(nil))
            }
        }
        task.resume()
    }
}
