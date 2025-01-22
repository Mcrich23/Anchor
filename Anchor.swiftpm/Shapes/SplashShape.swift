//
//  SplashShape.swift
//  Anchor
//
//  Created by Morris Richman on 1/21/25.
//
//  SVG Inspiration From: https://www.svgheart.com/product/spot-stain-splash-clipart-free-svg-file-image/

import Foundation
import SwiftUI

struct SplashShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        let originalPath = Path { path in
            path.move(to: CGPoint(x: 4374, y: 11719))
            path.addCurve(to: CGPoint(x: 4213, y: 11591),
                          control1: CGPoint(x: 4315, y: 11702),
                          control2: CGPoint(x: 4246, y: 11647))
            path.addCurve(to: CGPoint(x: 4130, y: 11155),
                          control1: CGPoint(x: 4152, y: 11490),
                          control2: CGPoint(x: 4130, y: 11373))
            path.addCurve(to: CGPoint(x: 4300, y: 9945),
                          control1: CGPoint(x: 4130, y: 10901),
                          control2: CGPoint(x: 4173, y: 10597))
            path.addCurve(to: CGPoint(x: 4510, y: 8505),
                          control1: CGPoint(x: 4462, y: 9116),
                          control2: CGPoint(x: 4510, y: 8787))
            path.addCurve(to: CGPoint(x: 4429, y: 8028),
                          control1: CGPoint(x: 4510, y: 8306),
                          control2: CGPoint(x: 4480, y: 8127))
            path.addCurve(to: CGPoint(x: 4249, y: 7856),
                          control1: CGPoint(x: 4395, y: 7961),
                          control2: CGPoint(x: 4316, y: 7886))
            path.addCurve(to: CGPoint(x: 3843, y: 7895),
                          control1: CGPoint(x: 4139, y: 7806),
                          control2: CGPoint(x: 4007, y: 7819))
            path.addCurve(to: CGPoint(x: 2981, y: 8580),
                          control1: CGPoint(x: 3631, y: 7994),
                          control2: CGPoint(x: 3423, y: 8160))
            path.addCurve(to: CGPoint(x: 2129, y: 9289),
                          control1: CGPoint(x: 2474, y: 9062),
                          control2: CGPoint(x: 2311, y: 9198))
            path.addCurve(to: CGPoint(x: 1836, y: 9346),
                          control1: CGPoint(x: 2002, y: 9353),
                          control2: CGPoint(x: 1918, y: 9369))
            path.addCurve(to: CGPoint(x: 1660, y: 9188),
                          control1: CGPoint(x: 1764, y: 9325),
                          control2: CGPoint(x: 1704, y: 9272))
            path.addCurve(to: CGPoint(x: 1992, y: 8507),
                          control1: CGPoint(x: 1554, y: 8990),
                          control2: CGPoint(x: 1660, y: 8773))
            path.addCurve(to: CGPoint(x: 2620, y: 8068),
                          control1: CGPoint(x: 2113, y: 8410),
                          control2: CGPoint(x: 2259, y: 8308))
            path.addCurve(to: CGPoint(x: 3478, y: 7351),
                          control1: CGPoint(x: 3147, y: 7718),
                          control2: CGPoint(x: 3353, y: 7545))
            path.addCurve(to: CGPoint(x: 3292, y: 6688),
                          control1: CGPoint(x: 3646, y: 7089),
                          control2: CGPoint(x: 3570, y: 6818))
            path.addCurve(to: CGPoint(x: 2232, y: 6570),
                          control1: CGPoint(x: 3084, y: 6590),
                          control2: CGPoint(x: 2906, y: 6570))
            path.addCurve(to: CGPoint(x: 1370, y: 6528),
                          control1: CGPoint(x: 1704, y: 6570),
                          control2: CGPoint(x: 1523, y: 6561))
            path.addCurve(to: CGPoint(x: 1010, y: 6184),
                          control1: CGPoint(x: 1128, y: 6476),
                          control2: CGPoint(x: 1010, y: 6364))
            path.addCurve(to: CGPoint(x: 1363, y: 5740),
                          control1: CGPoint(x: 1010, y: 5996),
                          control2: CGPoint(x: 1127, y: 5849))
            path.addCurve(to: CGPoint(x: 2420, y: 5495),
                          control1: CGPoint(x: 1569, y: 5646),
                          control2: CGPoint(x: 1795, y: 5594))
            path.addCurve(to: CGPoint(x: 3353, y: 5303),
                          control1: CGPoint(x: 2948, y: 5412),
                          control2: CGPoint(x: 3136, y: 5373))
            path.addCurve(to: CGPoint(x: 3852, y: 5005),
                          control1: CGPoint(x: 3593, y: 5226),
                          control2: CGPoint(x: 3750, y: 5132))
            path.addCurve(to: CGPoint(x: 3770, y: 4457),
                          control1: CGPoint(x: 3991, y: 4834),
                          control2: CGPoint(x: 3965, y: 4661))
            path.addCurve(to: CGPoint(x: 2676, y: 3718),
                          control1: CGPoint(x: 3579, y: 4256),
                          control2: CGPoint(x: 3392, y: 4129))
            path.addCurve(to: CGPoint(x: 1803, y: 3140),
                          control1: CGPoint(x: 2139, y: 3409),
                          control2: CGPoint(x: 1953, y: 3286))
            path.addCurve(to: CGPoint(x: 1664, y: 2765),
                          control1: CGPoint(x: 1649, y: 2990),
                          control2: CGPoint(x: 1609, y: 2882))
            path.addCurve(to: CGPoint(x: 2069, y: 2581),
                          control1: CGPoint(x: 1726, y: 2631),
                          control2: CGPoint(x: 1891, y: 2556))
            path.addCurve(to: CGPoint(x: 3334, y: 3284),
                          control1: CGPoint(x: 2343, y: 2619),
                          control2: CGPoint(x: 2628, y: 2778))
            path.addCurve(to: CGPoint(x: 4435, y: 3969),
                          control1: CGPoint(x: 3957, y: 3731),
                          control2: CGPoint(x: 4180, y: 3870))
            path.addCurve(to: CGPoint(x: 5015, y: 3938),
                          control1: CGPoint(x: 4691, y: 4069),
                          control2: CGPoint(x: 4883, y: 4059))
            path.addCurve(to: CGPoint(x: 5180, y: 3439),
                          control1: CGPoint(x: 5136, y: 3828),
                          control2: CGPoint(x: 5180, y: 3693))
            path.addCurve(to: CGPoint(x: 5000, y: 2416),
                          control1: CGPoint(x: 5180, y: 3192),
                          control2: CGPoint(x: 5144, y: 2985))
            path.addCurve(to: CGPoint(x: 4876, y: 1905),
                          control1: CGPoint(x: 4952, y: 2223),
                          control2: CGPoint(x: 4896, y: 1993))
            path.addCurve(to: CGPoint(x: 4957, y: 1099),
                          control1: CGPoint(x: 4770, y: 1428),
                          control2: CGPoint(x: 4795, y: 1178))
            path.addCurve(to: CGPoint(x: 5105, y: 1075),
                          control1: CGPoint(x: 4998, y: 1079),
                          control2: CGPoint(x: 5020, y: 1075))
            path.addCurve(to: CGPoint(x: 5275, y: 1109),
                          control1: CGPoint(x: 5199, y: 1075),
                          control2: CGPoint(x: 5210, y: 1077))
            path.addCurve(to: CGPoint(x: 5639, y: 1539),
                          control1: CGPoint(x: 5400, y: 1171),
                          control2: CGPoint(x: 5534, y: 1329))
            path.addCurve(to: CGPoint(x: 5985, y: 2425),
                          control1: CGPoint(x: 5735, y: 1728),
                          control2: CGPoint(x: 5813, y: 1930))
            path.addCurve(to: CGPoint(x: 6540, y: 3584),
                          control1: CGPoint(x: 6213, y: 3082),
                          control2: CGPoint(x: 6362, y: 3393))
            path.addCurve(to: CGPoint(x: 7077, y: 3762),
                          control1: CGPoint(x: 6697, y: 3751),
                          control2: CGPoint(x: 6879, y: 3812))
            path.addCurve(to: CGPoint(x: 8188, y: 2959),
                          control1: CGPoint(x: 7368, y: 3688),
                          control2: CGPoint(x: 7618, y: 3507))
            path.addCurve(to: CGPoint(x: 9072, y: 2180),
                          control1: CGPoint(x: 8710, y: 2457),
                          control2: CGPoint(x: 8877, y: 2309))
            path.addCurve(to: CGPoint(x: 9721, y: 2072),
                          control1: CGPoint(x: 9346, y: 1998),
                          control2: CGPoint(x: 9560, y: 1962))
            path.addCurve(to: CGPoint(x: 9754, y: 2629),
                          control1: CGPoint(x: 9866, y: 2171),
                          control2: CGPoint(x: 9876, y: 2345))
            path.addCurve(to: CGPoint(x: 9142, y: 3624),
                          control1: CGPoint(x: 9666, y: 2834),
                          control2: CGPoint(x: 9533, y: 3051))
            path.addCurve(to: CGPoint(x: 8605, y: 4485),
                          control1: CGPoint(x: 8841, y: 4064),
                          control2: CGPoint(x: 8706, y: 4281))
            path.addCurve(to: CGPoint(x: 8464, y: 4860),
                          control1: CGPoint(x: 8513, y: 4672),
                          control2: CGPoint(x: 8490, y: 4734))
            path.addCurve(to: CGPoint(x: 9029, y: 5268),
                          control1: CGPoint(x: 8392, y: 5216),
                          control2: CGPoint(x: 8649, y: 5402))
            path.addCurve(to: CGPoint(x: 10013, y: 4661),
                          control1: CGPoint(x: 9241, y: 5193),
                          control2: CGPoint(x: 9412, y: 5088))
            path.addCurve(to: CGPoint(x: 10879, y: 4260),
                          control1: CGPoint(x: 10490, y: 4323),
                          control2: CGPoint(x: 10723, y: 4215))
            path.addCurve(to: CGPoint(x: 11054, y: 4459),
                          control1: CGPoint(x: 10960, y: 4283),
                          control2: CGPoint(x: 11024, y: 4355))
            path.addCurve(to: CGPoint(x: 11052, y: 4648),
                          control1: CGPoint(x: 11075, y: 4530),
                          control2: CGPoint(x: 11074, y: 4575))
            path.addCurve(to: CGPoint(x: 10640, y: 5085),
                          control1: CGPoint(x: 11009, y: 4785),
                          control2: CGPoint(x: 10874, y: 4929))
            path.addCurve(to: CGPoint(x: 9735, y: 5572),
                          control1: CGPoint(x: 10461, y: 5205),
                          control2: CGPoint(x: 10331, y: 5275))
            path.addCurve(to: CGPoint(x: 8906, y: 6007),
                          control1: CGPoint(x: 9182, y: 5849),
                          control2: CGPoint(x: 9064, y: 5911))
            path.addCurve(to: CGPoint(x: 8403, y: 6427),
                          control1: CGPoint(x: 8677, y: 6146),
                          control2: CGPoint(x: 8495, y: 6299))
            path.addCurve(to: CGPoint(x: 8488, y: 7000),
                          control1: CGPoint(x: 8255, y: 6635),
                          control2: CGPoint(x: 8286, y: 6848))
            path.addCurve(to: CGPoint(x: 9660, y: 7400),
                          control1: CGPoint(x: 8688, y: 7150),
                          control2: CGPoint(x: 8991, y: 7253))
            path.addCurve(to: CGPoint(x: 10367, y: 7561),
                          control1: CGPoint(x: 10162, y: 7510),
                          control2: CGPoint(x: 10220, y: 7523))
            path.addCurve(to: CGPoint(x: 11049, y: 7886),
                          control1: CGPoint(x: 10735, y: 7656),
                          control2: CGPoint(x: 10970, y: 7768))
            path.addCurve(to: CGPoint(x: 11051, y: 8155),
                          control1: CGPoint(x: 11103, y: 7968),
                          control2: CGPoint(x: 11103, y: 8048))
            path.addCurve(to: CGPoint(x: 10315, y: 8426),
                          control1: CGPoint(x: 10955, y: 8350),
                          control2: CGPoint(x: 10705, y: 8443))
            path.addCurve(to: CGPoint(x: 9585, y: 8345),
                          control1: CGPoint(x: 10134, y: 8419),
                          control2: CGPoint(x: 9993, y: 8403))
            path.addCurve(to: CGPoint(x: 8605, y: 8253),
                          control1: CGPoint(x: 8996, y: 8261),
                          control2: CGPoint(x: 8822, y: 8245))
            path.addCurve(to: CGPoint(x: 7910, y: 8649),
                          control1: CGPoint(x: 8201, y: 8269),
                          control2: CGPoint(x: 7968, y: 8402))
            path.addCurve(to: CGPoint(x: 7930, y: 8975),
                          control1: CGPoint(x: 7893, y: 8721),
                          control2: CGPoint(x: 7902, y: 8874))
            path.addCurve(to: CGPoint(x: 8440, y: 9965),
                          control1: CGPoint(x: 7992, y: 9203),
                          control2: CGPoint(x: 8103, y: 9419))
            path.addCurve(to: CGPoint(x: 8926, y: 10899),
                          control1: CGPoint(x: 8775, y: 10508),
                          control2: CGPoint(x: 8873, y: 10695))
            path.addCurve(to: CGPoint(x: 8763, y: 11362),
                          control1: CGPoint(x: 8985, y: 11127),
                          control2: CGPoint(x: 8932, y: 11279))
            path.addCurve(to: CGPoint(x: 8516, y: 11367),
                          control1: CGPoint(x: 8677, y: 11404),
                          control2: CGPoint(x: 8601, y: 11406))
            path.addCurve(to: CGPoint(x: 8232, y: 11080),
                          control1: CGPoint(x: 8439, y: 11331),
                          control2: CGPoint(x: 8315, y: 11206))
            path.addCurve(to: CGPoint(x: 7865, y: 10361),
                          control1: CGPoint(x: 8157, y: 10965),
                          control2: CGPoint(x: 8010, y: 10678))
            path.addCurve(to: CGPoint(x: 7415, y: 9485),
                          control1: CGPoint(x: 7635, y: 9858),
                          control2: CGPoint(x: 7542, y: 9676))
            path.addCurve(to: CGPoint(x: 7035, y: 9102),
                          control1: CGPoint(x: 7283, y: 9286),
                          control2: CGPoint(x: 7167, y: 9170))
            path.addCurve(to: CGPoint(x: 6133, y: 9567),
                          control1: CGPoint(x: 6759, y: 8962),
                          control2: CGPoint(x: 6473, y: 9109))
            path.addCurve(to: CGPoint(x: 5547, y: 10512),
                          control1: CGPoint(x: 5992, y: 9756),
                          control2: CGPoint(x: 5867, y: 9957))
            path.addCurve(to: CGPoint(x: 4842, y: 11541),
                          control1: CGPoint(x: 5183, y: 11141),
                          control2: CGPoint(x: 5032, y: 11361))
            path.addCurve(to: CGPoint(x: 4470, y: 11729),
                          control1: CGPoint(x: 4701, y: 11674),
                          control2: CGPoint(x: 4591, y: 11730))
            path.addCurve(to: CGPoint(x: 4374, y: 11719),
                          control1: CGPoint(x: 4434, y: 11728),
                          control2: CGPoint(x: 4391, y: 11724))
            path.closeSubpath()
          }
        
        // Calculate the bounding box of the original path
        let boundingBox = originalPath.boundingRect
        
        // Calculate the scaling factor to fit the path into the given rect
        let scaleX = rect.width / boundingBox.width
        let scaleY = rect.height / boundingBox.height
        let scale = min(scaleX, scaleY)
        
        // Calculate the translation to center the path
        let translationX = rect.midX - (boundingBox.midX * scale)
        let translationY = rect.midY - (boundingBox.midY * scale)
        
        // Apply the scale and translation to the path
        let transform = CGAffineTransform(translationX: translationX, y: translationY)
            .scaledBy(x: scale, y: scale)
        
        return originalPath.applying(transform)
    }
}

#Preview {
    SplashShape()
}
