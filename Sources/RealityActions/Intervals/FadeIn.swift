//
//  FadeIn.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

// Extra action for making a Sequence or Spawn when only adding one action to it.
class FadeIn: FiniteTimeAction {
    public override init (duration: Float) {
        super.init(duration: duration)
        fatalError()
    }
    
    override func startAction(target: Entity) -> ActionState? {
        return FadeInState (action: self, target: target)
    }
    
    public override func reverse() -> FiniteTimeAction {
        fatalError()
    }
}

class FadeInState: FiniteTimeActionState {
    init(action: FadeIn, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func step(dt: Float) {
    }
    override func update(time: Float) {
    }
}
