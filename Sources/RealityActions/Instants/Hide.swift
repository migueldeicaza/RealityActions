//
//  Hide.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// This actions sets the `isEnabled` property to false, causing the entity to be hidden
public class Hide: ActionInstant {
    override func startAction(target: Entity) -> ActionState? {
        HideState (action: self, target: target)
    }
    
    override public func reverse() -> FiniteTimeAction {
        Show()
    }
}

class HideState: ActionInstantState {
    override init(action: FiniteTimeAction, target: Entity) {
        super.init(action: action, target: target)
        target.isEnabled = false
    }
}

