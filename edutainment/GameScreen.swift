import SwiftUI
import ConfettiSwiftUI

struct GameScreen: View {
    var selectedTable: Int // Pass selected table
    var countOfQuestions: String // Pass selected number of questions
 
    @State private var imagesName = ["parrot", "duck", "dog", "horse", "rabbit", "whale", "rhino", "elephant", "zebra", "chicken", "cow", "panda", "hippo", "gorilla", "owl", "penguin", "sloth", "frog", "narwhal", "buffalo", "monkey", "giraffe", "moose", "pig", "snake", "bear", "chick", "walrus", "goat", "crocodile"]
    @State private var gameIsRunning = false
    @State private var arrayOfQuestions = [Question]()
    @State private var GameEnded = false
    @State private var currentQuestion = 0
    @State private var totalScore = 0
    @State private var remainingQuestions = 0
    @State private var selectedNumber = 0
    @State private var isCorrect = false
    @State private var isWrong = false
    @State private var isShowAlert = false
    @State private var alertTitle = ""
    @State private var buttonAlertTitle = ""
    @State private var isWinGame = false
    @State private var answerArray = [Question]()
    @State private var confettiCounter = 0 // For confetti effect

    var body: some View {
        Group {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.indigo, .white, .purple]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                if gameIsRunning {
                    VStack {
                        Text("\(arrayOfQuestions[currentQuestion].text)")
                            .drawGameLabel()
                            .font(.largeTitle)
                            .foregroundColor(.blue)

                        VStack {
                            ForEach(0 ..< 4, id: \.self) { number in
                                HStack {
                                    Button(action: {
                                        withAnimation {
                                            self.checkAnswer(number)
                                        }
                                    }) {
                                        AnswersImage(image: self.imagesName[number])
                                            .padding()
                                        Text("\(self.answerArray[number].answer)")
                                            .foregroundColor(Color.primary)
                                            .font(.title)
                                    }
                                    .drawAnswerButton()
                                    .rotation3DEffect(.degrees(self.isCorrect && self.selectedNumber == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                    .rotation3DEffect(.degrees(self.isWrong && self.selectedNumber == number ? 180 : 0), axis: (x: 0, y: 0, z: 0.5))
                                }
                            }
                        }
                        
                        Button(action: {
                            self.gameIsRunning = false
                            self.GameEnded = true
                            
                            confettiCounter += 1 // Trigger confetti when game ends
                        }) {
                            Text("End Game")
                                .drawStartAndEndButton(whatColor: gameIsRunning)
                        }

                        VStack {
                            DrawHorizontalText(text: "Total score: ", textResult: "\(totalScore)")
                            DrawHorizontalText(text: "Questions remained: ", textResult: "\(remainingQuestions)")
                        }

                        Spacer()

                        // Confetti effect
                            .confettiCannon(counter: $confettiCounter, colors: [.red, .blue,.white,.black,.pink], confettiSize: 90)
                    }
                    .fullScreenCover(isPresented: $GameEnded) {
                      
                    }
                } else {
                    TableSelectionScreen()
                }
            }
        }
        .alert(isPresented: $isShowAlert) { () -> Alert in
            Alert(title: Text("\(alertTitle)"), message: Text(" Your score is: \(totalScore)"), dismissButton: .default(Text("\(buttonAlertTitle)")) {
                if self.isWinGame {
                    self.newGame()
                    self.isWinGame = false
                    self.isCorrect = false
                } else if self.isCorrect  {
                    self.isCorrect = false
                    self.newQuestion()
                } else {
                    self.isWrong = false
                }
            })
        }
        .onAppear {
            self.newGame() // Start the game when this screen appears
        }
    }

