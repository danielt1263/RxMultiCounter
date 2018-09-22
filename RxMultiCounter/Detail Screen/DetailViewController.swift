//
//  DetailViewController.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 9/18/18.
//  Copyright © 2018 Daniel Tartaglia. MIT License.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {

	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var incrementButton: UIButton!
	@IBOutlet weak var decrementButton: UIButton!
	@IBOutlet weak var nothingSelectedView: UIView!

	var store: CounterStore!

	override func viewDidLoad() {
        super.viewDidLoad()

		self.rx.methodInvoked(#selector(viewDidDisappear(_:)))
			.selectNil()
			.bind(to: store)
			.disposed(by: bag)

		incrementButton.rx.tap
			.incrementSelected(state: store.state)
			.bind(to: store)
			.disposed(by: bag)

		decrementButton.rx.tap
			.decrementSelected(state: store.state)
			.bind(to: store)
			.disposed(by: bag)

		store.state
			.counterTextForSelected()
			.bind(to: label.rx.text)
			.disposed(by: bag)

		store.state
			.map { $0.selected != nil }
			.bind(to: nothingSelectedView.rx.isHidden)
			.disposed(by: bag)
	}

	let bag = DisposeBag()
}
