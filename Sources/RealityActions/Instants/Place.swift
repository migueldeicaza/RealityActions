//
//  Place.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// This action sets the position of the entity
public class Place: ActionInstant {
    let pos: SIMD3<Float>
    
    public init (_ pos: SIMD3<Float>) {
        self.pos = pos
        super.init()
    }
    
    public init (x: Float, y: Float, z: Float) {
        self.pos = SIMD3<Float>(x, y, z)
        super.init()
    }
    
    override func startAction(target: Entity) -> ActionState? {
        PlaceState (action: self, target: target)
    }
}

class PlaceState: ActionInstantState {
    init(action: Place, target: Entity) {
        super.init(action: action, target: target)
        target.position = action.pos
    }
}

