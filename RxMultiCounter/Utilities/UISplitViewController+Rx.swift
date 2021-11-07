//
//  UISplitViewController+Rx.swift
//  RxEarthquake
//
//  Created by Daniel Tartaglia on September 8, 2018.
//  Copyright © 2021 Daniel Tartaglia. MIT License.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UISplitViewController {
	var delegate: LayoutDelegateProxy {
		LayoutDelegateProxy.proxy(for: base)
	}

	var willChangeTo: Observable<UISplitViewController.DisplayMode> {
		delegate.methodInvoked(#selector(UISplitViewControllerDelegate.splitViewController(_:willChangeTo:)))
			.map { UISplitViewController.DisplayMode(rawValue: $0[1] as! Int)! }
	}
	
	func collapseSecondaryOntoPrimary<Source: ObservableType>(_ source: Source) -> Disposable where Source.Element == Bool {
		return source
			.bind(to: delegate._collapseSecondaryOntoPrimary)
	}
}

extension UISplitViewController: HasDelegate {
    public typealias Delegate = UISplitViewControllerDelegate
}

class LayoutDelegateProxy
    : DelegateProxy<UISplitViewController, UISplitViewControllerDelegate>
    , DelegateProxyType
    , UISplitViewControllerDelegate {

    init(parentObject: UISplitViewController) {
        super.init(parentObject: parentObject, delegateProxy: LayoutDelegateProxy.self)
    }

    deinit {
        _collapseSecondaryOntoPrimary.onCompleted()
    }

    public static func registerKnownImplementations() {
        self.register { LayoutDelegateProxy(parentObject: $0) }
    }

	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		return try! _collapseSecondaryOntoPrimary.value()
	}

	fileprivate let _collapseSecondaryOntoPrimary = BehaviorSubject<Bool>(value: false)
}
