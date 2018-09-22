//
//  UnwrapOptional.swift
//  RxMultiCounter
//
//  Created by Daniel Tartaglia on 9/18/18.
//  Copyright © 2018 Daniel Tartaglia. MIT License.
//

import RxSwift


extension ObservableType {

	/**
	Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.

	- returns: An observable sequence of non-optional elements
	*/

	public func unwrapOptional<T>() -> Observable<T> where E == T? {
		return self.filter { $0 != nil }.map { $0! }
	}
}
