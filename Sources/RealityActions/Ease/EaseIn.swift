//
//  EaseIn.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: ease-in
public class EaseIn: EaseRateAction {
    public override init (action: FiniteTimeAction, rate: Float) {
        super.init(action: action, rate: rate)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseInState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseIn (action: innerAction.reverse (), rate: 1/rate)
    }
}

class EaseInState: EaseRateActionState {
    init? (action: EaseIn, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: powf(time, rate))
    }
}
