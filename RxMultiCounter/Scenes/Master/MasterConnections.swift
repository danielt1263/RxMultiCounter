//
//  MasterConnections.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 11/6/21.
//

import Cause_Logic_Effect
import Curry
import EnumKit
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

extension MasterViewController {
	func connect() {
		enum Action {
			case addCounter
			case updateCounter(Counter.ID, Int)
			case delete(Counter.ID)
		}

		let cellUpdate = PublishSubject<(Counter.ID, Int)>()

		let state = MasterLogic.state(
			addItem: addItem.rx.tap.asObservable(),
			cellUpdate: cellUpdate,
			modelDeleted: tableView.rx.modelDeleted(Counter.ID.self).asObservable(),
			uuid: { UUID() }
		)
			.share(replay: 1)

		let dataSource = RxTableViewSectionedAnimatedDataSource<CounterSection>(
			configureCell: { dataSource, tableView, indexPath, id in
				let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MasterTableViewCell
				cell.connect(counter: state.compactMap { $0.first(where: { $0.id == id }) })
					.bind(to: cellUpdate)
					.disposed(by: cell.disposeBag)
				return cell
			},
			canEditRowAtIndexPath: { _, _ in true }
		)

		navigationItem.rightBarButtonItem = addItem
		tableView.dataSource = nil
		tableView.delegate = nil

		MasterLogic.counterSections(state: state)
			.bind(to: tableView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)

		tableView.rx.modelSelected(Counter.ID.self)
			.flatMapLatest(showDetailScene(sender: nil, scene: curry(detailScene(state:id:))(state)))
			.bind(to: cellUpdate)
			.disposed(by: disposeBag)
	}
}

extension MasterTableViewCell: CounterDisplay { }

func detailScene(state: Observable<[Counter]>, id: Counter.ID) -> Scene<(Counter.ID, Int)> {
	let counter = state.compactMap { $0.first(where: { $0.id == id }) }
	let detail = DetailViewController().scene { $0.connect(counter: counter) }
	let navigation = UINavigationController(rootViewController: detail.controller)
	return Scene(controller: navigation, action: detail.action)
}
