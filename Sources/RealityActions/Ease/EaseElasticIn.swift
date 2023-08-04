//
//  EaseElasticIn.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: elastic-in
public class EaseElasticIn: EaseElastic {
    public override init (_ action: FiniteTimeAction, period: Float = 0.3) {
        super.init(action, period: period)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseElasticInState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseElasticOut (innerAction.reverse (), period: period)
    }
}

class EaseElasticInState: ActionEaseState {
    let period: Float
    
    init? (action: EaseElasticIn, target: Entity) {
        period = action.period
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: elasticIn (time: time, period: period))
    }
}
