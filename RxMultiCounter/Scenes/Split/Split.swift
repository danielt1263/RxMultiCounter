//
//  Split.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 11/6/21.
//

import Cause_Logic_Effect
import RxEnumKit
import RxSwift
import UIKit

extension UISplitViewController {
	func connect() {
		let master = MasterViewController.create { $0.connect() }

		preferredDisplayMode = .allVisible
		viewControllers = [
			UINavigationController(rootViewController: master)
		]
	}
}
