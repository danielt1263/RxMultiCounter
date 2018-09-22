//
//  MasterTableViewController.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 9/18/18.
//  Copyright © 2018 Daniel Tartaglia. MIT License.
//

import UIKit
import RxSwift
import RxCocoa

class MasterTableViewController: UITableViewController {

	@IBOutlet weak var addBarButtonItem: UIBarButtonItem!

	var store: CounterStore!

    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.dataSource = nil
		tableView.delegate = nil

		addBarButtonItem.rx.tap
			.map { Action.add }
			.bind(to: store)
			.disposed(by: bag)

		tableView.rx.itemSelected
			.select(state: store.state)
			.bind(to: store)
			.disposed(by: bag)

		tableView.rx.itemDeleted
			.delete(state: store.state)
			.bind(to: store)
			.disposed(by: bag)

		let _store = store!
		let dataSource = RxSimpleAnimatableDataSource<UUID, MasterTableViewCell>(identifier: "Cell", configure: { _, element, cell in
			cell.configure(with: _store, id: element)
		})

		store.state
			.map { $0.order }
			.bind(to: tableView.rx.items(dataSource: dataSource))
			.disposed(by: bag)

		let _tableView = tableView!
		store.state
			.deselect()
			.subscribe(onNext: {
				if let path = _tableView.indexPathForSelectedRow {
					_tableView.deselectRow(at: path, animated: true)
				}
			})
			.disposed(by: bag)
    }

	let bag = DisposeBag()
}
