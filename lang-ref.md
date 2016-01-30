---
layout: hyde
---

# Wollok - Language Reference #

This is the Wollok programming language reference guide.

# Wollok Files #

Wollok has currently three kinds of files which represents different concepts:

* a **Wollok Program** (.wpgm)
* a **Wollok Library / Module** (.wlk)
* a **Wollok Test** (.wtest)

We will discuss each of them in the following sections

# Wollok Programs #

A program is an executable piece of code that consists of a set of statements (actually expressions) that will be executed one after the other. It can be thought as the "main" entry point to a program in other languages.
Example:

```scala
program helloWorld {
   console.println("Hello World!")
}
```

This program just prints "Hello World!" to the console.
Further sections will explain all parts of the "console.println(...)" expression. For now, you can think of it as if it was an out-of-the-box function available to programs. Or as another instruction.

# References: Variables and Values #

In Wollok (as in many other languages) there are two types of references: variables and values.

A **Variable** is a reference whose value can be changed at any time in the code. That's why it's called "variable" :)
Note that here we use the term "change" but applied to the "reference" and not to the pointed object.
What actually changes is the pointer, meaning that now the reference points to another object.

```scala
var age = 10
age = 11
age = age + 1
```

A **Value** is a reference which is initialized to point to an object, and which cannot be redirected (changed) to point to another object. It's kind of a "constant reference", always pointing to the same object, but it's not a "constant" as meant in some other languages due to the fact that the referenced object might change its own state.

```scala
val adultAge = 21

adultAge = 18  // THIS WON'T COMPILE !
```

# Comments #

