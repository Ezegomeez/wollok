/*
 * generated by Xtext
 */
package org.uqbar.project.wollok;

import org.eclipse.xtext.common.types.TypesFactory;
import org.eclipse.xtext.common.types.access.IJvmTypeProvider;
import org.eclipse.xtext.linking.ILinkingDiagnosticMessageProvider;
import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.resource.IDefaultResourceDescriptionStrategy;
import org.eclipse.xtext.scoping.IGlobalScopeProvider;
import org.uqbar.project.wollok.interpreter.SysoutWollokInterpreterConsole;
import org.uqbar.project.wollok.interpreter.WollokInterpreterConsole;
import org.uqbar.project.wollok.interpreter.WollokInterpreterEvaluator;
import org.uqbar.project.wollok.interpreter.api.XInterpreterEvaluator;
import org.uqbar.project.wollok.interpreter.core.WollokObject;
import org.uqbar.project.wollok.interpreter.natives.DefaultNativeObjectFactory;
import org.uqbar.project.wollok.interpreter.natives.NativeObjectFactory;
import org.uqbar.project.wollok.linking.WollokLinker;
import org.uqbar.project.wollok.linking.WollokLinkingDiagnosticMessageProvider;
import org.uqbar.project.wollok.manifest.BasicWollokManifestFinder;
import org.uqbar.project.wollok.manifest.WollokManifestFinder;
import org.uqbar.project.wollok.scoping.WollokGlobalScopeProvider;
import org.uqbar.project.wollok.scoping.WollokImportedNamespaceAwareLocalScopeProvider;
import org.uqbar.project.wollok.scoping.WollokQualifiedNameProvider;
import org.uqbar.project.wollok.scoping.WollokResourceDescriptionStrategy;
import org.uqbar.project.wollok.utils.DummyJvmTypeProviderFactory;

import com.google.inject.Binder;

/**
 * Use this class to register components to be used at runtime / without the
 * Equinox extension registry.
 */
public class WollokDslRuntimeModule extends
		org.uqbar.project.wollok.AbstractWollokDslRuntimeModule {

	@Override
	public void configure(Binder binder) {
		super.configure(binder);
		
		binder.bind(NativeObjectFactory.class).to(DefaultNativeObjectFactory.class);
		
		// TYPE SYSTEM
		// binder.bind(TypeSystem.class).to(ConstraintBasedTypeSystem.class);
		
		
		// Hacks to be able to reuse the logic to extract method from refactoring
//		binder.bind(IJvmModelAssociations.class).to(DummyJvmModelAssociations.class); 
		binder.bind(IJvmTypeProvider.Factory.class).to(DummyJvmTypeProviderFactory.class);
		binder.bind(TypesFactory.class).toInstance(org.eclipse.xtext.common.types.TypesFactory.eINSTANCE);
		
		binder.bind(ILinkingDiagnosticMessageProvider.Extended.class).to(WollokLinkingDiagnosticMessageProvider.class);
	}

	// customize exported objects
	public Class<? extends IDefaultResourceDescriptionStrategy> bindIDefaultResourceDescriptionStrategy() {
		return WollokResourceDescriptionStrategy.class;
	}

	public Class<? extends IGlobalScopeProvider> bindIGlobalScopeProvider() {
		return WollokGlobalScopeProvider.class;
	}

	/*
	 * public Class<? extends IScopeProvider> bindIScopeProvider() { return
	 * WollokImportedNamespaceAwareLocalScopeProvider.class; }
	 */

	public Class<? extends WollokManifestFinder> bindWollokManifestFinder() {
		return BasicWollokManifestFinder.class;
	}

	public void configureIScopeProviderDelegate(com.google.inject.Binder binder) {
		binder.bind(org.eclipse.xtext.scoping.IScopeProvider.class)
				.annotatedWith(
						com.google.inject.name.Names
								.named(org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider.NAMED_DELEGATE))
				.to(WollokImportedNamespaceAwareLocalScopeProvider.class);
	}

	public Class<? extends IQualifiedNameProvider> bindIQualifiedNameProvider() {
		return WollokQualifiedNameProvider.class;
	}

	public Class<? extends XInterpreterEvaluator<WollokObject>> bindXInterpreterEvaluator() {
		return WollokInterpreterEvaluator.class;
	}

	public Class<? extends WollokInterpreterConsole> bindWollokInterpreterConsole() {
		return SysoutWollokInterpreterConsole.class;
	}

	public Class<? extends org.eclipse.xtext.linking.ILinker> bindILinker() {
		return WollokLinker.class;
	}

}
