//
//  Coordinator.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 9/18/18.
//  Copyright © 2018 Daniel Tartaglia. MIT License.
//

import UIKit
import RxSwift
import RxCocoa

class Coordinator {
	init(rootViewController: UISplitViewController) {
		store = CounterStore(initialState: initialState, reducer: update)
		rootViewController.delegate = self
		let masterNav = rootViewController.children[0] as! UINavigationController
		let master = masterNav.topViewController as! MasterTableViewController
		let detail = rootViewController.children[1] as! DetailViewController

		master.store = store
		detail.store = store

		store.state
			.showDetail()
			.subscribe(onNext: { [weak self] in
				guard let this = self else { return }
				rootViewController.showDetailViewController(detail, sender: this)
			})
			.disposed(by: bag)

		store.state
			.map { $0.selected == nil }
			.bind(to: itemSelected)
			.disposed(by: bag)

		store.state
			.distinctUntilChanged()
			.subscribe(onNext: { state in
				guard let data = try? PropertyListEncoder().encode(state) else { return }
				guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
				let url = dir.appendingPathComponent("save.plist")
				try? data.write(to: url)
			})
			.disposed(by: bag)
	}

	private let store: CounterStore
	private let itemSelected = BehaviorRelay<Bool>(value: true)
	private let bag = DisposeBag()
}

extension Coordinator: UISplitViewControllerDelegate {
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		return itemSelected.value
	}
}

private var initialState: State {
	guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return State() }
	let url = dir.appendingPathComponent("save.plist")
	guard let data = try? Data(contentsOf: url) else { return State() }
	guard var state = try? PropertyListDecoder().decode(State.self, from: data) else { return State() }
	state.selected = nil
	return state
}
