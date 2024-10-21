import SwiftUI

struct QuestionCountScreen: View {
    var selectedTable: Int
    let variantsOfQuestions = ["5", "10", "20", "All"] // Options for number of questions
    @State private var countOfQuestions = "5"
    @State private var showGameScreen = false
    
    // Colorful gradient backgrounds for the question buttons
    let gradientColors: [Color] = [.red, .green, .blue, .orange]

    var body: some View {
        NavigationStack {
            VStack {
                // Label
                Text("How many questions do you want to be asked?")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                // Colorful grid of buttons for selecting question count
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                    ForEach(variantsOfQuestions, id: \.self) { variant in
                        Button(action: {
                            countOfQuestions = variant // Select the number of questions
                        }) {
                            Text(variant)
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 120, height: 120)
                                .background(LinearGradient(gradient: Gradient(colors: [gradientColors[variantsOfQuestions.firstIndex(of: variant)!], .white]), startPoint: .top, endPoint: .bottom))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(color: .gray, radius: 5, x: 0, y: 5)
                        }
                        .scaleEffect(countOfQuestions == variant ? 1.1 : 1.0) // Slightly enlarge the selected option
                        .animation(.spring(), value: countOfQuestions) // Animation for the selection
                    }
                }
                .padding()
                
                // Display selected number of questions
                Text("Selected: \(countOfQuestions) questions")
                    .font(.title2)
                    .padding(.top, 20)

                // Button to start the game
                Button(action: {
                    showGameScreen = true // Set to true to show the game screen
                }) {
                    Text("Start Game")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                }
                .padding(.top, 30)
            }
            .padding(.horizontal, 20)
            .background(Color.white.edgesIgnoringSafeArea(.all)) // Bright background for a fun feel
            .fullScreenCover(isPresented: $showGameScreen) {
                GameScreen(selectedTable: selectedTable, countOfQuestions: countOfQuestions)
            }
            .navigationTitle("Question Count")
        }
    }
}

// Preview for SwiftUI Canvas
struct QuestionCountScreen_Previews: PreviewProvider {
    static var previews: some View {
        QuestionCountScreen(selectedTable: 1)
    }
}
