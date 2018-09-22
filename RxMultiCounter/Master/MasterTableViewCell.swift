//
//  MasterTableViewCell.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 9/19/18.
//  Copyright © 2018 Daniel Tartaglia. MIT License.
//

import UIKit
import RxSwift
import RxCocoa

class MasterTableViewCell: UITableViewCell {

	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var increment: UIButton!
	@IBOutlet weak var decrement: UIButton!

	override func prepareForReuse() {
		super.prepareForReuse()
		bag = DisposeBag()
	}

	func configure(with store: CounterStore, id: UUID) {
		increment.rx.tap
			.map { Action.increment(id) }
			.bind(to: store)
			.disposed(by: bag)

		decrement.rx.tap
			.map { Action.decrement(id) }
			.bind(to: store)
			.disposed(by: bag)

		store.state
			.counterText(for: id)
			.bind(to: label.rx.text)
			.disposed(by: bag)
	}
	
	private var bag = DisposeBag()
}
