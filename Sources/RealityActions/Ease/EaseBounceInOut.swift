//
//  EaseBounceInOut.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: bounce in and then out
public class EaseBounceInOut: ActionEase {
    public override init (_ action: FiniteTimeAction) {
        super.init(action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseBounceInOutState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseBounceInOut (innerAction.reverse ())
    }
}

class EaseBounceInOutState: ActionEaseState {
    init? (action: EaseBounceInOut, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: bounceInOut (time: time))
    }
}
