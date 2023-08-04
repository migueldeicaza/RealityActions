
//
//  EaseElastic.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Base class for the EaseElastic easing function, use one of those.
public class EaseElastic: ActionEase {
    let period: Float
    public init (action: FiniteTimeAction, period: Float = 0.3) {
        self.period = period
        super.init(action: action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseElasticState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        return self
    }
}

class EaseElasticState: ActionEaseState {
    let period: Float
    init? (action: EaseElastic, target: Entity) {
        self.period = action.period
        super.init(action: action, target: target)
    }    
}
