//
//  MoveBy.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Moves a Node object simulating a parabolic jump movement by modifying it's position attribute.
public class MoveBy: FiniteTimeAction {
    let delta: SIMD3<Float>
    
    public init (duration: Float, delta: SIMD3<Float>) {
        self.delta = delta
        super.init(duration: duration)
    }
    
    override func startAction(target: Entity) -> ActionState? {
        return MoveByState (action: self, target: target, delta: delta)
    }
    
    public override func reverse() -> FiniteTimeAction {
        MoveBy(duration: duration, delta: -delta)
    }

}

class MoveByState: FiniteTimeActionState {
    let mv: MoveBy
    var startPosition, previousPosition: SIMD3<Float>
    var delta: SIMD3<Float>
    
    init(action: MoveBy, target: Entity, delta: SIMD3<Float>) {
        mv = action
        self.delta = delta
        startPosition = target.position
        previousPosition = target.position
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        guard let target else { return }
        let currentPos = target.position
//        let diff = currentPos - previousPosition
//        startPosition = diff + startPosition
        
        //print ("startPosition=\(startPosition) delta=\(delta) time=\(time)")
        let newPos = startPosition + delta * time
        target.position = newPos
        
        previousPosition = newPos
    }
}
