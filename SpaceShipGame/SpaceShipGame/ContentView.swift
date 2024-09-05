import SwiftUI


struct ContentView: View {
    @State var angle: Double = 0 // Starting angle (in radians)
    @State private var isDragging = false
    @State private var lastDragPosition: CGPoint?
    
    // Adjustable parameters
    let rotationSpeed: Double = 0.0055 // Adjust this to change rotation speed
    let easeOutDuration: Double = 0.5 // Duration of easing out when touch ends

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background and circle
                Circle()
                    .stroke(Color.gray, lineWidth: 10)
                    .frame(width: min(geometry.size.width, geometry.size.height) * 0.9)

                SpaceshipView(angle: angle, geometry: geometry)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDragging = true
                        let screenWidth = geometry.size.width
                        let touchX = value.location.x
                        
                        if touchX > screenWidth * 0.55 {
                            // Right side - move counterclockwise
                            withAnimation(.linear(duration: 0.1)) {
                                angle -= rotationSpeed
                            }
                        } else if touchX < screenWidth * 0.45 {
                            // Left side - move clockwise
                            withAnimation(.linear(duration: 0.1)) {
                                angle += rotationSpeed
                            }
                        }
                        // If touch is in the middle (between 45% and 55% of screen width), do nothing
                    }
                    .onEnded { _ in
                        isDragging = false
                        
                        // Ease out the movement
                        withAnimation(.easeOut(duration: easeOutDuration)) {
                            // This will cause the spaceship to slow down gradually
                            angle += 0 // We're not actually changing the angle, just triggering an animation
                        }
                    }
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
}


struct SpaceshipView: View {
    let angle: Double
    let geometry: GeometryProxy

    var body: some View {
        Image("spaceship")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            .position(x: spaceshipX, y: spaceshipY)
            .rotationEffect(.radians(rotationAngle))
    }

    private var circleRadius: CGFloat {
        return min(geometry.size.width, geometry.size.height) * 0.45 - 5
    }

    private var spaceshipX: CGFloat {
        return geometry.size.width / 2 + cos(angle) * circleRadius
    }

    private var spaceshipY: CGFloat {
        return geometry.size.height / 2 + sin(angle) * circleRadius
    }

    private var rotationAngle: Double {
        return angle + .pi / 2
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
