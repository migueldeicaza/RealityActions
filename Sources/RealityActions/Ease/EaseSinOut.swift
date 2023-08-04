//
//  EaseSinOut.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: ease sin out
public class EaseSinOut: ActionEase {
    public override init (action: FiniteTimeAction) {
        super.init(action: action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseSinOutState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseSinIn (action: innerAction.reverse ())
    }
}

class EaseSinOutState: ActionEaseState {
    init? (action: EaseSinOut, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: sineOut (time: time))
    }
}
