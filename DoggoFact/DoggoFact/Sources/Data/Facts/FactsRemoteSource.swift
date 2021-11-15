//
//  FactsRemoteSource.swift
//  DoggoFact
//
//  Created by Иван Букшев on 14.11.2021.
//

import Foundation

// MARK: - FactsRemoteSource

final class FactsRemoteSource {

    private let networkRequestExecutor: INetworkRequestExecutor

    init(networkRequestExecutor: INetworkRequestExecutor = NetworkRequestExecutor()) {
        self.networkRequestExecutor = networkRequestExecutor
    }
}

// MARK: - FactsRemoteSource + IFactsDataSource

extension FactsRemoteSource: IFactsDataSource {

    func loadFacts(number: Int, completion: @escaping LoadFactsCompletion) {
        let request = NetworkRequest(endpoint: .getFacts, queryItems: [
            .init(name: "number", value: "\(number)")
        ])

        Log.d(.dataSource, "Request has been generated: \(request)")

        networkRequestExecutor.execute(request: request) { [weak self] (result: Result<FactsDto, Error>) in
            switch result {
            case let .success(dto):
                self?.handleFacts(dto: dto, completion: completion)
            case let .failure(error):
                self?.handleFacts(error: error, completion: completion)
            }
        }
    }

    func save(facts: [Fact], completion: @escaping LoadFactsCompletion) {
        Log.e(.dataSource, "\(#function) without implementation")
    }
}

// MARK: - Private helpers

private extension FactsRemoteSource {

    func handleFacts(dto: FactsDto, completion: @escaping LoadFactsCompletion) {

        let facts: [Fact] = dto.facts.map { .init(text: $0.fact) }
        completion(.success(facts))
    }

    func handleFacts(error: Error, completion: @escaping LoadFactsCompletion) {
        Log.d(.dataSource, "Received error: \(error.localizedDescription). Converting to high-level error...")
        completion(.failure(error))
    }
}
