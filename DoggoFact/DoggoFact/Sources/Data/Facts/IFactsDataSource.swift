//
//  IFactsDataSource.swift
//  DoggoFact
//
//  Created by Иван Букшев on 14.11.2021.
//

import Foundation

protocol IFactsDataSource {

    /// Загрузить данные из источника.
    func loadFacts(number: Int, completion: @escaping LoadFactsCompletion)

    /// Сохранить данные в источнике.
    func save(facts: [Fact], completion: @escaping LoadFactsCompletion)
}
