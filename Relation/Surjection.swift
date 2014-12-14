//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A memoized relation representing a surjective function.
public struct Surjection<T: Equatable, U: Equatable> {
	/// Constructs a surjection from a `function`.
	public init(_ function: T -> U) {
		let values = MutableBox<[(T, U)]>([])

		domain = DomainOf<T, U> { element in
			if let index = find(values.value, { first, _ in first == element }) {
				return values.value[index].1
			} else {
				let mapped = function(element)
				values.value.append((element, mapped))
				return mapped
			}
		}

		codomain = DomainOf<U, T> { element in
			find(values.value) { _, second in second == element }.map { values.value[$0].0 }
		}
	}


	// MARK: Properties

	/// The subscriptable domain of elements from `T` to `U`.
	///
	/// The domain of a surjection is total.
	public let domain: DomainOf<T, U>

	/// The subscriptable domain of elements from `U` to `T`.
	///
	/// The codomain of a surjection may be partial.
	public let codomain: DomainOf<U, T>
}


/// The memoized domain of a unary function.
public struct DomainOf<T, U> {
	/// Returns the value related to `key` through the receiver’s function, if any.
	public subscript (key: T) -> U? {
		return function(key)
	}


	// MARK: Private

	/// Constructs a `DomainOf` from a function.
	private init(_ function: T -> U?) {
		self.function = function
	}

	/// The function which provides the elements of the receiver.
	private let function: T -> U?
}


/// Returns the index of the first element of `domain` for which `predicate` returns `true`, if any. Otherwise, returns `nil`.
private func find<C: CollectionType, B: BooleanType>(domain: C, predicate: C.Generator.Element -> B) -> C.Index? {
	for each in indices(domain) {
		if predicate(domain[each]) { return each }
	}
	return nil
}


// MARK: - Imports

import Box
