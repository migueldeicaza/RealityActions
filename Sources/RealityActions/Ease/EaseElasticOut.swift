//
//  EaseElasticInOut.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: elastic-out
public class EaseElasticOut: EaseElastic {
    public override init (action: FiniteTimeAction, period: Float = 0.3) {
        super.init(action: action, period: period)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseElasticOutState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseElasticIn (action: innerAction.reverse (), period: period)
    }
}

class EaseElasticOutState: ActionEaseState {
    let period: Float
    
    init? (action: EaseElasticOut, target: Entity) {
        period = action.period
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: elasticOut (time: time, period: period))
    }
}
