//
//  FactListViewModel.swift
//  DoggoFact
//
//  Created by Иван Букшев on 11.11.2021.
//

import Foundation

// MARK: - Constants

private enum Constants {
    /// Количество загружаемых данных.
    static let factsNumber = 20
}

// MARK: - Contract

typealias IFactListViewModel = IFactListViewModelState & IFactListViewModelBehaviour

protocol IFactListViewModelState: AnyObject {
    /// Значение, по которому мы понимаем: нужно ли показывать Progress HUD или нужно его скрыть.
    var loading: Observable<Bool> { get }
    /// Значение, по которому мы понимаем: какие данные необходимо отобразить в таблице.
    var items: Observable<[FactViewModel]> { get }
    /// Значение, по которому мы понимаем: какую ошибку необходимо показать пользователю.
    var errorText: Observable<String> { get }
    /// Статический текст для заголовка всплывающего окна с ошибкой.
    var errorTitle: String { get }
    /// Статический текст для заголовка экрана.
    var screenTitle: String { get }
}

protocol IFactListViewModelBehaviour: AnyObject {
    /// "Просьба" от View к ViewModel начать загрузку данных для отображения.
    func loadFacts()
    /// Событие с уровня View "Произошло нажатие на ячейку с фактом по индексу" для ViewModel.
    func didTapFact(with indexPath: IndexPath)
}

// MARK: - FactListViewModel + State

final class FactListViewModel: IFactListViewModelState {

    let loading: Observable<Bool> = Observable(true)
    let items: Observable<[FactViewModel]> = Observable([])
    let errorText: Observable<String> = Observable("")
    let errorTitle = "Error"
    let screenTitle = "DoggoFact"

    private let loadFactsUseCase: LoadFactsUseCase

    init(loadFactsUseCase: LoadFactsUseCase) {
        self.loadFactsUseCase = loadFactsUseCase
    }
}

// MARK: - Behaviour

extension FactListViewModel: IFactListViewModelBehaviour {

    func loadFacts() {
        loading.value =  true
        loadFactsUseCase.execute(with: .init(factsNumber: Constants.factsNumber)) { [weak self] result in
            switch result {
            case let .success(facts):
                self?.handle(facts: facts)
            case let .failure(error):
                self?.handle(error: error)
            }
            self?.loading.value = false
        }
    }

    func didTapFact(with indexPath: IndexPath) {
        print("Tapped indexPath: \(indexPath)")
    }
}

// MARK: - Private helpers

private extension FactListViewModel {

    /// Если к нам успешно пришли данные в виде domain-моделей,
    /// то конвертируем их во viewModel'и и устанавливаем новое значение в items,
    /// после которого произойдёт автоматическое обновление View.
    func handle(facts: [Fact]) {
        items.value = facts.map { .init(text: $0.text) }
    }

    /// Если к нам пришла ошибка, то устанавливаем значение в error,
    /// после которого произойдёт автоматическое обновление View.
    func handle(error: Error) {
        errorText.value = error.localizedDescription
    }
}
