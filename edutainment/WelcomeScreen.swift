import SwiftUI
import ConfettiSwiftUI

struct WelcomeScreen: View {
    @State private var counter = 0 // To control the confetti
    @State private var isGameStarted = false // To track whether the game has started
    @State private var showNumbers = false // To animate numbers
    @State private var rotationEffect = false // To rotate the title

    var body: some View {
        ZStack {
            // Fun colorful gradient background
            LinearGradient(gradient: Gradient(colors: [.purple, .pink, .yellow]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Confetti trigger on the top
                ConfettiCannon(counter: $counter, num: 100, colors: [.red, .green, .blue, .yellow, .purple], confettiSize: 20)
                
                // Title with gradient text and rotation animation
                Text("Welcome to the Game!")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.pink, .orange]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                            .shadow(color: .gray, radius: 10)
                    )
                    .padding(.top, 50)
                    .rotationEffect(.degrees(rotationEffect ? 5 : -5)) // Add slight rotation for fun effect
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: rotationEffect)

                // Fun animated numbers instead of balloons
                if showNumbers {
                    NumbersView() // Show animated numbers
                        .transition(.scale(scale: 1.1, anchor: .top))
                }

                Spacer()
                
                // "Start Game" button with fun styling
                NavigationLink(destination: TableSelectionScreen(), isActive: $isGameStarted) {
                    Button(action: {
                        // Trigger confetti and start game
                        counter += 1
                        isGameStarted = true
                    }) {
                        Text("Start Game")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(25)
                            .shadow(color: .blue.opacity(0.6), radius: 10, x: 0, y: 5)
                    }
                }
                .padding(.bottom, 50)
                .scaleEffect(showNumbers ? 1.2 : 1.0) // Scale animation for the button
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: showNumbers) // Bounce effect

                Spacer()
            }
            .onAppear {
                withAnimation(.easeIn(duration: 2)) {
                    showNumbers = true // Trigger number animation on appear
                }
                rotationEffect = true // Start rotation effect
            }
        }
    }
}

// Numbers animation view (replaces balloons with floating numbers)
struct NumbersView: View {
    @State private var numberOffset = CGSize.zero
    let numbers = Array(1...10) // Numbers 1 to 10 for animation
    let colors: [Color] = [.red, .green, .blue, .orange, .purple, .yellow]

    var body: some View {
        ZStack {
            // Multiple numbers flying up
            ForEach(0..<numbers.count, id: \.self) { i in
                Text("\(numbers[i])")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(colors.randomElement()!) // Random color for each number
                    .offset(x: CGFloat.random(in: -150...150), y: CGFloat.random(in: 500...700))
                    .animation(
                        Animation.easeInOut(duration: 3).repeatForever(autoreverses: false).delay(Double(i) * 0.3),
                        value: numberOffset
                    )
                    .rotationEffect(.degrees(Double.random(in: -30...30))) // Random rotation for numbers
            }
        }
        .onAppear {
            withAnimation {
                numberOffset = CGSize(width: 0, height: -1000) // Move numbers upwards
            }
        }
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}
