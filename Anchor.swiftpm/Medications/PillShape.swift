//
//  PillShape.swift
//  Anchor
//
//  Created by Morris Richman on 2/3/25.
//

import Foundation
import SwiftUI

struct DosageMedicationIcon: View {
    
    static let viewBox = CGRect(x: 0.0, y: 0.0, width: 80, height: 80)
    
    struct PathShape1: Shape {
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: 57.07, y: 38.92))
                path.addLine(to: CGPoint(x: 57.07, y: 19.32))
                path.addCurve(to: CGPoint(x: 39.57, y: 1.92),
                              control1: CGPoint(x: 57.07, y: 8.92),
                              control2: CGPoint(x: 50.07, y: 1.92))
                path.addCurve(to: CGPoint(x: 22.07, y: 19.32),
                              control1: CGPoint(x: 29.07, y: 1.92),
                              control2: CGPoint(x: 22.07, y: 8.92))
                path.addLine(to: CGPoint(x: 22.17, y: 38.92))
                path.move(to: CGPoint(x: 29.17, y: 38.92))
                path.addLine(to: CGPoint(x: 29.17, y: 19.92))
                path.addCurve(to: CGPoint(x: 39.57, y: 9.02),
                              control1: CGPoint(x: 29.17, y: 13.42),
                              control2: CGPoint(x: 33.37, y: 9.02))
                path.addCurve(to: CGPoint(x: 49.97, y: 19.92),
                              control1: CGPoint(x: 45.77, y: 9.02),
                              control2: CGPoint(x: 49.97, y: 13.42))
                path.addLine(to: CGPoint(x: 49.97, y: 38.92))
            }
        }
    }
    struct PathShape2: Shape {
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.addLines([
                    CGPoint(x: 57.07, y: 38.92),
                    CGPoint(x: 22.17, y: 38.92),
                    CGPoint(x: 22.17, y: 60.22)
                ])
                path.addCurve(to: CGPoint(x: 39.57, y: 77.12),
                              control1: CGPoint(x: 22.17, y: 70.52),
                              control2: CGPoint(x: 29.87, y: 77.12))
                path.addCurve(to: CGPoint(x: 57.07, y: 60.12),
                              control1: CGPoint(x: 49.27, y: 77.12),
                              control2: CGPoint(x: 57.07, y: 70.32))
                path.addLine(to: CGPoint(x: 57.07, y: 38.92))
                path.closeSubpath()
            }
        }
    }
    
    struct PathShape3: Shape {
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: 49.47, y: 38.12))
                path.addCurve(to: CGPoint(x: 44.57, y: 33.92),
                              control1: CGPoint(x: 49.07, y: 35.72),
                              control2: CGPoint(x: 47.07, y: 33.92))
                path.addCurve(to: CGPoint(x: 39.67, y: 38.12),
                              control1: CGPoint(x: 42.07, y: 33.92),
                              control2: CGPoint(x: 39.97, y: 35.72))
                path.addLine(to: CGPoint(x: 49.57, y: 38.12))
                path.addLine(to: CGPoint(x: 49.47, y: 38.12))
                path.closeSubpath()
            }
        }
    }
    
    struct PathShape4: Shape {
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: 49.47, y: 39.62))
                path.addLine(to: CGPoint(x: 39.57, y: 39.62))
                path.addCurve(to: CGPoint(x: 44.47, y: 43.82),
                              control1: CGPoint(x: 39.97, y: 42.02),
                              control2: CGPoint(x: 41.97, y: 43.82))
                path.addCurve(to: CGPoint(x: 49.37, y: 39.62),
                              control1: CGPoint(x: 46.97, y: 43.82),
                              control2: CGPoint(x: 49.07, y: 42.02))
                path.addLine(to: CGPoint(x: 49.47, y: 39.62))
                path.closeSubpath()
            }
        }
    }
    
    struct PathShape5: Shape {
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: 41.37, y: 28.12))
                path.addCurve(to: CGPoint(x: 36.47, y: 23.92),
                              control1: CGPoint(x: 40.97, y: 25.72),
                              control2: CGPoint(x: 38.97, y: 23.92))
                path.addCurve(to: CGPoint(x: 31.57, y: 28.12),
                              control1: CGPoint(x: 33.97, y: 23.92),
                              control2: CGPoint(x: 31.87, y: 25.72))
                path.addLine(to: CGPoint(x: 41.47, y: 28.12))
                path.addLine(to: CGPoint(x: 41.37, y: 28.12))
                path.closeSubpath()
            }
        }
    }
    
    struct PathShape6: Shape {
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: 41.37, y: 29.72))
                path.addLine(to: CGPoint(x: 31.47, y: 29.72))
                path.addCurve(to: CGPoint(x: 36.37, y: 33.92),
                              control1: CGPoint(x: 31.87, y: 32.12),
                              control2: CGPoint(x: 33.87, y: 33.92))
                path.addCurve(to: CGPoint(x: 41.27, y: 29.72),
                              control1: CGPoint(x: 38.87, y: 33.92),
                              control2: CGPoint(x: 40.97, y: 32.12))
                path.addLine(to: CGPoint(x: 41.37, y: 29.72))
                path.closeSubpath()
            }
        }
    }
    
    struct PathShape7: Shape {
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: 48.07, y: 16.92))
                path.addCurve(to: CGPoint(x: 43.17, y: 12.72),
                              control1: CGPoint(x: 47.67, y: 14.52),
                              control2: CGPoint(x: 45.67, y: 12.72))
                path.addCurve(to: CGPoint(x: 38.27, y: 16.92),
                              control1: CGPoint(x: 40.67, y: 12.72),
                              control2: CGPoint(x: 38.57, y: 14.52))
                path.addLine(to: CGPoint(x: 48.17, y: 16.92))
                path.addLine(to: CGPoint(x: 48.07, y: 16.92))
                path.closeSubpath()
            }
        }
    }
    
    struct PathShape8: Shape {
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: 48.07, y: 18.52))
                path.addLine(to: CGPoint(x: 38.17, y: 18.52))
                path.addCurve(to: CGPoint(x: 43.07, y: 22.72),
                              control1: CGPoint(x: 38.57, y: 20.92),
                              control2: CGPoint(x: 40.57, y: 22.72))
                path.addCurve(to: CGPoint(x: 47.97, y: 18.52),
                              control1: CGPoint(x: 45.57, y: 22.72),
                              control2: CGPoint(x: 47.67, y: 20.92))
                path.addLine(to: CGPoint(x: 48.07, y: 18.52))
                path.closeSubpath()
            }
        }
    }
    
    func scaleEffect(for size: CGSize) -> CGSize {
        let value = (size.width / Self.viewBox.width)
        
        return CGSize(width: value, height: value)
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                PathShape1() // Top Capsule Half
                    .fill(.green)
                PathShape2() // Bottom Capsule Half
                    .fill(.blue)
                
                // Pills
                PathShape3()
                //        PathShape4()
                PathShape5()
                PathShape6()
                PathShape7()
                PathShape8()
            }
            .frame(width: Self.viewBox.width, height: Self.viewBox.height,
                   alignment: .topLeading)
            .scaleEffect(scaleEffect(for: proxy.size))
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

#Preview {
    DosageMedicationIcon()
}

#Preview {
    @Previewable @State var medication = Medication(name: "", dosage: "", notes: "")
    
    NavigationStack {
        CreateMedicationView(medication: medication)
    }
}
