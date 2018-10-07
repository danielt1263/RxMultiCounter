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
	func incrementSelected() -> Observable<Action> {
		return map { Action.incrementSelected }
	}

	func decrementSelected() -> Observable<Action> {
		return map { Action.decrementSelected }
	}
}

extension ObservableType where E == [Any] {
	func selectNil() -> Observable<Action> {
		return map { _ in Action.select(nil) }
	}
}
