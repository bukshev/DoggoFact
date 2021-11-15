//
//  FactListTableCell.swift
//  DoggoFact
//
//  Created by Иван Букшев on 12.11.2021.
//

import UIKit

final class FactListTableCell: UITableViewCell {

    static let reuseId = "\(FactListTableCell.self)"

    @IBOutlet private weak var titleLabel: UILabel!

    func configure(with viewModel: FactViewModel) {
        titleLabel.text = viewModel.text
    }
}
