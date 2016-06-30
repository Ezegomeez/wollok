package lang {
 
	/**
	 * Base class for all Exceptions.
	 * Every exception and its subclasses indicates conditions that a reasonable application might want to catch.
	 * 
	 * @author jfernandes
	 * @since 1.0
	 */
	class Exception {
		const message
		const cause
	
		/** Constructs a new exception with no detailed message. */
		constructor()
		/** Constructs a new exception with the specified detail message. */
		constructor(_message) = self(_message, null)
		/** Constructs a new exception with the specified detail message and cause. */
		constructor(_message, _cause) { message = _message ; cause = _cause }
		
		/** Prints this exception and its backtrace to the console */
		method printStackTrace() { self.printStackTrace(console) }

		/** Prints this exception and its backtrace as a string value */
		method getStackTraceAsString() {
			const printer = new StringPrinter()
			self.printStackTrace(printer)
			return printer.getBuffer()
		}
		
		/** Prints this exception and its backtrace to the specified printer */
		method printStackTrace(printer) { self.printStackTraceWithPreffix("", printer) }
		
		/** @private */
		method printStackTraceWithPreffix(preffix, printer) {
			printer.println(preffix +  self.className() + (if (message != null) (": " + message.toString()) else "")
			
			// TODO: eventually we will need a stringbuffer or something to avoid memory consumption
			self.getStackTrace().forEach { e =>
				printer.println("\tat " + e.contextDescription() + " [" + e.location() + "]")
			}
			
			if (cause != null)
				cause.printStackTraceWithPreffix("Caused by: ", printer)
		}
		
		/** @private */
		method createStackTraceElement(contextDescription, location) = new StackTraceElement(contextDescription, location)
		
		/** Provides programmatic access to the stack trace information printed by printStackTrace(). */
		method getStackTrace() native
		
		/** Returns the detail message string of this exception. */
		method getMessage() = message
	}
	
	/**
	 * An exception that is thrown when a specified element cannot be found
	 */
	class ElementNotFoundException inherits Exception {
		constructor(_message) = super(_message)
		constructor(_message, _cause) = super(_message, _cause)
	}

	/**
	 * An exception that is thrown when an object cannot understand a certain message
	 */
	class MessageNotUnderstoodException inherits Exception {
		constructor()
		constructor(_message) = super(_message)
		constructor(_message, _cause) = super(_message, _cause)
		
		/*
		'''«super.getMessage()»
			«FOR m : wollokStack»
			«(m as WExpression).method?.declaringContext?.contextName».«(m as WExpression).method?.name»():«NodeModelUtils.findActualNodeFor(m).textRegionWithLineInformation.lineNumber»
			«ENDFOR»
			'''
		*/
	}
	
	/**
	 * An element in a stack trace, represented by a context and a location of a method where a message was sent
	 */
	class StackTraceElement {
		const contextDescription
		const location
		constructor(_contextDescription, _location) {
			contextDescription = _contextDescription
			location = _location
		}
		method contextDescription() = contextDescription
		method location() = location
	}
	
	/**
	 *
	 * Representation of Wollok Object
	 *
	 * Class Object is the root of the class hierarchy. Every class has Object as a superclass.  
	 * 
	 * @author jfernandes
	 * since 1.0
	 */
	class Object {
		/** Returns object identity of a Wollok object, represented by a unique number in Wollok environment */
		method identity() native
		/** Returns a list of instance variables for this Wollok object */
		method instanceVariables() native
		/** Retrieves a specific variable. Expects a name */
		method instanceVariableFor(name) native
		/** Accesses a variable by name, in a reflexive way. */
		method resolve(name) native
		/** Object description in english/spanish/... (depending on i18n configuration)
		 *
		 * Examples:
		 * 		"2".kindName()  => returns "a String"
		 *  	2.kindName()    => returns "a Integer"
		 */
		method kindName() native
		/** Full name of Wollok object class */
		method className() native
		
		/**
		 * Tells whether self object is "equal" to the given object
		 * The default behavior compares them in terms of identity (===)
		 */
		method ==(other) {
			return self === other
		}
		
		/** Tells whether self object is not equals to the given one */
		method !=(other) = ! (self == other)
		
		/**
		 * Tells whether self object is identical (the same) to the given one.
		 * It does it by comparing their identities.
		 * So self basically relies on the wollok.lang.Integer equality (which is native)
		 */
		method ===(other) {
			return self.identity() == other.identity()
		}

		/**
		 * o1.equals(o2) is a synonym for o1 == o2
		 */
		method equals(other) = self == other

		/**
		 * Generates a Pair key-value association. @see Pair.
		 */
		method ->(other) {
			return new Pair(self, other)
		}

		/**
		 * String representation of Wollok object
		 */
		method toString() {
			// TODO: should be a set
			// return self.toSmartString(#{})
			return self.toSmartString([])
		}

		/** @private */
		method toSmartString(alreadyShown) {
			if (alreadyShown.any { e => e.identity() == self.identity() } ) { 
				return self.simplifiedToSmartString() 
			}
			else {
				alreadyShown.add(self)
				return self.internalToSmartString(alreadyShown)
			}
		} 
		
		/** @private */
		method simplifiedToSmartString(){
			return self.kindName()
		}
		
		/** @private */
		method internalToSmartString(alreadyShown) {
			return self.kindName() + "[" 
				+ self.instanceVariables().map { v => 
					v.name() + "=" + v.valueToSmartString(alreadyShown)
				}.join(', ') 
			+ "]"
		}
		
		/** @private */
		method messageNotUnderstood(name, parameters) {
			var message = if (name != "toString") 
						self.toString()
					 else 
					 	self.kindName()
			message += " does not understand " + name
			if (parameters.size() > 0)
				message += "(" + (0..(parameters.size()-1)).map { i => "p" + i }.join(',') + ")"
			else
				message += "()"
			throw new MessageNotUnderstoodException(message)
		}

		/** Builds an exception with a message */		
		method error(message) {
			throw new Exception(message)
		}
	}
	
	/** Representation for methods that only have side effects */
	object void { }
	
	/** 
	 * Representation of a Key/Value Association.
	 * It is also useful if you want to model a Point. 
	 */
	class Pair {
		const x
		const y
		constructor (_x, _y) {
			x = _x
			y = _y
		}
		method getX() { return x }
		method getY() { return y }
		method getKey() { return self.getX() }
		method getValue() { return self.getY() }
	}

	/**
	 * The root class in the collection hierarchy. 
	 * A collection represents a group of objects, known as its elements.
	 */	
	class Collection {
		/**
		  * Returns the element that is considered to be/have the maximum value.
		  * The criteria is given by a closure that receives a single element as input (one of the element)
		  * The closure must return a comparable value (something that understands the >, >= messages).
		  * Example:
		  *       ["a", "ab", "abc", "d" ].max({ e => e.length() })    =>  returns "abc"		 
		  */
		method max(closure) = self.absolute(closure, { a, b => a > b })

		/**
		  * Returns the element that represents the maximum value in the collection.
		  * The criteria is by direct comparison of the elements.
		  * Example:
		  *       [11, 1, 4, 8, 3, 15, 6].max()    =>  returns 15		 
		  */
		method max() = self.max({it => it})		
		
		/**
		  * Returns the element that is considered to be/have the minimum value.
		  * The criteria is given by a closure that receives a single element as input (one of the element)
		  * The closure must return a comparable value (something that understands the <, <= messages).
		  * Example:
		  *       ["ab", "abc", "hello", "wollok world"].min({ e => e.length() })    =>  returns "ab"		 
		  */
		method min(closure) = self.absolute(closure, { a, b => a < b} )
		
		/**
		  * Returns the element that represents the minimum value in the collection.
		  * The criteria is by direct comparison of the elements.
		  * Example:
		  *       [11, 1, 4, 8, 3, 15, 6].min()    =>  returns 1 
		  */
		method min() = self.min({it => it})

		/** @private */
		method absolute(closure, criteria) {
			if (self.isEmpty())
				throw new ElementNotFoundException("collection is empty")
			const result = self.fold(null, { acc, e =>
				const n = closure.apply(e) 
				if (acc == null)
					new Pair(e, n)
				else {
					if (criteria.apply(n, acc.getY()))
						new Pair(e, n)
					else
						acc
				}
			})
			return result.getX()
		}
		 
		// non-native methods

		/**
		  * Concatenates this collection to all elements from the given collection parameter giving a new collection
		  * (no side effect) 
		  */
		method +(elements) {
			const newCol = self.copy() 
			newCol.addAll(elements)
			return newCol 
		}
		
		/**
		  * Adds all elements from the given collection parameter to self collection. This is a side-effect operation.
		  */
		method addAll(elements) { elements.forEach { e => self.add(e) } }
		
		/**
		  * Removes all elements of the given collection parameter from self collection. This is a side-effect operation.
		  */
		method removeAll(elements) { 
			elements.forEach { e => self.remove(e) } 
		}
		
		/**
		 * Removes those elements that meet a given condition. This is a side-effect operation.
		 */
		 method removeAllSuchThat(closure) {
		 	self.removeAll( self.filter(closure) )
		 }

		/** Tells whether self collection has no elements */
		method isEmpty() = self.size() == 0
				
		/**
		 * Performs an operation on every element of self collection.
		 * The logic to execute is passed as a closure that takes a single parameter.
		 * @returns nothing
		 * Example:
		 *      plants.forEach { plant => plant.takeSomeWater() }
		 */
		method forEach(closure) { self.fold(null, { acc, e => closure.apply(e) }) }
		
		/**
		 * Answers whether all the elements of self collection satisfy a given condition
		 * The condition is a closure argument that takes a single element and returns a boolean value.
		 * @returns true/false
		 * Example:
		 *      plants.all({ plant => plant.hasFlowers() })
		 */
		method all(predicate) = self.fold(true, { acc, e => if (!acc) acc else predicate.apply(e) })
		
		/**
		 * Tells whether at least one element of self collection satisfies a given condition.
		 * The condition is a closure argument that takes a single element and returns a boolean value.
		 * @returns true/false
		 * Example:
		 *      plants.any({ plant => plant.hasFlowers() })
		 */
		method any(predicate) = self.fold(false, { acc, e => if (acc) acc else predicate.apply(e) })
		
		/**
		 * Returns the element of self collection that satisfies a given condition.
		 * If more than one element satisfies the condition then it depends on the specific collection class which element
		 * will be returned
		 * @returns the element that complies the condition
		 * @throws ElementNotFoundException if no element matched the given predicate
		 * Example:
		 *      users.find { user => user.name() == "Cosme Fulanito" }
		 */
		method find(predicate) = self.findOrElse(predicate, { 
			throw new ElementNotFoundException("there is no element that satisfies the predicate")
		})

		/**
		 * Returns the element of self collection that satisfies a given condition, 
		 * or the given default otherwise, if no element matched the predicate.
		 * If more than one element satisfies the condition then it depends on the specific
		 * collection class which element
		 * will be returned
		 * @returns the element that complies the condition or the default value
		 * Example:
		 *      users.findOrDefault({ user => user.name() == "Cosme Fulanito" }, homer)
		 */
		method findOrDefault(predicate, value) =  self.findOrElse(predicate, { value })
		
		/**
		 * Returns the element of self collection that satisfies a given condition, 
		 * or the the result of evaluating the given continuation. 
		 * If more than one element satisfies the condition then it depends on the
		 * specific collection class which element
		 * will be returned
		 * @returns the element that complies the condition or the result of evaluating the continuation
		 * Example:
		 *      users.findOrElse({ user => user.name() == "Cosme Fulanito" }, { homer })
		 */
		method findOrElse(predicate, continuation) native

		/**
		 * Counts all elements of self collection that satisfies a given condition
		 * The condition is a closure argument that takes a single element and returns a number.
		 * @returns an integer number
		 * Example:
		 *      plants.count { plant => plant.hasFlowers() }
		 */
		method count(predicate) = self.fold(0, { acc, e => if (predicate.apply(e)) acc++ else acc  })

		/**
		 * Counts the occurrences of a given element in self collection.
		 * @returns an integer number
		 * Example:
		 *      [1, 8, 4, 1].occurrencesOf(1)	=> returns 2
		 */
		method occurrencesOf(element) = self.count({it => it == element})
		
		/**
		 * Collects the sum of each value for all elements.
		 * This is similar to call a map {} to transform each element into a number object and then adding all those numbers.
		 * The condition is a closure argument that takes a single element and returns a boolean value.
		 * @returns an integer
		 * Example:
		 *      const totalNumberOfFlowers = plants.sum{ plant => plant.numberOfFlowers() }
		 */
		method sum(closure) = self.fold(0, { acc, e => acc + closure.apply(e) })
		
		/**
		 * Sums all elements in the collection.
		 * @returns an integer
		 * Example:
		 *      const total = [1, 2, 3, 4, 5].sum() 
		 */
		method sum() = self.sum( {it => it} )
		
		/**
		 * Returns a new collection that contains the result of transforming each of self collection's elements
		 * using a given closure.
		 * The condition is a closure argument that takes a single element and returns an object.
		 * @returns another collection (same type as self one)
		 * Example:
		 *      const ages = users.map({ user => user.age() })
		 */
		method map(closure) = self.fold(self.newInstance(), { acc, e =>
			 acc.add(closure.apply(e))
			 acc
		})
		
		/**
		 * Map + flatten operation
		 * @see map
		 * @see flatten
		 * 
		 * Example
		 * 		object klaus {	var languages = ["c", "cobol", "pascal"]
		 *  		method languages() = languages
		 *		}
		 *		object fritz {	var languages = ["java", "perl"]
		 * 			method languages() = languages
		 * 		}
		 * 		program abc {
		 * 			console.println([klaus, fritz].flatMap({ person => person.languages() }))
		 *				=> returns ["c", "cobol", "pascal", "java", "perl"]
		 * 		}	
		 */
		method flatMap(closure) = self.fold(self.newInstance(), { acc, e =>
			acc.addAll(closure.apply(e))
			acc
		})

		/**
		 * Returns a new collection that contains the elements that meet a given condition.
		 * The condition is a closure argument that takes a single element and returns a boolean.
		 * @returns another collection (same type as self one)
		 * Example:
		 *      const overageUsers = users.filter({ user => user.age() >= 18 })
		 */
		 method filter(closure) = self.fold(self.newInstance(), { acc, e =>
			 if (closure.apply(e))
			 	acc.add(e)
			 acc
		})

		/**
		 * Returns true if this collection contains the specified element.
		 */
		method contains(e) = self.any {one => e == one }
		
		/**
		 * Flattens a collection of collections
		 *
		 * Example:
		 * 		[ [1, 2], [3], [4, 0] ].flatten()  => returns [1, 2, 3, 4, 0]
		 *
		 */
		method flatten() = self.flatMap { e => e }
		
		/** @private */
		override method internalToSmartString(alreadyShown) {
			return self.toStringPrefix() + self.map{e=> e.toSmartString(alreadyShown) }.join(', ') + self.toStringSufix()
		}
		
		/** @private */
		method toStringPrefix()
		
		/** @private */
		method toStringSufix()
		
		/** Converts a collection to a list */
		method asList()
		
		/** Converts a collection to a set (no duplicates) */
		method asSet()

		/**
		 * Returns a new collection of the same type and with the same content 
		 * as self.
		 * @returns a new collection
		 * Example:
		 *      const usersCopy = users.copy() 
		 */
		method copy() {
			var copy = self.newInstance()
			copy.addAll(self)
			return copy
		}
		
		/**
		 * Returns a new List that contains the elements of self collection 
		 * sorted by a criteria given by a closure. The closure receives two objects
		 * X and Y and returns a boolean, true if X should come before Y in the 
		 * resulting collection.
		 * @returns a new List
		 * Example:
		 *      const usersByAge = users.sortedBy({ a, b => a.age() < b.age() }) 
		 */
		method sortedBy(closure) = self.copy().asList().sortBy(closure)
		
		/**
		 * Returns a new, empty collection of the same type as self.
		 * @returns a new collection
		 * Example:
		 *      const newCollection = users.newInstance() 
		 */
		method newInstance()
		
	}

	/**
	 *
	 * A collection that contains no duplicate elements. 
	 * It models the mathematical set abstraction. A Set guarantees no order of elements.
	 * 
	 * @author jfernandes
	 * @since 1.3
	 */	
	class Set inherits Collection {
		constructor(elements ...) {
			self.addAll(elements)
		}
		
		/** @private */
		override method newInstance() = #{}
		
		/** @private */
		override method toStringPrefix() = "#{"
		
		/** @private */
		override method toStringSufix() = "}"
		
		/** 
		 * Converts this set to a list
		 * @see List
		 */
		override method asList() { 
			const result = []
			result.addAll(self)
			return result
		}
		
		/**
		 * Converts an object to a Set. No effect on Sets.
		 */
		override method asSet() = self

		/**
		 * Returns any element of this collection 
		 */
		override method anyOne() native

		/**
		 * Returns a new Set with the elements of both self and another collection.
		 * @returns a Set
		 */
		 method union(another) = self + another

		/**
		 * Returns a new Set with the elements of self that exist in another collection
		 * @returns a Set
		 */
		 method intersection(another) = 
		 	self.filter({it => another.contains(it)})
		 	
		/**
		 * Returns a new Set with the elements of self that don't exist in another collection
		 * @returns a Set
		 */
		 method difference(another) =
		 	self.filter({it => not another.contains(it)})
		
		// REFACTORME: DUP METHODS
		/** 
		 * Reduce a collection to a certain value, beginning with a seed or initial value
		 * 
		 * Examples
		 * 		#{1, 9, 3, 8}.fold(0, {acum, each => acum + each}) => returns 21, the sum of all elements
		 *
		 * 		var numbers = #{3, 2, 9, 1, 7}
		 * 		numbers.fold(numbers.anyOne(), { acum, number => acum.max(number) }) => returns 9, the maximum of all elements
         *
		 */
		method fold(initialValue, closure) native
		
		/**
		 * Tries to find an element in a collection (based on a closure) or
		 * applies a continuation closure.
		 *
		 * Examples:
		 * 		#{1, 9, 3, 8}.findOrElse({ n => n.even() }, { 100 })  => returns  8
		 * 		#{1, 5, 3, 7}.findOrElse({ n => n.even() }, { 100 })  => returns  100
		 */
		method findOrElse(predicate, continuation) native
		
		/**
		 * Adds the specified element to this set if it is not already present
		 */
		method add(element) native
		
		/**
		 * Removes the specified element from this set if it is present
		 */
		method remove(element) native
		
		/** Returns the number of elements in this set (its cardinality) */
		method size() native
		
		/** Removes all of the elements from this set */
		method clear() native

		/**
		 * Returns the concatenated string representation of the elements in the given set.
		 * You can pass an optional character as an element separator (default is ",")
		 *
		 * Examples:
		 * 		[1, 5, 3, 7].join(":") => returns "1:5:3:7"
		 * 		["you","will","love","wollok"].join(" ") => returns "you will love wollok"
		 * 		["you","will","love","wollok"].join()    => returns "you,will,love,wollok"
		 */
		method join(separator) native
		method join() native
		
		/**
		 * @see Object#equals
		 */
		method equals(other) native
		
		/**
		 * @see Object#==
		 */
		method ==(other) native
	}
	
	/**
	 *
	 * An ordered collection (also known as a sequence). 
	 * You iterate the list the same order elements are inserted. 
	 * The user can access elements by their integer index (position in the list).
	 * A List can contain duplicate elements.
	 *
	 * @author jfernandes
	 * @since 1.3
	 */
	class List inherits Collection {

		/** Returns the element at the specified position in this list.
		 * The first char value of the sequence is at index 0, the next at index 1, and so on, as for array indexing. 
		 */
		method get(index) native
		
		/** Creates a new list */
		override method newInstance() = []
		
		/**
		 * Returns any element of this collection 
		 */
		method anyOne() {
			if (self.isEmpty()) 
				throw new Exception("Illegal operation 'anyOne' on empty collection")
			else 
				return self.get(0.randomUpTo(self.size()))
		}
		
		/**
		 * Returns first element of the non-empty list
		 * @returns first element
		 *
		 * Example:
		 *		[1, 2, 3, 4].first()	=> returns 1
		 */
		method first() = self.head()
		
		/**
		 * Synonym for first method 
		 */
		method head() = self.get(0)
		
		/**
		 * Returns the last element of the non-empty list.
		 * @returns last element
		 * Example:
		 *		[1, 2, 3, 4].last()		=> returns 4	
		 */
		method last() = self.get(self.size() - 1)

		/** @private */		 
		override method toStringPrefix() = "["
		
		/** @private */
		override method toStringSufix() = "]"

		/** 
		 * Converts this collection to a list. No effect on Lists.
		 * @see List
		 */
		override method asList() = self
		
		/** 
		 * Converts this list to a set (removing duplicate elements)
		 * @see List
		 */
		override method asSet() { 
			const result = #{}
			result.addAll(self)
			return result
		}
		
		/** 
		 * Returns a view of the portion of this list between the specified fromIndex 
		 * and toIndex, both inclusive. Remember first element is position 0, second is position 1, and so on.
		 * If toIndex exceeds length of list, no error is thrown.
		 *
		 * Example:
		 *		[1, 5, 3, 2, 7, 9].subList(2, 3)		=> returns [3, 2]	
		 *		[1, 5, 3, 2, 7, 9].subList(4, 6)		=> returns [7, 9] 
		 */
		method subList(start,end) {
			if(self.isEmpty)
				return self.newInstance()
			const newList = self.newInstance()
			const _start = start.limitBetween(0,self.size()-1)
			const _end = end.limitBetween(0,self.size()-1)
			(_start.._end).forEach { i => newList.add(self.get(i)) }
			return newList
		}
		 
		/**
		 * @see List#sortedBy
		 */
		method sortBy(closure) native
		
		/**
		 * Takes first n elements of a list
		 *
		 * Examples:
		 * 		[1,9,2,3].take(5)  ==> returns [1, 9, 2, 3]
		 *  	[1,9,2,3].take(2)  ==> returns [1, 9]
		 *  	[1,9,2,3].take(-2)  ==> returns []		 
		 */
		method take(n) =
			if(n <= 0)
				self.newInstance()
			else
				self.subList(0,n-1)
			
		
		/**
		 * Returns a new list dropping first n elements of a list. 
		 * This operation has no side effect.
		 *
		 * Examples:
		 * 		[1, 9, 2, 3].drop(3)  ==> returns [3]
		 * 		[1, 9, 2, 3].drop(1)  ==> returns [9, 2, 3]
		 * 		[1, 9, 2, 3].drop(-2) ==> returns [1, 9, 2, 3]
		 */
		method drop(n) = 
			if(n >= self.size())
				self.newInstance()
			else
				self.subList(n,self.size()-1)
			
		/**
		 * Returns a new list reversing the elements, so that first element becomes last element of the new list and so on.
		 * This operation has no side effect.
		 * 
		 * Example:
		 *  	[1, 9, 2, 3].reverse()  ==> returns [3, 2, 9, 1]
		 *
		 */
		method reverse() = self.subList(self.size()-1,0)
	
		// REFACTORME: DUP METHODS
		/** 
		 * Reduce a collection to a certain value, beginning with a seed or initial value
		 * 
		 * Examples
		 * 		#{1, 9, 3, 8}.fold(0, {acum, each => acum + each}) => returns 21, the sum of all elements
		 *
		 * 		var numbers = #{3, 2, 9, 1, 7}
		 * 		numbers.fold(numbers.anyOne(), { acum, number => acum.max(number) }) => returns 9, the maximum of all elements
         *
		 */
		method fold(initialValue, closure) native
		
		/**
		 * Finds the first element matching the boolean closure, 
		 * or evaluates the continuation block closure if no element is found
		 */
		method findOrElse(predicate, continuation) native
		
		/** Adds the specified element as last one */
		method add(element) native
		
		/** Removes an element in this list */ 
		method remove(element) native
		
		/** Returns the number of elements */
		method size() native
		
		/** Removes all of the mappings from this Dictionary. This is a side-effect operation. */
		method clear() native

		/**
		 * Returns the concatenated string representation of the elements in the given set.
		 * You can pass an optional character as an element separator (default is ",")
		 *
		 * Examples:
		 * 		[1, 5, 3, 7].join(":") => returns "1:5:3:7"
		 * 		["you","will","love","wollok"].join(" ") => returns "you will love wollok"
		 * 		["you","will","love","wollok"].join()    => returns "you,will,love,wollok"
		 */
		method join(separator) native
		method join() native
		
		/**
		 * @see == message
		 */
		method equals(other) native
		
		/** A list is == another list if all elements are equal (defined by == message) */
		method ==(other) native
	}
	
	/**
	 * Represents a set of key -> values
	 * 
	 */
	class Dictionary {
	
		constructor() { }
		
		/**
		 * Adds or updates a value based on a key
		 */
		method put(_key, _value) native
		
		/**
		 * Returns the value to which the specified key is mapped, or null if this Dictionary contains no mapping for the key.
		 */
		method basicGet(_key) native

		/**
		 * Returns the value to which the specified key is mapped, or evaluates a non-parameter closure otherwise 
		 */
		method getOrElse(_key, _closure) {
			const value = self.basicGet(_key)
			if (value == null) 
				_closure.apply()
			else 
				return value
		}
		
		/**
		 * Returns the value to which the specified key is mapped. 
		 * If this Dictionary contains no mapping for the key, an error is thrown.
		 */
		method get(_key) = self.getOrElse(_key,{ => throw new ElementNotFoundException("there is no element associated with key " + _key) })

		/**
		 * Returns the number of key-value mappings in this Dictionary.
		 */
		method size() = self.values().size()
		
		/**
		 * Returns whether the dictionary has no elements
		 */
		method isEmpty() = self.size() == 0
		
		/**
		 * Returns true if this Dictionary contains a mapping for the specified key.
		 */
		method containsKey(_key) = self.keys().contains(_key)
		
		/**
		 * Returns true if this Dictionary maps one or more keys to the specified value.
		 */
		method containsValue(_value) = self.values().contains(_value)
		
		/**
		 * Removes the mapping for a key from this Dictionary if it is present 
		 */
		method remove(_key) native
		
		/**
		 * Returns a list of the keys contained in this Dictionary.
		 */
		method keys() native
		
		/**
		 * Returns a list of the values contained in this Dictionary.
		 */
		method values() native
		
		/**
		 * Performs the given action for each entry in this Dictionary until all entries have been 
		 * processed or the action throws an exception.
		 * 
		 * Expected closure with two parameters: the first associated with key and second with value.
		 *
		 * Example:
		 * 		mapaTelefonos.forEach({ k, v => result += k.size() + v.size() })
		 * 
		 */
		method forEach(closure) native
		
		/** Removes all of the mappings from this Dictionary. This is a side-effect operation. */
		method clear() native
		
	}
	
	/**
	 *
	 * @author jfernandes
	 * @since 1.3
	 * @noInstantiate
	 */	
	class Number {
	
		/** 
		 * Returns the greater number between two
		 * Example:
		 * 		5.max(8)    ==> returns 8 
		 */
		method max(other) = if (self >= other) self else other
		
		/** Returns the lower number between two. @see max */
		method min(other) = if (self <= other) self else other
		
		/**
		 * Given self and a range of integer values, returns self if it is in that range
		 * or nearest value from self to that range 
		 *
		 * Examples
		 * 4.limitBetween(2, 10)   ==> returns 4, because 4 is in the range
		 * 4.limitBetween(6, 10)   ==> returns 6, because 4 is not in range 6..10, and 6 is nearest value to 4
		 * 4.limitBetween(1, 2)    ==> returns 2, because 4 is not in range 1..2, but 2 is nearest value to 4
		 *
		 */   
		method limitBetween(limitA,limitB) = if(limitA <= limitB) 
												limitA.max(self).min(limitB) 
											 else 
											 	limitB.max(self).min(limitA)

		/** @private */
		override method simplifiedToSmartString(){ return self.stringValue() }
		
		/** @private */
		override method internalToSmartString(alreadyShown) { return self.stringValue() }
		
		/** Returns true if self is between min and max */
		method between(min, max) { return (self >= min) && (self <= max) }
		
		/** Returns squareRoot of self
		 * 		9.squareRoot() => returns 3 
		 */
		method squareRoot() { return self ** 0.5 }
		
		/** Returns square of self
		 * 		3.square() => returns 9 
		 */
		method square() { return self * self }
		
		/** Returns whether self is an even number (divisible by 2, mathematically 2k) */
		method even() { return self % 2 == 0 }
		
		/** Returns whether self is an odd number (not divisible by 2, mathematically 2k + 1) */
		method odd() { return self.even().negate() }
		
		/** Returns remainder between self and other
		 * Example:
		 * 		5.rem(3) ==> returns 2
		 */
		method rem(other) { return self % other }
		
	}
	
	/**
	 * @author jfernandes
	 * @since 1.3
	 * @noInstantiate
	 */
	class Integer inherits Number {
		/**
		 * The whole wollok identity implementation is based on self method
		 */
		method ===(other) native
	
		method +(other) native
		method -(other) native
		method *(other) native
		method /(other) native
		
		/** Integer division between self and other
		 *
		 * Example:
		 *		8.div(3)  ==> returns 2
		 * 		15.div(5) ==> returns 3
		 */
		method div(other) native
		
		/**
		 * raisedTo
		 * 		3 ** 2 ==> returns 9
		 */
		method **(other) native
		
		/**
		 * Returns remainder of division between self and other
		 */
		method %(other) native
		
		/** String representation of self number */
		method toString() native
		
		/** Self as a String value. Equivalent: toString() */
		method stringValue() native	
		
		/** 
		 * Builds a Range between self and end
		 * 
		 * Example:
		 * 		1..4   returns ==> a new Range object from 1 to 4
		 */
		method ..(end) = new Range(self, end)
		
		method >(other) native
		method >=(other) native
		method <(other) native
		method <=(other) native

		/** 
		 * Returns absolute value of self 
		 *
		 * Example:
		 * 		2.abs() ==> 2
		 * 		(-3).abs() ==> 3 (be careful with parentheses)
		 */		
		method abs() native
		
		/**
		 * Inverts sign of self
		 *
		 * Example:
		 * 		3.invert() ==> returns -3
		 * 		(-2).invert() ==> returns 2 (be careful with parentheses)
		 */
		method invert() native
		
		/**
		 * greater common divisor
		 *
		 * Example:
		 * 		8.gcd(12) ==> returns 4
		 *		5.gcd(10) ==> returns 5
		 */
		method gcd(other) native
		
		/**
		 * least common multiple
		 *
		 * Example:
		 * 		3.lcm(4) ==> returns 12
		 * 		6.lcm(12) ==> returns 12
		 */
		method lcm(other) {
			const mcd = self.gcd(other)
			return self * (other / mcd)
		}
		
		/**
		 * number of digits of self (without sign)
		 */
		method digits() {
			var digits = self.toString().size()
			if (self < 0) {
				digits -= 1
			}
			return digits
		}
		
		/** Returns whether self is a prime number, like 2, 3, 5, 7, 11 ... */
		method isPrime() {
			if (self == 1) return false
			return (2..(self.div(2) + 1)).any({ i => self % i == 0 }).negate()
		}
		
		/**
		 * Returns a random between self and max
		 */
		method randomUpTo(max) native
		
		/**
		 * Executes the given action n times (n = self)
		 * Example:
		 * 		4.times({ i => console.println(i) }) ==> returns 
		 * 			1
		 * 			2
		 * 			3
		 * 			4
		 */
		method times(action) = (1..self).forEach(action)
	}
	
	/**
	 * @author jfernandes
	 * @since 1.3
	 * @noInstantiate
	 */
	class Double inherits Number {
		/** the whole wollok identity impl is based on self method */
		method ===(other) native
	
		method +(other) native
		method -(other) native
		method *(other) native
		method /(other) native
		
		/** Integer division between self and other
		 *
		 * Example:
		 *		8.2.div(3.3)  ==> returns 2
		 * 		15.0.div(5) ==> returns 3
		 */
		method div(other) native
		
		/**
		 * raisedTo
		 * 3.2 ** 2 ==> returns 10.24
		 */
		method **(other) native
		
		/**
		 * Returns remainder of division between self and other
		 */
		method %(other) native		
	
		/** String representation of a self number */
		method toString() native
		
		/** Self as a String value. Equivalent: toString() */
		method stringValue() native	
		
		method >(other) native
		method >=(other) native
		method <(other) native
		method <=(other) native
		
		/** 
		 * Returns absolute value of self 
		 *
		 * Example:
		 * 		2.7.abs() ==> returns 2.7
		 *		(-3.2).abs() ==> returns 3.2 (be careful with parentheses)
		 */		
		method abs() native
		
		/**
		 * 3.2.invert() ==> -3.2
		 * (-2.4).invert() ==> 2.4 (be careful with parentheses)
		 */
		method invert() native
		
		/**
		 * Returns a random between self and max
		 */
		method randomUpTo(max) native
	}
	
	/**
	 * Strings are constant; their values cannot be changed after they are created.
	 *
	 * @author jfernandes
	 * @noInstantiate
	 */
	class String {
		/** Returns the number of elements */
		method length() native
		
		/** 
		 * Returns the char value at the specified index. An index ranges from 0 to length() - 1. 
		 * The first char value of the sequence is at index 0, the next at index 1, and so on, as for array indexing.
		 */
		method charAt(index) native
		
		/** 
		 * Concatenates the specified string to the end of this string.
		 * Example:
		 * 		"cares" + "s" => returns "caress"
		 */
		method +(other) native
		
		/** 
		 * Tests if this string starts with the specified prefix. It is case sensitive.
		 *
		 * Examples:
		 * 		"mother".startsWith("moth")  ==> returns true
		 *      "mother".startsWith("Moth")  ==> returns false
		 */ 
		method startsWith(other) native
		
		/** Tests if this string ends with the specified suffix. It is case sensitive.
		 * @see startsWith
		 */
		method endsWith(other) native
		
		/** 
		 * Returns the index within this string of the first occurrence of the specified character.
		 * If character is not present, returns -1
		 * 
		 * Examples:
		 * 		"pototo".indexOf("o")  ==> returns 1
		 * 		"unpredictable".indexOf("o")  ==> returns -1 		
		 */
		method indexOf(other) native
		
		/**
		 * Returns the index within this string of the last occurrence of the specified character.
		 * If character is not present, returns -1
		 *
		 * Examples:
		 * 		"pototo".lastIndexOf("o")  ==> returns 5
		 * 		"unpredictable".lastIndexOf("o")  ==> returns -1 		
		 */
		method lastIndexOf(other) native
		
		/** Converts all of the characters in this String to lower case */
		method toLowerCase() native
		
		/** Converts all of the characters in this String to upper case */
		method toUpperCase() native
		
		/** 
		 * Returns a string whose value is this string, with any leading and trailing whitespace removed
		 * 
		 * Example:
		 * 		"   emptySpace  ".trim()  ==> "emptySpace"
		 */
		method trim() native
		
		method <(aString) native
		method <=(aString) {
			return self < aString || (self.equals(aString))
		}
		method >(aString) native
		method >=(aString) {
			return self > aString || (self.equals(aString))
		}
		
		/**
		 * Returns true if and only if this string contains the specified sequence of char values.
		 * It is a case sensitive test.
		 *
		 * Examples:
		 * 		"unusual".contains("usual")  ==> returns true
		 * 		"become".contains("CO")      ==> returns false
		 */
		method contains(other) {
			return self.indexOf(other) > 0
		}
		
		/** Returns true if this string has no characters */
		method isEmpty() {
			return self.size() == 0
		}

		/** 
		 * Compares this String to another String, ignoring case considerations.
		 *
		 * Example:
		 *		"WoRD".equalsIgnoreCase("Word")  ==> returns true
		 */
		method equalsIgnoreCase(aString) {
			return self.toUpperCase() == aString.toUpperCase()
		}
		
		/**
		 * Returns a substring of this string beginning from an inclusive index. 
		 *
		 * Examples:
		 * 		"substitute".substring(6)  ==> returns "tute", because second "t" is in position 6
		 * 		"effect".substring(0)      ==> returns "effect", has no effect at all
		 */
		method substring(length) native
		
		/**
		 * Returns a substring of this string beginning from an inclusive index up to another inclusive index
		 *
		 * Examples:
		 * 		"walking".substring(2, 4)   ==> returns "lk"
		 * 		"walking".substring(3, 5)   ==> returns "ki"
		 *		"walking".substring(0, 5)	==> returns "walki"
		 *		"walking".substring(0, 45)	==> throws an out of range exception (TODO: is it good?) 
		 */
		method substring(startIndex, length) native
		
		/**
		 * Splits this string around matches of the given string.
		 * Returns a list of strings.
		 *
		 * Example:
		 * 		"this,could,be,a,list".split(",")   ==> returns ["this", "could", "be", "a", "list"]
		 */
		method split(expression) {
			const result = []
			var me = self.toString() + expression
			var first = 0
			(0..me.size() - 1).forEach { i =>
				if (me.charAt(i) == expression) {
					result.add(me.substring(first, i))
					first = i + 1
				}
			}
			return result
		}

		/** 
		 * Returns a string resulting from replacing all occurrences of expression in this string with replacement
		 *
		 * Example:
		 *		 "stupid is what stupid does".replace("stupid", "genius") ==> returns "genius is what genius does"
		 */
		method replace(expression, replacement) native
		
		/** This object (which is already a string!) is itself returned */
		method toString() native
		
		/** @private */
		method toSmartString(alreadyShown) native
		
		/** Compares this string to the specified object. The result is true if and only if the
		 * argument is not null and is a String object that represents the same sequence of characters as this object.
		 */
		method ==(other) native
		
		/** A synonym for length */
		method size() = self.length()
	}
	
	/**
	 * Represents a Boolean value (true or false)
	 *
	 * @author jfernandes
	 * @noinstantiate
	 */
	class Boolean {
	
		/** Returns the result of applying the logical AND operator to the specified boolean operands self and other */
		method and(other) native
		/** A synonym for and operation */
		method &&(other) native
		
		/** Returns the result of applying the logical OR operator to the specified boolean operands self and other */
		method or(other) native
		/** A synonym for or operation */
		method ||(other) native
		
		/** Returns a String object representing this Boolean's value. */
		method toString() native
		
		/** @private */
		method toSmartString(alreadyShown) native
		
		/** Compares this string to the specified object. The result is true if and only if the
		 * argument is not null and represents same value (true or false)
		 */
		method ==(other) native
		
		/** NOT logical operation */
		method negate() native
	}
	
	/**
	 * Represents a finite arithmetic progression of integer numbers with optional step
	 * If start = 1, end = 8, Range will represent [1, 2, 3, 4, 5, 6, 7, 8]
	 * If start = 1, end = 8, step = 3, Range will represent [1, 4, 7]
	 *
	 * @author jfernandes
	 * @since 1.3
	 */
	class Range {
		const start
		const end
		var step
		
		constructor(_start, _end) {
			self.validate(_start)
			self.validate(_end)
			start = _start 
			end = _end
			if (_start > _end) { 
				step = -1 
			} else {
				step = 1
			}  
		}
		
		method step(_step) { step = _step }

		/** @private */		
		method validate(_limit) native
		
		/** 
		 * Iterates over a Range from start to end, based on step
		 */
		method forEach(closure) native
		
		/**
		 * Returns a new collection that contains the result of transforming each of self collection's elements
		 * using a given closure.
		 * The condition is a closure argument that takes an integer and returns an object.
		 * @returns another list
		 * Example:
		 *      (1..10).map({ n => n * 2}) ==> returns [2, 4, 6, 8, 10, 12, 14, 16, 18, 20] 
		 */
		method map(closure) {
			const l = []
			self.forEach{e=> l.add(closure.apply(e)) }
			return l
		}
		
		/** @private */
		method asList() {
			return self.map({ elem => return elem })
		}
		
		/** Returns true if this range contains no elements */
		method isEmpty() = self.size() == 0

		/** @see List#fold(seed, foldClosure) */
		method fold(seed, foldClosure) { return self.asList().fold(seed, foldClosure) }
		
		/** Returns the number of elements */
		method size() { return end - start + 1 }
		
		/** @see List#any(closure) */
		method any(closure) { return self.asList().any(closure) }
		
		/** @see List#all(closure) */
		method all(closure) { return self.asList().all(closure) }
		
		/** @see List#filter(closure) */
		method filter(closure) { return self.asList().filter(closure) }
		
		/** @see List#min() */
		method min() { return self.asList().min() }
		
		/** @see List#max() */
		method max() { return self.asList().max() }
		
		/**
		 * Returns a random integer contained in the range
		 */		
		method anyOne() native
		
		/** Tests whether a number e is contained in the range */
		method contains(e) { return self.asList().contains(e) }
		
		/** @see List#sum() */
		method sum() { return self.asList().sum() }
		
		/**
		 * Sums all elements that match the boolean closure 
		 *
		 * Example:
		 * 		(1..9).sum({ i => if (i.even()) i else 0 }) ==> returns 20
		 */
		method sum(closure) { return self.asList().sum(closure) }
		
		/**
		 * Counts how many elements match the boolean closure
		 *
		 * Example:
		 * 		(1..9).count({ i => i.even() }) ==> returns 4 (2, 4, 6 and 8 are even)
		 */
		method count(closure) { return self.asList().count(closure) }
		
		/** @see List#find(closure) */
		method find(closure) { return self.asList().find(closure) }
		
		/** @see List#findOrElse(predicate, continuation)	 */
		method findOrElse(closure, continuation) { return self.asList().findOrElse(closure, continuation) }
		
		/** @see List#findOrDefault(predicate, value) */
		method findOrDefault(predicate, value) { return self.asList().findOrDefault(predicate, value) }
		
		/** @see List#sortBy */
		method sortedBy(closure) { return self.asList().sortedBy(closure) }
		
		/** @private */
		override method internalToSmartString(alreadyShown) = start.toString() + ".." + end.toString()
	}
	
	/**
	 * 
	 * Represents an executable piece of code. You can create a closure, assign it to a reference,
	 * evaluate it many times, send it as parameter to another object, and many useful things.
	 *
	 * @author jfernandes
	 * @since 1.3
	 * @noInstantiate
	 */
	class Closure {
	
		/** Evaluates a closure passing its parameters
		 *
		 * Example: 
		 * 		{ number => number + 1 }.apply(8) ==> returns 9 // 1 parameter
		 *		{ "screw" + "driver" }.apply() ==> returns "screwdriver" // no parameter 
		 */
		method apply(parameters...) native
		
		/** String representation of a closure object */
		method toString() native
	}
	
	/**
	 *
	 * Represents a Date (without time). A Date is immutable, once created you can not change it.
	 *
	 * @since 1.4.5
	 */	
	class Date {

		constructor()
		constructor(_day, _month, _year) { self.initialize(_day, _month, _year) }
		
		/** Two dates are equals if they represent the same date */
		method equals(_aDate) native
		
		/** Returns a copy of this Date with the specified number of days added. */
		method plusDays(_days) native
		
		/** Returns a copy of this Date with the specified number of months added. */
		method plusMonths(_months) native
		
		/** Returns a copy of this Date with the specified number of years added. */
		method plusYears(_years) native
		
		/** Checks if the year is a leap year, like 2000, 2004, 2008, 2012, 2016... */
		method isLeapYear() native
		
		/** @private */
		method initialize(_day, _month, _year) native
		
		/** Returns the day number of the Date */
		method day() native
		
		/** Returns the day of week of the Date, where
		 * 0 = SUNDAY
		 * 1 = MONDAY
		 * 2 = TUESDAY
		 * 3 = WEDNESDAY ...
		 */
		method dayOfWeek() native
		
		/** Returns the month number of the Date */
		method month() native
		
		/** Returns the year number of the Date */
		method year() native
		
		/** 
		 * Returns the difference in days between two dates.
		 * 
		 * Examples:
		 * 		new Date().plusDays(4) - new Date() ==> returns 4
		 *		new Date() - new Date().plusDays(2) ==> returns 2 (is it good? should we return -2 instead?)
		 */
		method -(_aDate) native
		
		/** 
		 * Returns a copy of this date with the specified number of days subtracted.
		 * For example, 2009-01-01 minus one day would result in 2008-12-31.
		 * This instance is immutable and unaffected by this method call.  
		 */
		method minusDays(_days) native
		
		/** 
		 * Returns a copy of this date with the specified number of months subtracted.
		 */
		method minusMonths(_months) native
		
		/** Returns a copy of this date with the specified number of years subtracted. */
		method minusYears(_years) native
		
		method <(_aDate) native
		method >(_aDate) native
		method <=(_aDate) { 
			return (self < _aDate) || (self.equals(_aDate))
		}
		method >=(_aDate) { 
			return (self > _aDate) || (self.equals(_aDate)) 
		}
		
		/** Returns true if self between two dates (both inclusive comparison) */
		method between(_startDate, _endDate) { 
			return (self >= _startDate) && (self <= _endDate) 
		}

	}
	
}
 
package lib {

	/** 
	 * Console is a global wollok object that implements a character-based console device
	 * called "standard input/output" stream 
	 */
	object console {
	
		/** Prints a String with end-of-line character */
		method println(obj) native
		
		/** Reads a line from input stream */
		method readLine() native
		
		/** Reads an int character from input stream */
		method readInt() native
	}
	
	/**
	 * Assert object simplifies testing conditions
	 */
	object assert {
	
		/** 
		 * Tests whether value is true. Otherwise throws an exception.
		 * Example:
		 * 		var number = 7
		 *		assert.that(number.even())   ==> throws an exception "Value was not true"
		 * 		var anotherNumber = 8
		 *		assert.that(anotherNumber.even())   ==> no effect, ok		
		 */
		method that(value) native
		
		/** Tests whether value is false. Otherwise throws an exception. 
		 * @see assert#that(value) 
		 */
		method notThat(value) native
		
		/** 
		 * Tests whether two values are equal, based on wollok == method
		 * 
		 * Example:
		 *		 assert.equals(10, 100.div(10)) ==> no effect, ok
		 *		 assert.equals(10.0, 100.div(10)) ==> no effect, ok
		 *		 assert.equals(10.01, 100.div(10)) ==> throws an exception 
		 */
		method equals(expected, actual) native
		
		/** Tests whether two values are equal, based on wollok != method */
		method notEquals(expected, actual) native
		
		/** 
		 * Tests whether a block throws an exception. Otherwise an exception is thrown.
		 *
		 * Example:
		 * 		assert.throwsException({ 7 / 0 })  ==> Division by zero error, it is expected, ok
		 *		assert.throwsException("hola".length() ) ==> throws an exception "Block should have failed"
		 */
		method throwsException(block) native
		
		/**
		 * Throws an exception with a custom message. Useful when you reach an unwanted code in a test.
		 */
		method fail(message) native
		
	}
	
	class StringPrinter {
		var buffer = ""
		method println(obj) {
			buffer += obj.toString() + "\n"
		}
		method getBuffer() = buffer
	}	
	
	object wgame {
		method addVisual(element) native
		method addVisualIn(element, position) native
		method addVisualCharacter(element) native
		method addVisualCharacterIn(element, position) native
		method removeVisual(element) native
		method whenKeyPressedDo(key, action) native
		method whenKeyPressedSay(key, function) native
		method whenCollideDo(element, action) native
		method getObjectsIn(position) native
		method say(element, message) native
		method clear() native
		method start() native
		method stop() native
		
		method setTitle(title) native
		method getTitle() native
		method setWidth(width) native
		method getWidth() native
		method setHeight(height) native
		method getHeight() native
		method setGround(image) native
	}
	
	class Position {
		var x = 0
		var y = 0
		
		constructor() { }		
				
		constructor(_x, _y) {
			x = _x
			y = _y
		}
		
		method moveRight(num) { x += num }
		method moveLeft(num) { x -= num }
		method moveUp(num) { y += num }
		method moveDown(num) { y -= num }
	
		method drawElement(element) { wgame.addVisualIn(element, self) }
		method drawCharacter(element) { wgame.addVisualCharacterIn(element, self) }		
		method deleteElement(element) { wgame.removeVisual(element) }
		method say(element, message) { wgame.say(element, message) }
		method allElements() = wgame.getObjectsIn(self)
		
		method clone() = new Position(x, y)

		method clear() {
			self.allElements().forEach{it => wgame.removeVisual(it)}
		}
		
		method getX() = x
		method setX(_x) { x = _x }
		method getY() = y
		method setY(_y) { y = _y }
	}
}

package game {
		
	class Key {	
		var keyCodes
		
		constructor(_keyCodes) {
			keyCodes = _keyCodes
		}
	
		method onPressDo(action) {
			keyCodes.forEach{ key => wgame.whenKeyPressedDo(key, action) }
		}
		
		method onPressCharacterSay(function) {
			keyCodes.forEach{ key => wgame.whenKeyPressedSay(key, function) }
		}
	}

	object ANY_KEY inherits Key([-1]) { }
  
	object NUM_0 inherits Key([7, 144]) { }
	
	object NUM_1 inherits Key([8, 145]) { }
	
	object NUM_2 inherits Key([9, 146]) { }
	
	object NUM_3 inherits Key([10, 147]) { }
	
	object NUM_4 inherits Key([11, 148]) { }
	
	object NUM_5 inherits Key([12, 149]) { }
	
	object NUM_6 inherits Key([13, 150]) { }
	
	object NUM_7 inherits Key([14, 151]) { }
	
	object NUM_8 inherits Key([15, 152]) { }
	
	object NUM_9 inherits Key([16, 153]) { }
	
	object A inherits Key([29]) { }
	
	object ALT inherits Key([57, 58]) { }
	
	object B inherits Key([30]) { }
  
	object BACKSPACE inherits Key([67]) { }
	
	object C inherits Key([31]) { }
  
	object CONTROL inherits Key([129, 130]) { }
  
	object D inherits Key([32]) { }
	
	object DEL inherits Key([67]) { }
  
	object CENTER inherits Key([23]) { }
	
	object DOWN inherits Key([20]) { }
	
	object LEFT inherits Key([21]) { }
	
	object RIGHT inherits Key([22]) { }
	
	object UP inherits Key([19]) { }
	
	object E inherits Key([33]) { }
	
	object ENTER inherits Key([66]) { }
	
	object F inherits Key([34]) { }
	
	object G inherits Key([35]) { }
	
	object H inherits Key([36]) { }
	
	object I inherits Key([37]) { }
	
	object J inherits Key([38]) { }
	
	object K inherits Key([39]) { }
	
	object L inherits Key([40]) { }
	
	object M inherits Key([41]) { }
	
	object MINUS inherits Key([69]) { }
	
	object N inherits Key([42]) { }
	
	object O inherits Key([43]) { }
	
	object P inherits Key([44]) { }
	
	object PLUS inherits Key([81]) { }
	
	object Q inherits Key([45]) { }
	
	object R inherits Key([46]) { }
	
	object S inherits Key([47]) { }
	
	object SHIFT inherits Key([59, 60]) { }
	
	object SLASH inherits Key([76]) { }
	
	object SPACE inherits Key([62]) { }
	
	object T inherits Key([48]) { }
	
	object U inherits Key([49]) { }
	
	object V inherits Key([50]) { }
	
	object W inherits Key([51]) { }
	
	object X inherits Key([52]) { }
	
	object Y inherits Key([53]) { }
	
	object Z inherits Key([54]) { }
}

package mirror {

	class InstanceVariableMirror {
		const target
		const name
		constructor(_target, _name) { target = _target ; name = _name }
		method name() = name
		method value() = target.resolve(name)
		
		method valueToSmartString(alreadyShown) {
			const v = self.value()
			return if (v == null) "null" else v.toSmartString(alreadyShown)
		}

		method toString() = name + "=" + self.value()
	}
}
