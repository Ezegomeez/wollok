package org.uqbar.project.wollok.typesystem.annotations

class WollokCoreTypeDeclarations extends TypeDeclarations {
	override declarations() {
		Boolean >> "||" === #[Boolean] => Boolean
		Boolean >> "&&" === #[Boolean] => Boolean
		Boolean >> "and" === #[Boolean] => Boolean
		Boolean >> "or" === #[Boolean] => Boolean

		Integer + Integer => Integer
		Integer - Integer => Integer
		Integer * Integer => Integer
		Integer >> "/" === #[Integer] => Integer
		Integer >> ">" === #[Integer] => Boolean
		Integer >> "<" === #[Integer] => Boolean
		Integer >> ">=" === #[Integer] => Boolean
		Integer >> "<=" === #[Integer] => Boolean

		Double + Number => Double
		Double * Number => Double
		Double >> "/" === #[Number] => Double;
		(Double > Double) => Boolean

		String >> "size" === #[] => Integer
		String + String => String;
		(String > String) => Boolean

		Collection >> "add" === #[ELEMENT] => Void
		Collection >> "remove" === #[ELEMENT] => Void
		Collection >> "forEach" === #[closure(#[ELEMENT], ELEMENT)] => Void
		Collection >> "clear" === #[] => Void
		Collection + Collection => Collection

		List + List => List
		List >> "add" === #[ELEMENT] => Void
		List >> "contains" === #[ELEMENT] => Boolean
		List >> "first" === #[] => ELEMENT
		List >> "last" === #[] => ELEMENT
		List >> "size" === #[] => Integer

		List >> "sum" === #[closure(#[ELEMENT], Integer)] => Integer
		
		Range >> "sum" === #[closure(#[ELEMENT], Integer)] => Integer
		 
		Set + Set => Set;
		
		(Date > Date) => Boolean

		// console
		console >> "println" === #[Any] => Void
	}
}
