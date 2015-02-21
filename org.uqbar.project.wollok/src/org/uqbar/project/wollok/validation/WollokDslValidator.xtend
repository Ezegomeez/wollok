package org.uqbar.project.wollok.validation

import com.google.inject.Inject
import it.xsemantics.runtime.RuleEnvironment
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.ui.editor.preferences.IPreferenceStoreAccess
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.ValidationMessageAcceptor
import org.uqbar.project.wollok.interpreter.WollokInterpreterEvaluator
import org.uqbar.project.wollok.semantics.validation.WollokDslTypeSystemValidator
import org.uqbar.project.wollok.wollokDsl.WAssignment
import org.uqbar.project.wollok.wollokDsl.WBinaryOperation
import org.uqbar.project.wollok.wollokDsl.WBlockExpression
import org.uqbar.project.wollok.wollokDsl.WCatch
import org.uqbar.project.wollok.wollokDsl.WClass
import org.uqbar.project.wollok.wollokDsl.WClosure
import org.uqbar.project.wollok.wollokDsl.WConstructor
import org.uqbar.project.wollok.wollokDsl.WConstructorCall
import org.uqbar.project.wollok.wollokDsl.WExpression
import org.uqbar.project.wollok.wollokDsl.WMemberFeatureCall
import org.uqbar.project.wollok.wollokDsl.WMethodDeclaration
import org.uqbar.project.wollok.wollokDsl.WNamed
import org.uqbar.project.wollok.wollokDsl.WObjectLiteral
import org.uqbar.project.wollok.wollokDsl.WPackage
import org.uqbar.project.wollok.wollokDsl.WPostfixOperation
import org.uqbar.project.wollok.wollokDsl.WProgram
import org.uqbar.project.wollok.wollokDsl.WReferenciable
import org.uqbar.project.wollok.wollokDsl.WSuperInvocation
import org.uqbar.project.wollok.wollokDsl.WTry
import org.uqbar.project.wollok.wollokDsl.WVariableDeclaration
import org.uqbar.project.wollok.wollokDsl.WVariableReference

import static org.uqbar.project.wollok.wollokDsl.WollokDslPackage.Literals.*

import static extension org.uqbar.project.wollok.model.WMethodContainerExtensions.*
import static extension org.uqbar.project.wollok.model.WollokModelExtensions.*
import static extension org.uqbar.project.wollok.utils.WEclipseUtils.*
import org.uqbar.project.wollok.wollokDsl.WFile
import org.uqbar.project.wollok.wollokDsl.WNamedObject

/**
 * Custom validation rules.
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 * 
 * @author jfernandes
 */
// TODO: abstract a new generic Validator that is integrated with a preferences mechanism
// that will allow to enabled/disabled checks, and maybe even configure the issue severity for some
// like "error/warning/ignore". It could be completely automatically based on annotations.
// Ex:
//  @Check @ConfigurableSeverity @EnabledDisabled
class WollokDslValidator extends WollokDslTypeSystemValidator {
	@Inject IPreferenceStoreAccess preferenceStoreAccess;
	// pasar a otra clase con constantes de preferencias
	public static val TYPE_SYSTEM_CHECKS_ENABLED = "TYPE_SYSTEM_CHECKS_ENABLED"

	// ERROR KEYS	
	public static val CANNOT_ASSIGN_TO_VAL = "CANNOT_ASSIGN_TO_VAL"
	public static val CANNOT_ASSIGN_TO_NON_MODIFIABLE = "CANNOT_ASSIGN_TO_NON_MODIFIABLE"
	public static val CLASS_NAME_MUST_START_UPPERCASE = "CLASS_NAME_MUST_START_UPPERCASE"
	public static val REFERENCIABLE_NAME_MUST_START_LOWERCASE = "REFERENCIABLE_NAME_MUST_START_LOWERCASE"
	public static val METHOD_ON_THIS_DOESNT_EXIST = "METHOD_ON_THIS_DOESNT_EXIST"
	public static val METHOD_MUST_HAVE_OVERRIDE_KEYWORD = "METHOD_MUST_HAVE_OVERRIDE_KEYWORD" 
	public static val TYPE_SYSTEM_ERROR = "TYPE_SYSTEM_ERROR"
	public static val ERROR_TRY_WITHOUT_CATCH_OR_ALWAYS = "ERROR_TRY_WITHOUT_CATCH_OR_ALWAYS"
	
	// WARNING KEYS
	public static val WARNING_UNUSED_VARIABLE = "WARNING_UNUSED_VARIABLE"

	@Check
	def checkProgramTypes(WFile file) {
		//TODO: lee las preferencias cada vez!
		try
			if (!preferences(file).getBoolean(TYPE_SYSTEM_CHECKS_ENABLED)) 
				return
		catch (IllegalStateException e)
			// headless launcher doesn't open workspace, so this fails.
			// but it's ok since the type system won't run in runtime. 
			return;
		
		var RuleEnvironment env = xsemanticsSystem.emptyEnvironment
		errorGenerator.generateErrors(decorateErrorAcceptor(this, TYPE_SYSTEM_ERROR), xsemanticsSystem.inferTypes(env, file.body), file.body)
	}
	
