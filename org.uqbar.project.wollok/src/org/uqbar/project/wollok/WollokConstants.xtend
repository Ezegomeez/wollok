package org.uqbar.project.wollok

/**
 * Contains language keywords defined in the grammar
 * but then used by the interpreter or any other processing (like quickfixes).
 * 
 * Avoids hardcoding strings all over the places.
 * So that if we decide to change the grammar syntax we can just change here.
 * 
 * There's probably a way to get this via xtext but I'm not sure how
 * 
 * @author jfernandes
 */
class WollokConstants {
	
	public static val SOURCE_FOLDER = "src"
	
	public static val NATURE_ID = "org.uqbar.project.wollok.wollokNature"
	public static val CLASS_OBJECTS_EXTENSION = "wlk"
	public static val PROGRAM_EXTENSION = "wpgm"
	public static val TEST_EXTENSION = "wtest"
	public static val STATIC_DIAGRAM_EXTENSION = "wsdi"
	public static val DIAGRAMS_FOLDER = ".diagrams"
	
	public static val REPL_FILE = "wollokREPL.wlk" 
	public static val SYNTHETIC_FILE = "__synthetic"
	
	public static val PATH_SEPARATOR = "/"
	public static val STACKELEMENT_SEPARATOR = ":"
	public static val WINDOWS_FILE_PREFIX_SIZE = 6
	public static val DEFAULT_FILE_PREFIX_SIZE = 5 
	
	// grammar elements here for being used in quickfixes, validators, and
	// any code that generates wollok code
	
	public static val OPMULTIASSIGN = #['+=', '-=', '*=', '/=', '%=', '<<=', '>>=']
	public static val OP_EQUALITY = #['==', '!=', '===', '!==']
	public static val ASIGNATION = '='
		
	public static val OP_BOOLEAN_AND = #['and', "&&"]
	public static val OP_BOOLEAN_OR = #["or", "||"]
	
	public static val OP_BOOLEAN = #['and', "&&", "or", "||"]
	public static val OP_UNARY_BOOLEAN = #['!', "not"]
	
	public static val SELF = "self"
	public static val NULL = "null"
	public static val METHOD = "method"
	public static val CONSTRUCTOR = "constructor"
	public static val VAR = "var"
	public static val CONST = "const"
	public static val OVERRIDE = "override"
	public static val RETURN = "return"
	public static val IMPORT = "import"
	public static val SUITE = "describe"
	public static val TEST = "test"
	public static val MIXIN = "mixin"
	public static val CLASS = "class"
	public static val WKO = "object"
	public static val FIXTURE = "fixture"
	public static val PROGRAM = "program" 
	
	public static val ROOT_CLASS = "Object"
	public static val FQN_ROOT_CLASS = "wollok.lang.Object"
	
	public static val MULTIOPS_REGEXP = "[+\\-*/%]="

}