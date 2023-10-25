//
//  ToggleVisibility.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// This actions toggles the `isEnabled` property on the reality kit Entity
public class ToggleVisibility: ActionInstant {
    override func startAction(target: Entity) -> ActionState? {
        ToggleVisibilityState (action: self, target: target)
    }
}

class ToggleVisibilityState: ActionInstantState {
    override init(action: FiniteTimeAction, target: Entity) {
        super.init(action: action, target: target)
        target.isEnabled = !target.isEnabled
    }
}