	@Check
	def classNameMustStartWithUpperCase(WClass c) {
		if (Character.isLowerCase(c.name.charAt(0))) error("Class name must start with uppercase", c, WNAMED__NAME, CLASS_NAME_MUST_START_UPPERCASE)
	}
	
	@Check
	def referenciableNameMustStartWithLowerCase(WReferenciable c) {
		if (Character.isUpperCase(c.name.charAt(0))) error("Referenciable name must start with lowercase", c, WNAMED__NAME, REFERENCIABLE_NAME_MUST_START_LOWERCASE)
	}

	@Check
	def checkCannotInstantiateAbstractClasses(WConstructorCall c) {
		if(c.classRef.isAbstract) error("Cannot instantiate abstract class", c, WCONSTRUCTOR_CALL__CLASS_REF)
	}

	@Check
	def checkConstructorCall(WConstructorCall c) {
		if (!c.isValidConstructorCall()) {
			val expectedMessage = if (c.classRef.constructor == null)
					""
				else
					c.classRef.constructor.parameters.map[name].join(",")
			error("Wrong number of arguments. Should be (" + expectedMessage + ")", c, WCONSTRUCTOR_CALL__ARGUMENTS)
		}
	}

	@Check
	def checkMethodActuallyOverrides(WMethodDeclaration m) {
		val overrides = m.actuallyOverrides
		if(m.overrides && !overrides) m.error("Method does not overrides anything")
		if (overrides && !m.overrides)
			m.error("Method must be marked as overrides, since it overrides a superclass method", METHOD_MUST_HAVE_OVERRIDE_KEYWORD)
	}

	@Check
	def checkCannotAssignToVal(WAssignment a) {
		if(!a.feature.ref.isModifiable) error("Cannot modify values", a, WASSIGNMENT__FEATURE, cannotModifyErrorId(a.feature))
	}
	def dispatch String cannotModifyErrorId(WReferenciable it) { CANNOT_ASSIGN_TO_NON_MODIFIABLE }
	def dispatch String cannotModifyErrorId(WVariableDeclaration it) { CANNOT_ASSIGN_TO_VAL }
	def dispatch String cannotModifyErrorId(WVariableReference it) { cannotModifyErrorId(ref) }

	@Check
	def duplicated(WMethodDeclaration m) {
		if (m.declaringContext.members.filter(WMethodDeclaration).exists[it != m && it.name == m.name])
			m.error("Duplicated method")
	}

	@Check
	def duplicated(WReferenciable p) {
		if(p.isDuplicated) p.error("Duplicated name")
	}

	@Check
	def methodInvocationToThisMustExist(WMemberFeatureCall call) {
		if (call.callOnThis && call.method != null && !call.method.declaringContext.isValidCall(call)) {
			error("Method does not exist or invalid number of arguments", call, WMEMBER_FEATURE_CALL__FEATURE, METHOD_ON_THIS_DOESNT_EXIST)
		}
	}

	@Check
	def unusedVariables(WVariableDeclaration it) {
		val assignments = variable.assignments
		if (assignments.empty) {
			if (writeable)
				warning('''Variable is never assigned''', it, WVARIABLE_DECLARATION__VARIABLE)
			else if (!writeable)
				error('''Variable is never assigned''', it, WVARIABLE_DECLARATION__VARIABLE)	
		}
		if (variable.uses.empty)
			warning('''Unused variable''', it, WVARIABLE_DECLARATION__VARIABLE, WARNING_UNUSED_VARIABLE)
	}
	
	@Check
	def superInvocationOnlyInValidMethod(WSuperInvocation sup) {
		val body = sup.method.expression as WBlockExpression
		if (sup.method.declaringContext instanceof WObjectLiteral)
			error("Super can only be used in a method belonging to a class", body, WBLOCK_EXPRESSION__EXPRESSIONS, body.expressions.indexOf(sup))
		else if (!sup.method.overrides)
			error("Super can only be used in an overriding method", body, WBLOCK_EXPRESSION__EXPRESSIONS, body.expressions.indexOf(sup))
		else if (sup.memberCallArguments.size != sup.method.parameters.size)
			error('''Incorrect number of arguments for super. Expecting «sup.method.parameters.size» for: «sup.method.overridenMethod.parameters.map[name].join(", ")»''', body, WBLOCK_EXPRESSION__EXPRESSIONS, body.expressions.indexOf(sup))
	}
	
	// ***********************
	// ** Exceptions
	// ***********************
	
	@Check
	def tryMustHaveEitherCatchOrAlways(WTry tri) {
		if ((tri.catchBlocks == null || tri.catchBlocks.empty) && tri.alwaysExpression == null)
			error("Try block must specify either a 'catch' or a 'then always' clause", tri, WTRY__EXPRESSION, ERROR_TRY_WITHOUT_CATCH_OR_ALWAYS)
	}
	
