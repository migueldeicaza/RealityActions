//
//  JumpTo.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Moves a Node object to a parabolic position simulating a jump movement by modifying it's position attribute.
public class JumpTo: JumpBy {
    public override init (duration: Float, position: SIMD3<Float>, height: Float, jumps: Int) {
        super.init(duration: duration, position: position, height: height, jumps: jumps)
    }
    
    override func startAction(target: Entity) -> ActionState? {
        return JumpToState (action: self, target: target)
    }
}

class JumpToState: JumpByState {
    
    init(action: JumpTo, target: Entity) {
        super.init(action: action, target: target, delta: action.position-target.position)
    }
}
