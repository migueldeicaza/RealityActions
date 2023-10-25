//
//  ApplyTransform.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// This action sets the Entity's transform property to the one specified
public class ApplyTransform: ActionInstant {
    let transform: Transform
    /// Constructs an instance of ``ApplyTransform``
    /// - Parameter transform: the tranform that you want to apply to the entity
    public init (_ transform: Transform) {
        self.transform = transform
        super.init()
    }
    
    override func startAction(target: Entity) -> ActionState? {
        ApplyTransformState (action: self, target: target)
    }
}

class ApplyTransformState: ActionInstantState {
    init(action: ApplyTransform, target: Entity) {
        super.init(action: action, target: target)
        target.transform = action.transform
    }
}

