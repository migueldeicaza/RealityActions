//
//  QuatMath.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

func quaternionFromEuler (angles: SIMD3<Float>) -> simd_quatf {
    let deg2radians2: Float = .pi / 360
    let rangles = angles * deg2radians2
    let s = sin (rangles)
    let c = cos (rangles)
    
    return simd_quatf (vector: [
        c.y * s.x * c.z + s.y * c.x * s.z,
        s.y * c.x * c.z - c.y * s.x * s.z,
        c.y * c.x * s.z - s.y * s.x * c.z,
        c.y * c.x * c.z + s.y * s.x * s.z
    ])
}

func toEulerAngles (_ quat: simd_quatf) -> SIMD3<Float> {
    // Derivation from http://www.geometrictools.com/Documentation/EulerAngles.pdf
    // Order of rotations: Z first, then X, then Y
    let qv = quat.vector

    let check: Float = 2.0*(-qv.y*qv.z + qv.w*qv.x);
    
    let radToDeg: Float = 180.0 / .pi

    if check < -0.995 {
        return SIMD3<Float> (-90, 0,
                              -atan2f(2.0 * (qv.x * qv.z - qv.w * qv.y), 1.0 - 2.0 * (qv.y * qv.y + qv.z * qv.z)) * radToDeg)
    } else if check > 0.995 {
        return SIMD3<Float> (-90, 0,
                              atan2f(2.0 * (qv.x * qv.z - qv.w * qv.y), 1.0 - 2.0 * (qv.y * qv.y + qv.z * qv.z)) * radToDeg)
    } else {
        return SIMD3<Float> (
            asinf (check) * radToDeg,
            atan2f(2.0 * (qv.x * qv.z + qv.w * qv.y), 1.0 - 2.0 * (qv.x * qv.x + qv.y * qv.y)) * radToDeg,
            atan2f(2.0 * (qv.x * qv.y + qv.w * qv.z), 1.0 - 2.0 * (qv.x * qv.x + qv.z * qv.z)) * radToDeg)
    }

}