    // Update the method to generate questions based on selected table and count
    func createArrayOfQuestions() {
        let totalQuestions: Int
        if let numberOfQuestions = Int(countOfQuestions) {
            totalQuestions = numberOfQuestions
        } else {
            totalQuestions = 20 // Default if "All" is selected
        }
        
        // Generate questions based on selected table
        for i in 1 ... selectedTable {
            for j in 1...10 {
                let newQuestion = Question(text: "How much is: \(i) x \(j)?", answer: i * j)
                arrayOfQuestions.append(newQuestion)
            }
        }
        
        // Shuffle and limit questions
        self.arrayOfQuestions.shuffle()
        self.arrayOfQuestions = Array(self.arrayOfQuestions.prefix(totalQuestions))
        self.currentQuestion = 0
        self.answerArray = []
    }
    
    func setCountOfQuestions() {
        remainingQuestions = arrayOfQuestions.count
    }

    func createAnswersArray() {
        if currentQuestion + 4 < arrayOfQuestions.count {
            for i in currentQuestion ... currentQuestion + 3 {
                answerArray.append(arrayOfQuestions[i])
            }
        } else {
            for i in arrayOfQuestions.count - 4 ..< arrayOfQuestions.count {
                answerArray.append(arrayOfQuestions[i])
            }
        }
        self.answerArray.shuffle()
    }
    
    func newGame() {
        self.gameIsRunning = true
        self.arrayOfQuestions = []
        self.createArrayOfQuestions()
        self.setCountOfQuestions()
        self.answerArray = []
        self.createAnswersArray()
        self.imagesName.shuffle()
        self.totalScore = 0
    }
    
    func newQuestion() {
        self.imagesName.shuffle()
        self.currentQuestion += 1
        self.answerArray = []
        self.createAnswersArray()
    }
    
    func checkAnswer(_ number: Int) {
        self.selectedNumber = number
        if answerArray[number].answer == arrayOfQuestions[currentQuestion].answer {
            self.isCorrect = true
            self.remainingQuestions -= 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if self.remainingQuestions == 0 {
                    self.alertTitle = "You win!"
                    self.buttonAlertTitle = "Start new game"
                    self.totalScore += 1
                    self.isWinGame = true
                    self.isShowAlert = true
                    
                    confettiCounter += 1 // Trigger confetti on win
                    
                } else {
                    self.totalScore += 1
                    self.alertTitle = "Correct!"
                    self.buttonAlertTitle = "New Question"
                    self.isShowAlert = true
                }
            }
        } else {
            isWrong = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.alertTitle = "Wrong!"
                self.buttonAlertTitle = "Try again"
                self.isShowAlert = true
            }
        }
    }
}

// Supporting Question struct
struct Question {
    var text: String
    var answer: Int
}

// Supporting Answer Image View
struct AnswersImage: View {
    var image: String
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .scaleEffect(0.5)
            .frame(width: 80, height: 80)
    }
}

// Answer Button Modifier
struct AnswerButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 300, height: 100, alignment: .center)
            .background(Color.gray)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
    }
}

extension View {
    func drawAnswerButton() -> some View {
        self.modifier(AnswerButton())
    }
}

// Game Label Modifier
struct GameLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.indigo, lineWidth: 2))
            .padding(.bottom, 10)
            .padding(.top, 50)
    }
}

extension View {
    func drawGameLabel() -> some View {
        self.modifier(GameLabel())
    }
}

// Start and End Button Modifier
struct StartToEndButton: ViewModifier {
    var whatColor: Bool
    func body(content: Content) -> some View {
        content
            .padding()
            .background(whatColor ? Color.purple : Color.green)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 2))
            .font(.title)
            .padding(.top, 10)
            .foregroundColor(.primary)
    }
}

extension View {
    func drawStartAndEndButton(whatColor: Bool) -> some View {
        self.modifier(StartToEndButton(whatColor: whatColor))
    }
}

// Horizontal Text Component
struct DrawHorizontalText: View {
    var text: String
    var textResult: String
    var body: some View {
        HStack {
            Text(text)
                .font(Font.system(size: 22, weight: .heavy))
                .foregroundColor(Color.primary)
            Text(textResult)
                .font(Font.system(size: 22, weight: .heavy))
                .foregroundColor(Color.primary)
        }
        .padding(.top, 10)
    }
}

// Preview for SwiftUI Canvas
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameScreen(selectedTable: 5, countOfQuestions: "10")
    }
}

