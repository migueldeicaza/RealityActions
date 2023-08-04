//
//  ScaleBy.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Applies a delta scale to the entity
public class ScaleBy: ScaleTo {
    let scale: SIMD3<Float>
    
    /// Initializes the ScaleBy action
    /// - Parameters:
    ///   - duration: The duration for the scaling process
    ///   - scale: The delta for the scale operation
    public override init (duration: Float, scale: SIMD3<Float>) {
        self.scale = scale
        super.init(duration: duration, scale: scale)
    }
    
    public convenience init (duration: Float, scale: Float) {
        self.init (duration: duration, scale: SIMD3<Float> (scale, scale, scale))
    }
    

    override func startAction(target: Entity) -> ActionState? {
        ScaleByState (action: self, target: target)
    }
    
    public override func reverse() -> FiniteTimeAction {
        ScaleBy(duration: duration, scale: 1/scale)
    }

}

class ScaleByState: ScaleToState {
    init(action: ScaleBy, target: Entity) {
        super.init(action: action, target: target)
        delta = startScale * endScale - startScale
    }
}
