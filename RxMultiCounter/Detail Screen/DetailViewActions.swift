//
//  DetailViewActions.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 9/18/18.
//  Copyright © 2018 Daniel Tartaglia. MIT License.
//

import Foundation
import RxSwift

extension ObservableType where E == Void {
	func incrementSelected(state: Observable<State>) -> Observable<Action> {
		return withLatestFrom(state.lastSelectedID())
			.map { Action.increment($0) }
	}

	func decrementSelected(state: Observable<State>) -> Observable<Action> {
		return withLatestFrom(state.lastSelectedID())
			.map { Action.decrement($0) }
	}
}

extension ObservableType where E == [Any] {
	func selectNil() -> Observable<Action> {
		return map { _ in Action.select(nil) }
	}
}
