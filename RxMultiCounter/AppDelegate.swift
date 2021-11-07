//
//  AppDelegate.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 11/6/21.
//

import Cause_Logic_Effect
import RxSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		window = UIWindow()
		window?.rootViewController = UISplitViewController().configure { $0.connect() }
		window?.makeKeyAndVisible()

#if DEBUG
		_ = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
			.map(to: ())
			.flatMap { Observable.just(RxSwift.Resources.total) }
			.distinctUntilChanged()
			.subscribe(onNext: { print("♦️ Resource count \($0)") })
#endif

		return true
	}
}
