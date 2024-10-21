import SwiftUI

struct TableSelectionScreen: View {
    @State private var selectedTable = 2 // Default is Table 2
    let allMultiplicationTables = 1...10 // ClosedRange<Int>
    
    // Colorful gradient backgrounds for the buttons
    let gradientColors: [Color] = [.red, .green, .blue, .orange, .purple, .pink, .yellow, .teal, .indigo, .mint]
    
    var body: some View {
        NavigationStack {
            
                
            VStack {
                Text("Pick a multiplication table")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                
                // Colorful grid of buttons to select the table
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                    ForEach(allMultiplicationTables, id: \.self) { table in
                        Button(action: {
                            selectedTable = table
                        }) {
                            Text("\(table)x")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 100, height: 100)
                                .background(LinearGradient(gradient: Gradient(colors: [gradientColors[table - 1], .white]), startPoint: .top, endPoint: .bottom))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(color: .gray, radius: 5, x: 0, y: 5)
                        }
                        .scaleEffect(selectedTable == table ? 1.1 : 1.0) // Slightly enlarge the selected table
                        .animation(.spring(), value: selectedTable) // Add animation when selecting
                    }
                }
                .padding()
                
                // Display the selected table
                Text("Selected Table: \(selectedTable)")
                    .font(.title2)
                    .padding(.top, 20)
                
                // Next button to proceed to the next screen
                NavigationLink(destination: QuestionCountScreen(selectedTable: selectedTable)) {
                    Text("Next")
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
            
        }
    }
}

// Preview for SwiftUI canvas
struct TableSelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        TableSelectionScreen()
    }
}
