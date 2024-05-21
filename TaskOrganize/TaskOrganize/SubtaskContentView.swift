import SwiftUI
struct SubtaskContentView: View {
    
    let task: String // The main task for which subtasks will be added
    
    @State private var subtasks: [String] = []//variable to store list subtasks
    
    @State private var newSubtaskText: String = "" //stores individual subtasks
    @Environment(\.presentationMode) var presentationMode//exit the view
    
    var body: some View {
        VStack {
            Text("Subtasks for \(task)")
                .font(.title)
                .padding()
            
            HStack {//add new subtasks here
                TextField("New Subtask", text: $newSubtaskText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    addNewSubtask()
                }) {
                    Image(systemName: "plus")
                        .padding()
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            
            List { //display the newly added tasks
                ForEach(subtasks, id: \.self) { subtask in
                    Text(subtask)
                }
                .onDelete(perform: deleteSubtask)
            }
            .padding()
            
            Spacer()
            
            Button(action: { //return to previous view
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(5)
            }
            .padding()
        }
        .navigationTitle("Subtasks")
        .navigationBarBackButtonHidden(true)
    }
    
    private func addNewSubtask() { //method for adding a new subtask to the list 
        if !newSubtaskText.isEmpty {
            subtasks.append(newSubtaskText)
            newSubtaskText = ""
        }
    }
    
    private func deleteSubtask(at offsets: IndexSet) {
        subtasks.remove(atOffsets: offsets)
    }
}

