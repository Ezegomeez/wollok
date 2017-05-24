package org.uqbar.project.wollok.ui.diagrams.classes.parts;

import org.uqbar.project.wollok.ui.diagrams.classes.model.ClassModel
import org.uqbar.project.wollok.ui.diagrams.classes.model.NamedObjectModel
import org.uqbar.project.wollok.ui.diagrams.classes.view.ClassDiagramColors
import org.uqbar.project.wollok.ui.diagrams.classes.view.WClassFigure

import static extension org.uqbar.project.wollok.model.WMethodContainerExtensions.*

/**
 * 
 * @author jfernandes
 */
class ClassEditPart extends AbstractMethodContainerEditPart {
	
	override createFigure() {
		new WClassFigure(castedModel.name, castedModel.foregroundColor, castedModel.backgroundColor, castedModel.configuration.showVariables) => [ f |
			f.abstract = castedModel.getComponent.abstract
		]
	}
	
	def foregroundColor(ClassModel c) {
		if (c.component.isWellKnownObject) return ClassDiagramColors.NAMED_OBJECTS_FOREGROUND 
		if (c.imported) {
			ClassDiagramColors.IMPORTED_CLASS_FOREGROUND			
		} else {
			ClassDiagramColors.CLASS_FOREGROUND	
		}
	}
	
	def backgroundColor(ClassModel c) {
		if (c.component.isWellKnownObject) return ClassDiagramColors.NAMED_OBJECTS__BACKGROUND
		if (c.imported) {
			ClassDiagramColors.IMPORTED_CLASS_BACKGROUND			
		} else {
			ClassDiagramColors.CLASS_BACKGROUND	
		}
	}

	override getLanguageElement() { castedModel.getComponent }
	
	override ClassModel getCastedModel() { model as ClassModel }
	
	override doGetModelChildren() {
		if (castedModel.configuration.showVariables) castedModel.getComponent.members else castedModel.getComponent.methods.toList
	}

}