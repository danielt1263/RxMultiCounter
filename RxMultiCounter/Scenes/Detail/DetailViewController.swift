//
//  DetailViewController.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 11/6/21.
//

import Cause_Logic_Effect
import RxCocoa
import RxSwift
import UIKit

final class DetailViewController: UIViewController {
	var countLabel: UILabel!
	var incrementButton: UIButton!
	var decrementButton: UIButton!
	let disposeBag = DisposeBag()

	override func loadView() {
		super.loadView()
		view.backgroundColor = .white
		decrementButton = UIButton(type: .system).setup {
			$0.setTitle("-", for: .normal)
		}
		countLabel = UILabel().setup {
			$0.font = .monospacedDigitSystemFont(ofSize: 17, weight: .medium)
		}
		incrementButton = UIButton(type: .system).setup {
			$0.setTitle("+", for: .normal)
		}
		let rootStackView = UIStackView(arrangedSubviews: [
			countLabel,
			incrementButton,
			decrementButton
		]).setup {
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
		view.addSubview(rootStackView)
		NSLayoutConstraint.activate([
			rootStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
			rootStackView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
		])
	}
}
