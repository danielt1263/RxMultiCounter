//
//  MasterLogic.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 11/6/21.
//

import Cause_Logic_Effect
import Foundation
import RxDataSources
import RxSwift

enum MasterLogic {
	enum Action {
		case addCounter
		case updateCounter(Counter.ID, Int)
		case delete(Counter.ID)
	}

	static func state(addItem: Observable<Void>, cellUpdate: Observable<(Counter.ID, Int)>, modelDeleted: Observable<Counter.ID>, uuid: @escaping () -> UUID) -> Observable<[Counter]> {
		return Observable.merge(
			addItem.map(to: Action.addCounter),
			cellUpdate.map { Action.updateCounter($0.0, $0.1) },
			modelDeleted.map { Action.delete($0) }
		)
			.scan(into: [Counter]()) { state, action in
				switch action {
				case .addCounter:
					state.append(Counter(uuid: uuid()))
				case let .updateCounter(id, value):
					guard let index = state.firstIndex(where: { $0.id == id }) else { break }
					state[index].value += value
				case let .delete(id):
					guard let index = state.firstIndex(where: { $0.id == id }) else { break }
					state.remove(at: index)
				}
			}
	}

	static func counterSections(state: Observable<[Counter]>) -> Observable<[CounterSection]> {
		state
			.map { [CounterSection(model: "", items: $0.map { $0.id })] }
	}
}

extension Identifier: IdentifiableType {
	public var identity: Identifier { self }
}

typealias CounterSection = AnimatableSectionModel<String, Counter.ID>

struct Counter: Identifiable, Equatable {
	let id: Identifier<UUID, Counter>
	var value: Int
}

private extension Counter {
	init(uuid: UUID) {
		id = ID(rawValue: uuid)
		value = 0
	}
}
