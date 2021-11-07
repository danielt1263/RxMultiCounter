//
//  CounterDisplay.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 11/7/21.
//

import RxSwift
import UIKit

protocol CounterDisplay {
	var countLabel: UILabel! { get }
	var incrementButton: UIButton! { get }
	var decrementButton: UIButton! { get }
	var disposeBag: DisposeBag { get }
}

extension CounterDisplay {
	func connect(counter: Observable<Counter>) -> Observable<(Counter.ID, Int)> {
		counter
			.map { "\($0.value)" }
			.bind(to: countLabel.rx.text)
			.disposed(by: disposeBag)

		return Observable.merge(
			incrementButton.rx.tap.map(to: 1),
			decrementButton.rx.tap.map(to: -1)
		)
			.withLatestFrom(counter) { ($1.id, $0) }
	}
}
