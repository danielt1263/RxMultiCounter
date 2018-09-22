//
//  MasterViewActions.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 9/18/18.
//  Copyright © 2018 Daniel Tartaglia. MIT License.
//

import Foundation
import RxSwift

extension ObservableType where E == Void {
	func add() -> Observable<Action> {
		return map { Action.add }
	}
}

extension ObservableType where E == IndexPath {
	func select(state: Observable<State>) -> Observable<Action> {
		return withLatestFrom(state.map { $0.order }) { $1[$0.row] }
			.map { Action.select($0) }
	}

	func delete(state: Observable<State>) -> Observable<Action> {
		return withLatestFrom(state.map { $0.order }) { $1[$0.row] }
			.map { Action.remove($0) }
	}
}
