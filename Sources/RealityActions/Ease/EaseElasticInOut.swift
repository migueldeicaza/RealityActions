//
//  EaseElasticOut.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: elastic-in-and-then-out
public class EaseElasticInOut: EaseElastic {
    public override init (_ action: FiniteTimeAction, period: Float = 0.3) {
        super.init(action, period: period)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseElasticInOutState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseElasticIn (innerAction.reverse (), period: period)
    }
}

class EaseElasticInOutState: ActionEaseState {
    let period: Float
    
    init? (action: EaseElasticInOut, target: Entity) {
        period = action.period
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: elasticInOut (time: time, period: period))
    }
}
