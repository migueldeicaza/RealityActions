//
//  RotateBy.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Rotates the transformation of the target by the specified degrees
public class RotateBy: FiniteTimeAction {
    let deltaAngles: SIMD3<Float>
    
    /// Creates a rotation
    /// - Parameters:
    ///   - duration: time for the rotation to take place
    ///   - deltaAngles: this vector contains the angle values in X, Y and Z that you want to perform
    public init (duration: Float, deltaAngles: SIMD3<Float>) {
        self.deltaAngles = deltaAngles
        super.init(duration: duration)
    }
    
    override func startAction(target: Entity) -> ActionState? {
        RotateByState (action: self, target: target, deltaAngles: deltaAngles)
    }
    
    public override func reverse() -> FiniteTimeAction {
        RotateBy(duration: duration, deltaAngles: -deltaAngles)
    }

}

class RotateByState: FiniteTimeActionState {
    let rb: RotateBy
    var startRotation: simd_quatf
    var deltaAngles: SIMD3<Float>
    
    init(action: RotateBy, target: Entity, deltaAngles: SIMD3<Float>) {
        rb = action
        startRotation = target.transform.rotation
        self.deltaAngles = deltaAngles
        super.init(action: action, target: target)
    }
    
    let deg2radians2: Float = .pi / 360
    
    override func update(time: Float) {
        guard let target else { return }
        let newRot = startRotation * quaternionFromEuler(angles: deltaAngles * time)
        target.transform.rotation = newRot.normalized
    }
}
