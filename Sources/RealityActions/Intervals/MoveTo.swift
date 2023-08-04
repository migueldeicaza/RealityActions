//
//  MoveTo.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Moves an entity to a position
/// The position is an absolute coordinate.
/// Several MoveTo actions can be concurrently called, and the resulting movement will be the sum of individual movements.
public class MoveTo: MoveBy {
    var endPosition: SIMD3<Float>
    
    public init (duration: Float, position: SIMD3<Float>) {
        endPosition = position
        super.init(duration: duration, delta: position)
    }
    
    override func startAction(target: Entity) -> ActionState? {
        return MoveToState (action: self, target: target)
    }
}

class MoveToState: MoveByState {
    init(action: MoveTo, target: Entity) {
        let positionDelta = action.endPosition - target.position
        super.init(action: action, target: target, delta: positionDelta)
    }
    
    override func update(time: Float) {
        guard let target else { return }
        
        let newPos = startPosition + delta * time
        target.position = newPos
        previousPosition = newPos
    }
}
