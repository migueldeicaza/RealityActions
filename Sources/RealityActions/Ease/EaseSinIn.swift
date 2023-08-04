//
//  EaseSinIn.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: ease sin-in
public class EaseSinIn: ActionEase {
    public override init (_ action: FiniteTimeAction) {
        super.init(action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseSinInState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseSinOut (innerAction.reverse ())
    }
}

class EaseSinInState: ActionEaseState {
    init? (action: EaseSinIn, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: sineIn (time: time))
    }
}
