//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A memoized relation representing a surjective function.
public struct Surjection<T: Equatable, U: Equatable> {
	/// Constructs a surjection from a `function`.
	public init(_ function: T -> U) {
		let values = MutableBox<[(T, U)]>([])

		domain = DomainOf<T, U>({ values.value.count }, { values.value[$0] }) { element in
			if let index = find(values.value, { first, _ in first == element }) {
				return values.value[index].1
			} else {
				let mapped = function(element)
				values.value.append((element, mapped))
				return mapped
			}
		}

		codomain = DomainOf<U, T>({ values.value.count }, { flip(values.value[$0]) }) { element in
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
public struct DomainOf<T, U>: CollectionType {
	/// Returns the value related to `key` through the receiver’s function, if any.
	public subscript (key: T) -> U? {
		return function(key)
	}


	// MARK: SequenceType

	public func generate() -> IndexingGenerator<DomainOf> {
		return IndexingGenerator(self)
	}


	// MARK: CollectionType

	public subscript (index: Int) -> (T, U) {
		return at(index)
	}

	public var startIndex: Int { return 0 }
	public var endIndex: Int { return count() }


	// MARK: Private

	/// Constructs a `DomainOf` from a function.
	private init(_ count: () -> Int, _ at: Int -> (T, U), _ function: T -> U?) {
		self.function = function
		self.count = count
		self.at = at
	}

	/// The function which provides the elements of the receiver.
	private let function: T -> U?
	private let count: () -> Int
	private let at: Int -> (T, U)
}


/// Returns the index of the first element of `domain` for which `predicate` returns `true`, if any. Otherwise, returns `nil`.
private func find<C: CollectionType, B: BooleanType>(domain: C, predicate: C.Generator.Element -> B) -> C.Index? {
	for each in indices(domain) {
		if predicate(domain[each]) { return each }
	}
	return nil
}

/// Returns a pair with its order flipped.
private func flip<T, U>(x: (T, U)) -> (U, T) {
	return (x.1, x.0)
}


// MARK: - Imports

import Box
