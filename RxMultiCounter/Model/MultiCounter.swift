//
//  MultiCounter.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 9/18/18.
//  Copyright © 2018 Daniel Tartaglia. MIT License.
//

import Foundation
import RxSwift
import DifferenceKit

enum Action {
	case add
	case remove(UUID)
	case increment(UUID)
	case decrement(UUID)
	case select(UUID?)
}

struct State: Codable, Equatable {
	var order: [UUID] = []
	var counters: [UUID: Int] = [:]
	var selected: UUID?
}

func update(state: State, action: Action) -> State {
	var result = state
	switch action {
	case .add:
		let id = UUID()
		result.order.append(id)
		result.counters[id] = 0
	case let .remove(id):
		result.order = state.order.filter { $0 != id }
		result.counters.removeValue(forKey: id)
		if state.selected == id {
			result.selected = nil
		}
	case let .increment(id):
		guard let value = state.counters[id] else { break }
		result.counters[id] = value + 1
	case let .decrement(id):
		guard let value = state.counters[id] else { break }
		result.counters[id] = value - 1
	case let .select(id):
		result.selected = id
	}
	return result
}

extension ObservableType where E == State {
	func deselect() -> Observable<Void> {
		return filter { $0.selected == nil }
			.map { _ in }
	}

	func counterText(for id: UUID) -> Observable<String> {
		return map { $0.counters[id] }
			.map { $0 != nil ? "\($0!)" : "" }
	}

	func counterTextForSelected() -> Observable<String> {
		return map { state in
			guard let selected = state.selected else { return "" }
			guard let value = state.counters[selected] else { return "" }
			return "\(value)"
		}
	}

	func showDetail() -> Observable<Void> {
		return map { $0.selected }
			.distinctUntilChanged()
			.unwrapOptional()
			.map { _ in }
	}

	func lastSelectedID() -> Observable<UUID> {
		return map { $0.selected }
			.unwrapOptional()
	}
}

typealias CounterStore = Store<State, Action>

extension UUID: Differentiable { }
