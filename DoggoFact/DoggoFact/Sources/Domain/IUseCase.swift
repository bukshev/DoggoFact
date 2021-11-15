//
//  IUseCase.swift
//  DoggoFact
//
//  Created by Иван Букшев on 12.11.2021.
//

import Foundation

/// Общая абстракция для всех UseCase'ов.
protocol IUseCase: AnyObject {
    /// Тип входных данных в UseCase (если их нет, то ставим в реализации Void).
    associatedtype RequestValue
    /// Тип выходных данных в UseCase (если их нет, то ставим в реализации Void).
    associatedtype ResponseValue

    /// Команда на выполнение реализованной бизнес-логики.
    ///
    /// - Parameter parameters: Входные параметры в UseCase — данные, которые необходимы для того, что выполнить работу.
    /// - Parameter completion: Замыкание, в котором приходит результат работы UseCase.
    ///
    /// - Note:
    /// Completion with success: В случае успеха приходит значение типа ResponseValue.
    /// Completion with failure: В случае ошибки приходит значение типа Error.
    func execute(with parameters: RequestValue, completion: @escaping (Result<ResponseValue, Error>) -> Void)
}
