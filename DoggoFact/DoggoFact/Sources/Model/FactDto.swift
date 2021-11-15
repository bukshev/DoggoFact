//
//  FactDto.swift
//  DoggoFact
//
//  Created by Иван Букшев on 14.11.2021.
//

import Foundation

/*
 Ответ приходит в виде массива:
 [
   {
       "fact": "Many foot disorders in dogs are caused by long toenails."
   }
 ]
 */
struct FactsDto: Decodable {

    let facts: [FactDto]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.facts = try container.decode([FactDto].self)
    }
}

/// Data Transfer Object (DTO) для модели, с которой мы хотим работать в рамках нашего приложения.
struct FactDto: Decodable {
    let fact: String
}
