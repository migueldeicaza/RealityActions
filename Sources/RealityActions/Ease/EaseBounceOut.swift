//
//  EaseBounceOut.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: bounce out
public class EaseBounceOut: ActionEase {
    public override init (action: FiniteTimeAction) {
        super.init(action: action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseBounceOutState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseBounceIn (action: innerAction.reverse ())
    }
}

class EaseBounceOutState: ActionEaseState {
    init? (action: EaseBounceOut, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: bounceOut (time: time))
    }
}