	@Check 
	def catchExceptionTypeMustExtendException(WCatch it) {
		if (!exceptionType.exception) error("Can only catch wollok.lang.Exception or a subclass of it", it, WCATCH__EXCEPTION_TYPE)
	}
	
// requires type system in order to infer type of the WExpression being thrown ! "throw <??>"
//	@Check
//	def canOnlyThrowExceptionTypeObjects(WThrow it) {
//		if (!it.exception.type.isException) error("Can only throw wollok.lang.Exception or a subclass of it", it, WCATCH__EXCEPTION_TYPE)
//	}
	
	@Check
	def postFixOpOnlyValidforVarReferences(WPostfixOperation op) {
		if (!(op.operand.isVarRef))
			error(op.feature + " can only be applied to variable references", op, WPOSTFIX_OPERATION__OPERAND)
	}
	
	@Check
	def classNameCannotBeDuplicatedWithinPackage(WPackage p) {
		val classes = p.elements.filter(WClass)
		val repeated = classes.filter[c| classes.exists[it != c && name == c.name] ]
		repeated.forEach[
			error('''Duplicated class name in package «p.name»''', it, WNAMED__NAME)
		]
	}
	
	@Check 
	def avoidDuplicatedPackageName(WPackage p) {
		if (p.eContainer.eContents.filter(WPackage).exists[it != p && name == p.name])
			error('''Duplicated package name «p.name»''', p, WNAMED__NAME)
	}
	
	@Check
	def multiOpOnlyValidforVarReferences(WBinaryOperation op) {
		if (WollokInterpreterEvaluator.isMultiOpAssignment(op.feature) && !op.leftOperand.isVarRef)
			error(op.feature + " can only be applied to variable references", op, WBINARY_OPERATION__LEFT_OPERAND)
	}
	
	def isVarRef(WExpression e) { e instanceof WVariableReference }

	// ******************************	
	// native methods
	// ******************************
	
	@Check
	def nativeMethodsChecks(WMethodDeclaration it) {
		if (native) {
			 if (expression != null) error("Native methods cannot have a body", it, WMETHOD_DECLARATION__EXPRESSION)
			 if (overrides) error("Native methods cannot override anything", it, WMETHOD_DECLARATION__OVERRIDES)
			 if (declaringContext instanceof WObjectLiteral) error("Native methods can only be defined in classes", it, WMETHOD_DECLARATION__NATIVE)
			 // this is currently a limitation on native objects
			 if(declaringContext instanceof WClass)
				 if ((declaringContext as WClass).parent != null && (declaringContext as WClass).parent.native)
				 	error("Cannot declare native methods in this class since there's already a native super class in the hierarchy", it, WMETHOD_DECLARATION__NATIVE)
		}
	}

	// ******************************
	// ** is duplicated impl (TODO: move it to extensions)
	// ******************************
	
	def boolean isDuplicated(WReferenciable reference) {
		reference.eContainer.isDuplicated(reference)
	}

	// Root objects (que no tiene acceso a variables fuera de ellos)
	def dispatch boolean isDuplicated(WClass c, WReferenciable v) {
		c.variables.existsMoreThanOne(v)
	}

	def dispatch boolean isDuplicated(WProgram p, WReferenciable v) {
		p.variables.existsMoreThanOne(v)
	}

	def dispatch boolean isDuplicated(WMethodDeclaration m, WReferenciable v) {
		m.parameters.existsMoreThanOne(v) || m.declaringContext.isDuplicated(v)
	}

	def dispatch boolean isDuplicated(WBlockExpression c, WReferenciable v) {
		c.expressions.existsMoreThanOne(v) || c.eContainer.isDuplicated(v)
	}

	def dispatch boolean isDuplicated(WClosure c, WReferenciable r) {
		c.parameters.existsMoreThanOne(r) || c.eContainer.isDuplicated(r)
	}

	def dispatch boolean isDuplicated(WConstructor c, WReferenciable r) {
		c.parameters.existsMoreThanOne(r) || c.eContainer.isDuplicated(r)
	}

	def dispatch boolean isDuplicated(WNamedObject c, WReferenciable r) {
		c.variables.existsMoreThanOne(r)
	}

	def dispatch boolean isDuplicated(WPackage p, WNamedObject r){
		p.namedObjects.existsMoreThanOne(r)
	}

	// default case is to delegate up to container
	def dispatch boolean isDuplicated(EObject e, WReferenciable r) {
		e.eContainer.isDuplicated(r)
	}

	def existsMoreThanOne(Iterable<?> exps, WReferenciable ref) {
		exps.filter(WReferenciable).exists[it != ref && name == ref.name]
	}

	// ******************************
	// ** extensions to validations.
	// ******************************
	
	def error(WNamed e, String message) { error(message, e, WNAMED__NAME) }
	def error(WNamed e, String message, String errorId) { error(message, e, WNAMED__NAME, errorId) }
	
	def preferences(EObject obj) {
		preferenceStoreAccess.getContextPreferenceStore(obj.getFile.project)
	}
	
	def decorateErrorAcceptor(ValidationMessageAcceptor a, String defaultCode) {
		new DecoratedValidationMessageAcceptor(a, defaultCode)
	}

}
