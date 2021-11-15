//
//  FactListTableViewController.swift
//  DoggoFact
//
//  Created by Иван Букшев on 11.11.2021.
//

import UIKit

// MARK: - FactListTableViewController

final class FactListTableViewController: UITableViewController {

    private var viewModel: IFactListViewModel?

    func inject(viewModel: IFactListViewModel) {
        self.viewModel = viewModel
    }

    func reload() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension FactListTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.value.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            assertionFailure("ViewModel was not set.")
            return .init()
        }

        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: FactListTableCell.reuseId, for: indexPath)
        guard let cell = dequeuedCell as? FactListTableCell else {
            assertionFailure("Cannot dequeue reusable for reuseId: \(FactListTableCell.reuseId)")
            return .init()
        }

        let cellItemViewModel = viewModel.items.value[indexPath.row]
        cell.configure(with: cellItemViewModel)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didTapFact(with: indexPath)
    }
}
