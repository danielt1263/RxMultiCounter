//
//  Store.swift
//
//  Created by Daniel Tartaglia on 3/11/17.
//  Copyright © 2017 Haneke Design. MIT License
//

import Foundation
import RxSwift


class Store<State, Action> {

	init(initialState: State, reducer: @escaping (State, Action) -> State) {
		state = actions
			.scan(initialState, accumulator: reducer)
			.startWith(initialState)
			.share(replay: 1)
	}

	let state: Observable<State>

	private let actions = PublishSubject<Action>()
}


extension Store: ObserverType {

	typealias E = Action

	func on(_ event: Event<E>) {
		actions.on(event)
	}
}
