//
//  MasterViewController.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 11/6/21.
//

import RxSwift
import UIKit

final class MasterViewController: UITableViewController {

	var addItem: UIBarButtonItem!

	let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		addItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
	}
}

class MasterTableViewCell: UITableViewCell {

	@IBOutlet var countLabel: UILabel!
	@IBOutlet var incrementButton: UIButton!
	@IBOutlet var decrementButton: UIButton!

	private (set) var disposeBag = DisposeBag()

	override func prepareForReuse() {
		super.prepareForReuse()
		disposeBag = DisposeBag()
	}
}