There are three kinds of comments: 
* single line comments using a double slash symbol (//)
* multi-line comments starting with /* and ending with */
* wollok-docs comments starting with /** and ending with */. We will see them in a further section

Samples:

```scala
val adultAge = 21   // a single line comment

/*
 multiple lines
 comments
 */
adultAge = 18
```

# Basic objects #

Here we will introduce the basic objects that come out-of-the-box with Wollok.

## Numbers ##

Numbers are immutable objects, but they understand several messages that can return new numbers, like mathematical operations to add, subtract, etc.


```scala
val a = 1
var b = a + 10  // add
b = b - 1       // substract
b = b * 2       // multiply
b = b / 2       // divide
b = b % 2       // module
b = b ** 3      // raised to (3 in this case)
```

In addition, Wollok also supports **postfix operators** as well as the **plus equals** operation (among other variants).
These are all just shortcuts for other expressions (shown here as comments to the right of their respective equivalents).

```scala
b++             // b = b + 1
b--             // b = b - 1

b += 2          // b = b + 2
b -= 1          // b = b - 1
b *= 3          // b = b * 3
b %= 2          // b = b % 2
b /= 2          // b = b / 2
```

## Booleans ##

There are two boolean objects which are available as literals: "true", and "false".
Again these are immutable objects, but they understand some operations that are evaluated to new boolean values, for example the "and" and "or" operations:


```scala
val fact = true and true
val isTrue = true
val isFalse = false

val willBeFalse = isTrue and isFalse

val willBeTrue = isTrue or isFalse

val willBeTrue = not false
```

There are also special symbols for the three operations which can be used instead, if you find yourself more comfortable with them (coming from languages like C, or java):

* **and**: a && b
* **or**: a || b
* **not**: !a

Furthermore, all equality and comparative operations are evaluated to boolean objects (see further sections).


## Strings ##

Strings can be delimited either with single or double quotes.


```scala
val aString = "hello"
val another = 'world'
```

They are also immutable objects, but support operations which returns new strings, like concatenating them.


```scala
val helloWorld = aString + another + " !"
```

## Equality Expressions ##

The following expressions are meant to compare objects and are evaluated to boolean values:

```scala
val one = 1
val two = 2

val willBeFalse = (1 == 2)

val willBeTrue = one == 1

val willBeTrue = (1 != 2)
```

* == tells us whether the two objects **are equal**
* != tells us whether the two objects **are NOT equal**

After introducing objects and classes we will revisit the equality concept in further sections.

## Comparing Expressions ##

There are also expressions to compare objects (commonly numbers)


```scala
val willBeTrue = 23 < 24      // lesser than
val willBeTrue = 23 <= 24     // lesser or equals than
val willBeTrue = 24 > 10      // greater than
val willBeTrue = 24 >= 10     // greater or equals than
```
They don't need further explanation.


# User Objects #

Besides the predefined objects that we have seen, being an OOP language means that the programmer should be able to create their own objects.

This can be done in two slightly different ways:
* Object Literals
* Named objects

## Named Objects (a.k.a. "Well-Known Objects" or just "WKOs") ##

There's a special language construction to define an object and assign a global name to it.

```scala
object myObject {
    // code here
}
console.println(myObject)
```

This object will be available from any part of the program with the reference "myObject".

## Object Literals ##
Another option is to use object literals which allow you to create a new object without any global reference to it.
Instead you can assign the resulting object to a new variable (or an existing one).
Therefore having more control on the object's scope.

```scala
val myObject = object {
    // code here
}
console.println(myObject)
```

Of course this is a very silly example, since this object won't understand any message. It's an "empty object".
You will see this in the console

```
anObject{}
```

## Methods ##

Within the object's braces we can define methods. For example we will represent a Bird


```scala
val aBird = object {
    method fly(meters) {
        return 'flyed ' + meters +  ' meters'
    }
}

val result = aBird.fly(23)
console.println(result)
```

As you can see here methods are defined with the **method** keyword. They can receive parameters, and return a value.
Parameters type are not explicit. In this case, "meters" is the name of the parameter.

Also in case the method returns a value you MUST explicitly write a **return** statement. The only possible exception is the "simple return method" explained in the next section.

### Simple Return Methods ###

There's a shortcut for simple methods which return values.

```scala
val aBird = object {
    method fly(meters) = 'flyed ' + meters +  ' meters'
}
```

Notice that the return keyword is not necessary here. And also there are no curly braces for the method body.
Instead there's a = symbol, which means that the return value will be the evaluation of the right part of the method.

One will probably use this syntax for short methods which computes simple values


## Instance Variables ##

Our bird doesn't do much so far. We will add "state" to it, in the form of instance variables. And some methods that will mutate that state.

```scala
val aBird = object {
    var energy = 0
    method fly(meters) {
        energy -= 2 + meters
    }
    method eat(grams) {
        energy += grams
    }
}

aBird.fly(23)
aBird.eat(10)
```

Instance references are declared in an object, right before the first method.
As any other references we already saw, it can be either a **var** or a **val** (variable or constant).

**All instance references are only visible to code that's inside this object**. That means its methods.

This is not valid


```scala
aBird.energy
```

Instead, if you want to access the bird's energy, the object must publish that information via a new method.

```scala
val aBird = object {
    var energy = 0
    method fly(meters) {
        energy -= 2 + meters
    }
    method eat(grams) {
        energy += grams
    }
    method getEnergy() {
        return energy
    }
}

aBird.fly(23)
aBird.eat(10)

val e = aBird.getEnergy()
```

# Messages #

OOP means objects, but most important, it means **messages**!
So, in Wollok (almost) everything you do is sending messages to objects.

We saw that those object could have methods within them that will get executed if someone sends a message to it.

The syntax to send messages is always:


```scala
object.messageName(param1, param2, ...)
```

ALWAYS!

You **CANNOT** write any of these variants:

```scala
messageName(param1, param2)        // missing the object (receiver of the message)
object.messageName                 // missing parenthesis
```

## This ##

So, what if I'm in an object and I want to send a message to myself to reuse an already existent method ?

Then there's a special keyword to refer to yourself (object) called **this**

```scala
val aBird = object {
    var energy = 0
    method fly(meters) {
        energy -= 2 + meters
    }
    method eat(grams) {
        energy += grams
    }
    method getEnergy() {
        return energy
    }
    // NEW ONE 
    method flyAndThenEat(metersToFly, gramsToEat) {
        this.fly(metersToFly)
        this.eat(gramsToEat)
    }
}

aBird.flyAndThenEat(23, 10)
```

# Polymorphism - Part I (just objects) #

Polymorphism, the most important concept in OOP, is the ability that allows an object to be interchangeable with another, without affecting a third that uses them.

Wollok shares some characteristics with dynamically typed languages (since it has a [Pluggable Type System](http://bracha.org/pluggableTypesPosition.pdf)).
This means that if two objects understand the same messages, then nothing else is needed, they can be used polymorphically by a third that sends those messages.

For example, we'll change our Bird in order to add the concept of Food, instead of just eating some grams (number).

```scala
val aBird = object {
    var energy = 0
    method fly(meters) {
        energy -= 2 + meters
    }
    method eat(food) {
        energy += food.energy() // a "food" is something that provides "energy"
    }
    method getEnergy() {
        return energy
    }
}
```
Here a "food" then is any object that understands the "energy" message, and returns a number (the amount of energy it provides)

Then we can have two other objects representing specific food:

```scala
val birdseed = object {
    method energy() { return 5 } 
}

val rice = object {
    method energy() { return 2 }
}

aBird.eat(birdseed)
aBird.eat(rice)
```

Here both "birdseed" and "rice" are polymorphic in respect to "aBird"

# If Expression

The **if** expression allows you evaluate a boolean condition and then perform different actions for positive and negative cases.

For example:

```scala
if (this.isRaining()) {
    this.goHome(this.getCar())
}
else 
    this.goHome(this.getByke())
```

This is what we call using the "if" as a control flow.

Besides this usage, in Wollok the "if" is not actually a statement (controlling the flow), but an expression. That means that it "returns" a value (it is evaluated to a value).

So you can also use it in this other form:

```scala
val transport = if (this.isRaining()) this.getCar() else this.getByke()
this.goHome(transport)
```

# Collections #

Wollok provides literals for **List objects**.
The syntax is:

```scala
[ element1, element2, ..., elementN ]
```

For example

```scala
val numbers = [2, 23, 25]

numbers.size() == 3   // true !
numbers.contains(23)  // true !

numbers.remove(23)
numbers.size() == 2   // true

numbers.clear()
numbers.size() == 0   // true
numbers.isEmpty()     // true
```

Lists are just objects again, and therefore you interact with them through messages.
Here we have seen just simple ones.

Then most powerful messages require special objects as parameters: Closures !

## Sets

There's also a literal for **Set** objects. Which is an Collection without duplicates.
The syntax is

```scala
val numbers = #{2, 23, 25}
```

Notice that it uses _curly braces_

## Closures ##

For a detailed explanation see [wikipedia](http://en.wikipedia.org/wiki/Closure_(computer_programming))
Here we'll just say that a closure is an object that represents a "piece of code" that can be manipulated. Specifically it can be executed at any time. As many times as you want.
But they can also be assigned to references, be passed as parameters, as well as be returned.

Wollok support closures through literals.

Here is an example:


```scala
val helloWorld = { "helloWorld" }
val response = helloWorld.apply()		

response == "helloWorld"      // true
```

The first line defines a closure that doesn't take any parameter. The second one executes the closure sending the message **apply()** to it.

Here is one that receives a parameter:

```scala
val helloWorld = { to => "hello " + to }
val response = helloWorld.apply("world")

response == "hello world"      // true
```
So, the syntax for closures is:

```groovy
{param1, param2, ..., paramN => /* code */ }

```

There's a special fact about closures: they have access to their own parameters, but also to any other reference that was available at the place where it was defined.
This makes them really powerful.
Here is a silly example:

```scala
var to = "world"
val helloWorld = { "hello " + to }
			
helloWorld.apply() == "hello world"      // true
		
to = "someone else"
helloWorld.apply() == "hello someone else"      // true
```

Check that the code within the closure access the "to" variable that is defined outside of it, in the program.

If we change this reference, then executing the closure will have another effect (as shown in the second call)


## Closures and Collections ##

As many other languages, Wollok provides rich collection messages to operate with them. Instead of writing code that indexes or iterates elements every time, a series of methods that perform common tasks is delivered out-of-the-box. Many of those predefined messages receive closures as parameters.

For example, in order to perform a given logic on each element, the **forEach** method is available:

```scala
val numbers = [23, 2, 1]

var sum = 0
numbers.forEach({ n => sum += n })
			
sum == 26      // true
```

There's also a short way to write it in case you are sending a message with a single parameter being a closure, you can avoid the parenthesis.
So the previous example would be:

```scala
numbers.forEach { n => sum += n }
```

To evaluate if all elements comply a given condition, there's a "forAll"


```scala
val numbers = [23, 2, 1]
			
var allPositives = numbers.forAll { n => n > 0 }

allPositives == true      // true
```

**filter** returns a new collection which only has the elements that are evaluated to true.

```scala
val numbers = [23, 2, 1]
			
var greaterThanOneElements = numbers.filter { n | n > 1 }
	
greaterThanOneElements.size() == 2      // TRUE

```

**map** returns a new collection whose elements are the result of performing a trasnformation on each element of the original collection through the given closure.

```scala
val numbers = [10, 20, 30]
			
var halfs = numbers.map { n => n / 2 }
	
halfs.contains(5)       // TRUE
halfs.contains(10)      // TRUE
halfs.contains(15)      // TRUE
```

# Classes #

Classes share some characteristics with object literals: they define instance variables, as well as methods.
But they are not expressions (cannot be assigned to variables).
Instead they are just like **definitions**.

Here's a sample:


```scala
class Bird {
    var energy = 0

    method fly(meters) {
        energy -= 2 + meters
    }
    method eat(food) {
        energy += food.energy
    }
    method getEnergy() {
        return energy
    }
}
```
Then you create new objects by instantiating the class


```scala
val aBird = new Bird()
aBird.fly(23)
```

## Inheritance ##

Classes might subclass from another class. That will inherit instance variables as well as methods.

Instance variables are visible from the subclass. Think of it like if they were "protected" in java.

Methods in Wollok are always "public".

Example:

```scala
class SwimmingBird inherits Bird {

   method swim(meters) {
       energy -= meters * 1.2
   }
}

val aBird = new SwimmingBird()
aBird.swim(10)
aBird.fly(50)
```

Subclasses can add new methods and instance variables, and override existing methods (check on section "Overriding and super").

## Abstract methods and classes ##

An **abstract method** is one that declares its name and parameters, but that it won't provide any implementation.
It will be up to the subclasses of this class to implement this method by **overridding** (see next section).

In Wollok there's no **abstract** keyword, just a method without a body.


```scala
class MyClass {

   method anAbstractMethod(param)

}
```

A class with at least one abstract method is considered to be an **abstract class**.
Again, there's no **abstract** keyword to mark the class as being abstract.
It's all inferred.

## Overriding and super ##

Subclasses might override already defined methods in any superclass. For this you will need to explicitly use the "override" keyword before the method definition.

```scala
class EfficientBird inherits Bird {

    override method fly(meters) {
        energy -= meters / 2
    }
}
```

If while overriding you also need to invoke the original method, then you can use the **super** keyword:

```scala
class Bird {
    var energy = 0

    method fly(meters) {
        energy -= 2 + meters
    }
    method eat(food) {
        energy += this.energyGain(food)
    }

    method energyGain(food) {
        return food.getEnergy()
    }

}

class EfficientBird inherits Bird {

    override method energyGain(food) {
        super(food) / 2
    }
}
```

Notice that you don't need to specify the method name. In Wollok you can only invoke the overridden method using **super**.

You cannot use super to call any other method in the superclass.

This keeps the language and programs easier.

Also notice that super can only be used within an overriding method.

## Constructors ##

A constructor is kind of a special method that is called in order to create and initialise a new instance of a class.
Wollok allows:

* **Multiple constructors:** meaning that you can provide more than one constructor with different numbers of arguments.
* **Constructors delegation**: meaning that one constructor may invoke another one to reuse code.
* **Implicit constructors and delegation**: for non-arguments constructors.

We will see this in details in following sections

### Simple Constructor ###

Here's a sample Point class with a constructor

```scala
class Point {
    var x
    var y

    new(_x, _y) {
        x = _x
        y = _y
    }
}
```

Now you can do this:

```scala
   val p = new Point(2, 1)
```

### Default Constructor

As you might already notice a class that doesn't define any constructor gets a no-arguments constructor for free

This

```scala
class Point {
}
```

Is the same as

```scala
class Point {
    new() {}
}
```

That's why in both cases this works fine

```scala
   val p = new Point()
```

Once you specify one constructor then you are on your own, and there are no implicit constructors anymore.

### Multiple Constructor ###

Now you can have as many constructors as you want. Just that you won't be able to define two constructors with the same number of arguments !

Let's add a new constructor to our point

```scala
class Point {
    var x
    var y

    new(_x, _y) {
        x = _x
        y = _y
    }
    new(p) {
        x = p.getX()
        y = p.getY()
    }
    method getX() { return x }
    method getY() { return y }
}
```

Now we can do:

```scala
   var p1 = new Point(1,2)
   var p2 = new Point(p1)
```

### Constructor Delegation ###

Now as you might have noticed the previous example with two constructor has a small amount of repeated code. In both constructors we are changing references of our instance variables.
It's always a good practice to avoid repeated code, because it means we abstract away a piece of functionality that we will reuse following the D.R.Y. principle.

So for that, Wollok provides a mechanism to reuse this code because a given constructor might "call" or delegate **first** to another constructor.

There are two types of constructor delegation or situations:
* **Delegating to another constructor in the same class**
* **Delegating to constructor in the superclass**

For our Point class we will see the first one:

```scala
class Point {
    var x
    var y

    new(_x, _y) {
        x = _x
        y = _y
    }
    new(p) = this(p.getX(), p.getY()) {
       // some behaviour here
    }
    method getX() { return x }
    method getY() { return y }
}
```

Notice the syntax here:

```scala
   new(...params...) =  this(...paramsToOther...) {
      body
   }
```

This means that the body of your constructor will be executed AFTER the execution of the delegated constructor.
So delegation is the first thing that takes place.


The second case is delegating to a superclass constructor.

```scala
class Point {
    var x
    var y

    new(_x, _y) {
        x = _x
        y = _y
    }
}

class Circle inherits Point {
    var r
    new(_x, _y_, _r) = super(_x, _y) {
        r = _r
    }
}
```

Notice that the delegation is defined through the usage of the **super** keyword.
This is not exactly the same as a super method invocation, but similar.

Sometimes you are forced to explicitly declare a superclass constructor delegation if the superclass doesn't have a no-arguments constructor.

### No Constructor Inheritance ###

Although we have said that constructors are kind of special methods, they don't share all the characteristics of methods.
For example constructors cannot be inherited. Each class defines its own constructors, which in turn can delegate to a superclass constructor (as we have seen before). But they are not automatically inherited.

### Values initialisation in Constructors ###

We have already seen that there is a special type of reference which is immutable: the **values**.
There's a special case with classes where you might declare a value reference that won't be assigned in that same line, but after that.
But that doesn't mean anywhere.
These are "instances values".
This values are **assigned at construction time and cannot be modified after that**.
Here is an example:

```scala
class ImmutablePoint {
    val x
    val y
    
    new(_x, _y) {
        x = _x
        y = _y
    }
}
```

It could sound weird because we are assigning a value, this is completely valid.
Once assigned the reference cannot change anymore. This gives flexibility avoiding boilerplate code (and state)

### Objects Inheritance ###

Well-known named objects can be defined based on an already defined class.

```scala
object lassie inherits Dog {
   // ...
}
```

This could be a natural place for migrating a program which initially started as objects and then part of the behaviour was moved to classes in order to reuse code. Sometimes you want to keep using WKO's while combining them with classes.

Then there is a special case when the class you want to inherit from defines constructors. The object must call a superclass constructor explicitly. And here is the syntax for that:

```scala
object lassie inherits Dog("Lassie", 3) {
   // ...
}

class Dog {
   new(name, age) {
      // ...
   }
}
```

# Polymorphism - Part II #

Wollok combines objects and classes in a single language, and therefore in programs.
Polymorphism with classes work in the same way as with objects. It doesn't matter if the object is an instance of a class or a WKO or an anonymous one, they can potentially be used polymorphically.

**Two objects can be used polymorphically if they understand a common set of messages.**

```scala
package birds {

   class Bird {
        method fly(to) {
             // ...
        }
   }

   class Plane {
        method fly(to) {
            // ...
        }
   }

}
```
Then:

```scala
    val plane = new Plane()
    val bird = new Bird()

    val flyingObjects = [ plane, bird ]

    flyingObjects.forEach { o => o.fly() }
```
There's no need to have a common base class for objects to be treated polymorphically. As previously stated, the only important thing is the set of messages the object understands. *Forget about the class, it might not even have one!*
Both classes Plane and Bird could be part of different hierarchies, but their instances would still be polymorphic for some other object that wants to make them fly.

Some languages like Java force you to define a type, an interface, for make them polymorphic. We don't.
Still our compiler is able to check whether the message sending is valid.

Now, besides classes, there could be polymorphism between classes and objects.
Examples

```scala
    val boomerang = object {
          method fly(to) {
               // ... goes, and then goes back here
          }
    }

    val flyingObjects = [ plane, bird, boomerang ]

    flyingObjects.forEach { o |  o.fly() }

```

# Modularization

Wollok provides a set of rules and language constructions in order to promote modularization. That is, separating classes and programs in order to be reused in different other programs / libraries.

## Packages

A package is logical unit that groups together several classes and/or WKOs.

```scala
package birds {

   class Bird {
        // ...
   }

   class SwimmingBird inherits Bird {
        // ...
   }

   // ...

}
```

A single Wollok file can actually define more than one package


```scala
package birds {
    // ...
}

package trainers {
    // ...
}

package environment {
    // ...
}
```

The package has a name (here "birds", "trainers", etc). Every class defined within it will inherit the package name as a prefix.

That introduces what is called a class **fully qualified name** (or FQN).
Example:

```scala
package birds {

   class SwimmingBird {
       // ...
   }

}
```

This class FQN is: **birds.SwimmingBird**

While coding within this package, you can refer classes with their **shortname** (here SwimmingBird). This is valid as long as they are also defined within the same package.

To refer to a class from outside of the package you MUST use the FQN.

To avoid writing FQN names all over the code, you can use imports as described in the next section.


## Libraries vs Programs ##

// TODO

## Imports and Namespaces ##

// TODO

# Advanced Features #

## Type System ##

Wollok Type System is an optional feature. Meaning that it can be enabled/disabled.
The other main objective of the type system is to avoid explicit type information, since for starting developers that would mean a new concept to explain/understand.
So types should be introduced gradually.
This is a big challenge.

### Type System - Part I #

// TODO: introduce type system without classes (only predefined and user objects)

### Type System - Part II #

Our type system also allows you to combine classes with objects, and still check for message sending and types compatibility in assignments.
All of this without type annotations (you don't need to specify types for parameters or variables/values).

For example (in Wollok this would be actually implemented in different files, since you cannot define classes within a program, you are forced to split them from the program. But here it allows us to see it all together)

```scala
   class Bird {
       method fly() { ... }
       method eat() { ... }
   }

   class SwimmingBird inherits Bird {
       method swimg() { ... }
   }

   val bird = new Bird()
   val duck = new SwimmingBird()

   class Superman() {
       method fly() { ... }
       method throwLaserFromEyes() { ... }
   }

  var flier = bird
  flier = new Superman()
```

This are the inferred types:

* bird : types to **Bird**
* duck : types to **SwimmingBird**
* flier : types to **{ fly() }**, meaning "any object that understands the message fly with no parameters". This is basically the common messages present both in Bird and Superman classes. The type system infers this because our reference "flier" is being assigned to "bird" and "new Superman()" in our program. Then, sending any message besides "fly()" will end up in a compilation error.

This will compile

```scala
flier.fly()
```

While this won't compile

```scala
flier.eat()
// or
flier. throwLaserFromEyes()
```

And this compiles fine:

```scala
flier = object {
    method fly() { ... }
    method anotherMethod() { ... }
}
```
Since the object complies with the structural type { fly() }

## WollokDocs ##

Wollok has a special comment syntax for attaching documentation data to different elements of the language. 

For example classes: 

```scala
/**
 * A bird knows how to fly and eat. 
 * It also has energy. 
 *
 * @author jfernandes
 */
class Bird {
   // ...
}
```

Also methods and instance references can have documentation in this form.
This allows the IDE to present more information on tooltips, and other visual parts.


## Exception Handling Mechanism ##

Woolly provides a quite standard exception mechanism similar to those in Java or Python.
An exception is an object that represents condition for which a piece of code cannot continue executing, therefore it **raises an exception (by throwing one of this objects)**.
Eventually other part of the code could be interested in handling this kind of condition in order to recover, retry, workaround it, etc.

So this are the two basic operations one can do with exceptions:

* **throw**: throws an exception object up the stack trace until someone will catch it (next)
* **catch**: gather an exception that was being thrown up the stack, so you can have code to handle it.

### Throw ###

Here's a sample code for throw statement

```scala
class MyException inherits wollok.lang.Exception {}
class A {
	method m1() { 
		throw new MyException()
	}
}
```

Here method m1() always throw a new exception instance of MyException.
Notices that you cannot throw any object. They must be instances of a **wollok.lang.Exception* subclass.


### Try-Catch ###

Here is a sample code to catch an exception:

```scala
program p {
	val a = new A()
	var counter = 0

	try {
		a.m1()
		counter = counter + 1
	}
	catch e : MyException {
		console.println("Exception raised!") // OK!
		e.printStackTrace()
	}
}
```

This program catches any MyException raised but the code inside the **try** block.
(NOTE: the code within the catch here could actually be considered a 'bad practice', depending on the context of the program. One should be very careful writing catch code that just logs the error.)

### Then Always ###

Besides the "catch" block a try could have an "always" block whose code will always be executed no matter if there was or wasn't any exception thrown.

```scala
try {
	a.m1()
}
catch e : MyException
	console.println("Exception raised!") // OK!
then always
	counter = counter + 1
}
```

### Multiple Catch's ###

A try block can have more than one catch, in case you need to handle different types of exception in different ways:

```scala
try 
	a.m1()
catch e : MySubclassException
	result = 3
catch e : MyException
	result = 2
```

## Operators Overloading ##

// TODO

## Identity vs Equality ##

// TODO

## Natives

Wollok interpreter (runtime) is implemented in Java. This means that behind stages there are java classes and objects running your program.
As all young languages it would be quiet common to find that Wollok misses some utility classes, frameworks or libraries that you could have in any other commercial languages. So in order to compensate that Wollok includes a mechanism to define Wollok classes and objects as "natives". This means that part of it will be actually implemented natively in Java code (or scala).

### Native Classes

One common case is to define a class as native. That involves a couple of parts.

The Wollok side :

**wollok.wlk**

```scala
package classes.natives {

	class MyNative {
		method aNativeMethod() native
		
		method uppercased() {
			return this.aNativeMethod().toUpperCase()
		} 
	}

}
```

Notice that there is a method without a body and that uses the **native** keyword. But it also has a regular Wollok method.
This is a native class. One that has at least one native method.
So where's that method's implementation/code ?

For that we have the **java side**

```java
package wollok.classes.natives;

public class MyNative {
	
	public String aNativeMethod() {
		return "Native hello message!";
	}

}
```

Notice that the java class resolution is based on a naming convention.
The wollok class full name is **"wollok.classes.natives.MyNative"**, therefore Wollok expects to find a java class with that exact name, somewhere in the classpath.
Every time someone instantiates the MyNative wollok class in a Wollok program, the interpreter will also instantiate one of such java classes. So you can also store state in the native object.

Here is a sample usage for this case:

```scala
import wollok.classes.natives.MyNative

program nativeSample {
	val obj = new MyNative()
	val response = obj.aNativeMethod()
	
	console.println(response)         // SHOWS: Native hello message!
	
	console.println(obj.uppercased()) // SHOWS: NATIVE HELLO MESSAGE!
}
```

### Native Objects

In the same fashion you can also define native objects

Here is the Wollok side:
**wollok.wlk**

```scala
package lib {
	object console {
		method println(obj) native
		method readLine() native
		method readInt() native
	}
}
```

And then the native part is coded in scala

**wollok/lib/ConsoleObject.scala**

```scala
package wollok.lib

//...

class ConsoleObject {
	val reader = new BufferedReader(new InputStreamReader(System.in))

	def println(Object obj) {
		WollokInterpreter.getInstance().getConsole().logMessage("" + obj);
	}

	def readLine() {
		reader.readLine
	}

	def readInt() {
		val line = reader.readLine
		Integer.parseInt(line)
	}
}
```

Notice that the convention for the name is pretty similar to the one for classes. The only difference is that the Java class simple name must comply with the convention:

```
    $objectName.firstLetterUppercase + "Object"
```

__(This console sample is actually one of the Wollok built-in objects part of the library)__

### Access to Wollok Object ###

Sometimes the native class might need access to the Wollok object instance, because there could be state or behaviour there defined in Wollok.
For that there's a convention-over-configuration based on constructors.

A native Java class might have one of the following constructors

* **new()**: empty constructor, won't give you access to the object
* **new(WollokObject)**: Wollok will pass you the Wollok object instance upon instantiation
* **new(WollokObject, WollokInterpreter)**: in case you also need the interpreter instance.

Here is a small example showing access from java to the Wollok side.

**Wollok side**

```scala
class MyNativeWithAccessToObject {
   var initialValue = 42
   method lifeMeaning() native
   method newDelta(d) native

   method initialValue() {
      return initialValue
   } 
}
```

Then **scala-side**

```scala
class MyNativeWithAccessToObject {
   val WollokObject obj
   var delta = 100
	
   new(WollokObject obj) {
      this.obj = obj
   }
	
   def lifeMeaning() {
      delta + (obj.resolve("initialValue") as WollokInteger).wrapped
   }
	
   def newDelta(int newValue) {
      delta = newValue
   }	
}
```

### Method aliases and @NativeMethod ###

We have seen that Wollok matches a given "Wollok native method" with a java method by convention using the same name.

```scala
   method lifeMeaning() native --> public [type] lifeMeaning() { ... }
```

Now there are some situations where the java-side method cannot have the same name as the Wollok side.
For example because of java reserved words, or in case you want to expose a message with a symbol like "+", etc.
For these cases there's a special annotations **@NativeMessage("...")** you can use in the java-side that tells Wollok which message is this method implementing.

Example:

```scala

method assert(other) native     -->  @NativeMessage("assert") def assertImpl(boolean b) { ... }
```


### Caveats about natives ###

There are a couple of limitations or warning when working with natives objects / classes

* Native methods cannot be overriden
// TODO:  
