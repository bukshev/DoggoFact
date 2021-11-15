//
//  LoadFactsUseCase.swift
//  DoggoFact
//
//  Created by Иван Букшев on 12.11.2021.
//

import UIKit

// MARK: - Contract

/// Замыкание, в котором конкретно указывается тип для associatedtype ответа — это Array<Fact>.
typealias LoadFactsCompletion = (Result<[Fact], Error>) -> Void

// MARK: - LoadFactsUseCase

/// Инкапсулированная логика для бизнес-ценности "Просмотр фактов о собаках" —
/// да, в рамках нашего приложения это является бизнес-ценностью, хотя никакой речи "о бизнесе" и "о деньгах" нет;
/// Если максимально кратко и грубо, то бизнес-ценность — это то, что закрывает некую пользовательскую потребность в рамках нашего сервиса.
final class LoadFactsUseCase {

    /// Входные параметры для нашего UseCase.
    /// Конкретная реализация для того самого associatedtype.
    struct RequestValue {
        /// Количество фактов для загрузки.
        let factsNumber: Int
    }

    private let factsGateway: IFactsGateway

    init(factsGateway: IFactsGateway = FactsGateway()) {
        self.factsGateway = factsGateway
    }
}

// MARK: - LoadFactsUseCase + IUseCase

extension LoadFactsUseCase: IUseCase {

    func execute(with parameters: RequestValue, completion: @escaping LoadFactsCompletion) {
        let configuration = FactsGateway.Configuration(
            source: .remote(shouldUpdateLocalStorage: false),
            factsNumber: parameters.factsNumber
        )
        Log.i(.domain, "Execute the script with configuration: \(configuration)")
        factsGateway.loadFacts(with: configuration, completion: completion)
    }
}
