//
//  FactsGateway.swift
//  DoggoFact
//
//  Created by Иван Букшев on 12.11.2021.
//

import Foundation

// MARK: - Contract

protocol IFactsGateway {

    func loadFacts(number: Int, config: FactsGateway.Configuration, completion: @escaping LoadFactsCompletion)
}

// MARK: - FactsGateway

/// Сущность, за которой мы скрываем реализацию работы с `Fact` из различных источников.
final class FactsGateway {

    /// Можно было обмазать, как и на уровне UseCase, дженериками, но такой вариант тоже вполне рабочий.
    /// В зависимости от бизнес-требований мы можем по-разному получать/обрабатывать модель данных `Fact`.
    struct Configuration {
        enum Source {
            /// Работаем с данными из локального хранилища.
            case cache
            /// Работаем с данными из удалённого источника.
            /// - Parameter shouldUpdateLocalStorage: Если данные загрузили из сети, то нужно ли обновлять локальное хранилище?
            case remote(shouldUpdateLocalStorage: Bool)
        }
        /// Источник данных, с которым мы работаем в рамках какой-либо задачи.
        let source: Source
    }

    private let remoteSource: IFactsDataSource
    private let coreDataSource: IFactsDataSource

    init(
        remoteSource: IFactsDataSource = FactsRemoteSource(),
        coreDataSource: IFactsDataSource = FactsCoreDataSource()
    ) {
        self.remoteSource = remoteSource
        self.coreDataSource = coreDataSource
    }
}

// MARK: - FactsGateway + IFactsGateway

extension FactsGateway: IFactsGateway {

    func loadFacts(number: Int, config: FactsGateway.Configuration, completion: @escaping LoadFactsCompletion) {
        switch config.source {
        case .cache:
            coreDataSource.loadFacts(number: number, completion: completion)
        case let .remote(shouldUpdateLocalStorage):
            Log.i(.gateway, "Sending a command to download facts from the remote source.")
            if shouldUpdateLocalStorage {
                Log.i(.gateway, "The facts that will be loaded will be cached in the local storage.")
                remoteSource.loadFacts(number: number) { self.process(remoteResult: $0, completion: completion) }
            } else {
                remoteSource.loadFacts(number: number, completion: completion)
            }
        }
    }
}

// MARK: - Private helpers

private extension FactsGateway {

    func process(remoteResult: Result<[Fact], Error>, completion: @escaping LoadFactsCompletion) {
        switch remoteResult {
        case let .success(facts):
            Log.i(.gateway, "Sending a command to cache facts from the remote in the local storage.")
            coreDataSource.save(facts: facts, completion: completion)
        case let .failure(error):
            completion(.failure(error))
        }
    }
}
