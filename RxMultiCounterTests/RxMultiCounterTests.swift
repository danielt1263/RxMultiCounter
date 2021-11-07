//
//  RxMultiCounterTests.swift
//  RxMultiCounterTests
//
//  Created by Daniel Tartaglia on 11/6/21.
//

import RxTest
import XCTest
@testable import RxMultiCounter

class RxMultiCounterTests: XCTestCase {

	func testState() throws {
		let ids = [UUID(), UUID()]
		var idIndex: Int = 0
		func nextUUID() -> UUID {
			let result = ids[idIndex]
			idIndex += 1
			return result
		}
		let scheduler = TestScheduler(initialClock: 0)
		let addItem = scheduler.createColdObservable([.next(2, ()), .next(4, ())])
		let cellUpdate = scheduler.createColdObservable([.next(6, (Counter.ID(rawValue: ids[0]), 1)), .next(8, (Counter.ID(rawValue: ids[1]), -1)), .next(10, (Counter.ID(rawValue: ids[1]), -1))])
		let modelDeleted = scheduler.createColdObservable([.next(12, Counter.ID(rawValue: ids[0])), .next(14, Counter.ID(rawValue: ids[1]))])
		let state = scheduler.start {
			MasterLogic.state(
				addItem: addItem.asObservable(),
				cellUpdate: cellUpdate.asObservable(),
				modelDeleted: modelDeleted.asObservable(),
				uuid: nextUUID
			)
		}

		let firstCounter = Counter(id: Counter.ID(rawValue: ids[0]), value: 0)
		let secondCounter = Counter(id: Counter.ID(rawValue: ids[1]), value: 0)
		let firstCounterUpdated = Counter(id: Counter.ID(rawValue: ids[0]), value: 1)
		let secondCounterUpdated = Counter(id: Counter.ID(rawValue: ids[1]), value: -1)
		let secondCounterSecondUpdate = Counter(id: Counter.ID(rawValue: ids[1]), value: -2)
		XCTAssertEqual(state.events, [
			.next(202, [firstCounter]),
			.next(204, [firstCounter, secondCounter]),
			.next(206, [firstCounterUpdated, secondCounter]),
			.next(208, [firstCounterUpdated, secondCounterUpdated]),
			.next(210, [firstCounterUpdated, secondCounterSecondUpdate]),
			.next(212, [secondCounterSecondUpdate]),
			.next(214, [])
		])
	}
}
