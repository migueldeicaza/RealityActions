//
//  ScaleTo.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Scales an Entity to the specified size
public class ScaleTo: FiniteTimeAction {
    let finalScale: SIMD3<Float>
    
    /// Initializes a scale action
    /// - Parameters:
    ///   - duration: The duration for the scaling process
    ///   - scale: The desired scale, represented as a vector for the X, Y and Z components
    public init (duration: Float, scale: SIMD3<Float>) {
        self.finalScale = scale
        super.init(duration: duration)
    }
    
    /// Initializes a scale action
    /// - Parameters:
    ///   - duration: The duration for the scaling process
    ///   - scale: The desired scale which is applied uniformly to the x, y and z components
    public convenience init (duration: Float, scale: Float) {
        self.init (duration: duration, scale: SIMD3<Float> (scale, scale, scale))
    }
    
    override func startAction(target: Entity) -> ActionState? {
        ScaleToState (action: self, target: target)
    }
    
    public override func reverse() -> FiniteTimeAction {
        print ("Not available")
        return self
    }

}

class ScaleToState: FiniteTimeActionState {
    let st: ScaleTo
    let startScale, endScale: SIMD3<Float>
    var delta: SIMD3<Float>
    
    init(action: ScaleTo, target: Entity) {
        st = action
        startScale = target.transform.scale
        endScale = action.finalScale
        delta = endScale - startScale
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        guard let target else { return }
        target.transform.scale = startScale + delta * time
    }
}
