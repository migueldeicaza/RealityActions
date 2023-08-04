//
//  RotateTo.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Rotates the transformation of the target by the specified degrees
public class RotateTo: FiniteTimeAction {
    let distanceAngle: SIMD3<Float>
    
    /// Creates a rotation
    /// - Parameters:
    ///   - duration: time for the rotation to take place
    ///   - deltaAngles: this vector contains the angle values in X, Y and Z that you want to perform
    public init (duration: Float, distanceAngle: SIMD3<Float>) {
        self.distanceAngle = distanceAngle
        super.init(duration: duration)
    }
    
    override func startAction(target: Entity) -> ActionState? {
        RotateToState (action: self, target: target)
    }
    
    public override func reverse() -> FiniteTimeAction {
        fatalError("Not supported")
    }

}

class RotateToState: FiniteTimeActionState {
    let rt: RotateTo
    var distanceAngle: SIMD3<Float>
    var diffAngleX, diffAngleY, diffAngleZ: Float
    var startAngleX, startAngleY, startAngleZ: Float
    
    init(action: RotateTo, target: Entity) {
        rt = action
        distanceAngle = action.distanceAngle
        let sourceRotation = toEulerAngles (target.transform.rotation)
        
        // Calculate X
        startAngleX = sourceRotation.x
        startAngleX = startAngleX > 0 ? startAngleX.truncatingRemainder(dividingBy: 360.0) : startAngleX.truncatingRemainder(dividingBy: -360.0)
        diffAngleX = distanceAngle.x - startAngleX
        if diffAngleX > 180 {
            diffAngleX -= 360
        }
        if diffAngleX < -180 {
            diffAngleX += 360
        }
        
        //Calculate Y
        startAngleY = sourceRotation.y
        startAngleY = startAngleY > 0 ? startAngleY.truncatingRemainder(dividingBy: 360.0) : startAngleY.truncatingRemainder(dividingBy: -360.0)
        diffAngleY = distanceAngle.y - startAngleY
        if diffAngleY > 180 {
            diffAngleY -= 360
        }
        if diffAngleY < -180 {
            diffAngleY += 360
        }
        
        //Calculate Z
        startAngleZ = sourceRotation.z
        startAngleZ = startAngleZ > 0 ? startAngleZ.truncatingRemainder(dividingBy: 360.0) : startAngleZ.truncatingRemainder(dividingBy: -360.0)
        diffAngleZ = distanceAngle.z - startAngleZ
        if diffAngleZ > 180 {
            diffAngleZ -= 360
        }
        if diffAngleZ < -180 {
            diffAngleZ += 360
        }
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        guard let target else { return }

        target.transform.rotation = quaternionFromEuler(
            angles: SIMD3<Float> (
                startAngleX+diffAngleX * time,
                startAngleY+diffAngleY * time,
                startAngleZ+diffAngleZ * time))
    }
}
