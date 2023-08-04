//
//  RemoveSelf.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// This action removes the entity from its parent.
public class RemoveSelf: ActionInstant {
    override func startAction(target: Entity) -> ActionState? {
        RemoveSelfState (action: self, target: target)
    }
    
    override public func reverse() -> FiniteTimeAction {
        fatalError("Can not reverse a RemoveSelf operation")
    }
}

class RemoveSelfState: ActionInstantState {
    override init(action: FiniteTimeAction, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        guard let target else { return }
        target.parent?.removeChild(target)
    }
}

