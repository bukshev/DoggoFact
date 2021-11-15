//
//  FactListViewController.swift
//  DoggoFact
//
//  Created by Иван Букшев on 11.11.2021.
//

import UIKit

// MARK: - FactListViewController

final class FactListViewController: UIViewController, IStoryboardInstantiatable, IAlertIndicatable {

    @IBOutlet private weak var progressHUD: UIActivityIndicatorView!

    private weak var tableViewController: FactListTableViewController?

    private var viewModel: IFactListViewModel?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        viewModel?.loadFacts()
    }

    func inject(viewModel: IFactListViewModel) {
        self.viewModel = viewModel
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Так как в рамках нашего экрана есть container с таблицей, то нужно:
        // его оттуда "достать", локально сохранить ссылку, заинжектить в него нашу viewModel.
        guard segue.identifier == "\(FactListTableViewController.self)",
              let destinationViewController = segue.destination as? FactListTableViewController,
              let viewModel = viewModel else {
            assertionFailure("Failed to get the destination VC or the viewModel is nil.")
            return
        }
        tableViewController = destinationViewController
        tableViewController?.inject(viewModel: viewModel)
    }
}

// MARK: - Private helpers

private extension FactListViewController {

    /// Конфигурация начального состояния экрана (до показа самого view).
    func setupInitialState() {
        title = viewModel?.screenTitle
        progressHUD.alpha = 0.0
        progressHUD.hidesWhenStopped = true
    }

    /// Связывание данных (тот самый data binding и не более):
    /// что нужно делать на view, когда изменится то или иное значение на уровне viewModel.
    func bindToViewModel() {
        guard let viewModel = viewModel else { assertionFailure("The viewModel was not set."); return }
        viewModel.loading.subscribe(on: self) { [weak self] in self?.updateProgressHUD($0) }
        viewModel.items.subscribe(on: self) { [weak self] _ in self?.updateView() }
        viewModel.errorText.subscribe(on: self) { [weak self] in self?.displayError($0) }
    }

    /// Действие, после изменения значения loading.
    func updateProgressHUD(_ isLoading: Bool) {
        isLoading ? animateProgressStart() : animateProgressEnd()
    }

    func animateProgressStart() {
        progressHUD.alpha = 1.0
        progressHUD.startAnimating()
        progressHUD.isHidden = false
    }

    func animateProgressEnd() {
        UIView.animate(withDuration: 0.4) {
            self.progressHUD.alpha = 0.0
        } completion: { _ in
            self.progressHUD.stopAnimating()
        }
    }

    /// Действие, после изменения значения items.
    func updateView() {
        tableViewController?.reload()
    }

    /// Действие, после изменения значения error.
    func displayError(_ errorText: String) {
        showAlert(title: viewModel?.errorTitle, message: errorText)
    }
}
