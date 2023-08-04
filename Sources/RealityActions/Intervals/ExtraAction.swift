//
//  ExtraAction.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

// Extra action for making a Sequence or Spawn when only adding one action to it.
class ExtraAction: FiniteTimeAction {
    public override init (duration: Float) {
        super.init(duration: duration)
    }
    
    override func startAction(target: Entity) -> ActionState? {
        return ExtraActionState (action: self, target: target)
    }
    
    public override func reverse() -> FiniteTimeAction {
        return ExtraAction(duration: duration)
    }
}

class ExtraActionState: FiniteTimeActionState {
    init(action: ExtraAction, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func step(dt: Float) {
    }
    override func update(time: Float) {
    }
}
