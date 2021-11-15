//
//  FactsCoreDataSource.swift
//  DoggoFact
//
//  Created by Иван Букшев on 14.11.2021.
//

import Foundation

// MARK: - FactsCoreDataSource

final class FactsCoreDataSource {

}

// MARK: - FactsCoreDataSource + IFactsDataSource

extension FactsCoreDataSource: IFactsDataSource {

    func loadFacts(number: Int, completion: @escaping LoadFactsCompletion) {

    }

    func save(facts: [Fact], completion: @escaping LoadFactsCompletion) {
        
    }
}
