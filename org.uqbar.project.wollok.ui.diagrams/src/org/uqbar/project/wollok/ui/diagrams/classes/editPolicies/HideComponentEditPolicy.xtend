package org.uqbar.project.wollok.ui.diagrams.classes.editPolicies

import org.eclipse.gef.editpolicies.ConnectionEditPolicy
import org.eclipse.gef.requests.GroupRequest
import org.uqbar.project.wollok.ui.diagrams.classes.model.commands.HideComponentCommand

/**
 * 
 * Feedback effect that allows user to hide a part.
 * That could be a component (wko, class, mixin), variable or method
 * 
 */
class HideComponentEditPolicy extends ConnectionEditPolicy {
	
	override protected getDeleteCommand(GroupRequest request) {
		new HideComponentCommand
	}
	
}