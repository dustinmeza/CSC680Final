import SwiftUI

/**This SwiftUI code defines a ContentView for managing tasks, allowing users to add new tasks with due dates, filter them based on specific criteria (All, Today, Tomorrow, Next 7 Days), and mark tasks as completed. Tasks can be viewed in a scrollable list, with options to delete them or navigate to a subtask view. Additionally, there's a TaskArchiveContentView that displays a list of archived (completed) tasks, accessible via a navigation link in the toolbar.**/

    /**To complete the code on this page, i mainly followed your lecture recordings on youtube, they helped me format the layout as well as add functionality to the page**/


struct ContentView: View {
    @State private var tasks: [Task] = [
        Task(title: "Task 1", dueDate: Date().addingTimeInterval(86400)), // 1 day later
        Task(title: "Task 2", dueDate: Date().addingTimeInterval(172800)), // 2 days later
        Task(title: "Task 3", dueDate: Date().addingTimeInterval(604800)) // 7 days later
    ]
    @State private var newTaskText = ""
    @State private var newTaskDueDate = Date()
    @State private var selectedFilterIndex = 0
    let filterOptions = ["All", "Today", "Tomorrow", "Next 7 Days"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Task Organizer!")
                        .font(.title)
                        .padding()
                    
                    HStack {
                        TextField("New Task", text: $newTaskText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    
                    DatePicker("Due Date", selection: $newTaskDueDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding()
                    
                    Button(action: addNewTask) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Task")
                        }
                    }
                    .padding()
                    .buttonStyle(BorderlessButtonStyle())
                    
                    HStack {
                        Picker(selection: $selectedFilterIndex, label: Text("Filter")) {
                            ForEach(0..<filterOptions.count, id: \.self) { index in
                                Text(self.filterOptions[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    }
                    
                    VStack(alignment: .leading) {
                        ForEach(filteredTasks(), id: \.id) { task in
                            HStack {
                                VStack(alignment: .leading) {
                                    NavigationLink(destination: SubtaskContentView(task: task.title)) {
                                        Text(task.title)
                                    }
                                    if let dueDate = task.dueDate {
                                        Text("Due: \(formattedDate(dueDate))")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                                Button(action: {
                                    markTaskCompleted(task: task)
                                }) {
                                    Image(systemName: "checkmark.circle")
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteTask)
                    }
                    .padding()
                }
                .navigationTitle("Task Organizer")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink(destination: TaskArchiveContentView(tasks: tasks)) {
                            Label("Archive", systemImage: "archivebox")
                        }
                    }
                }
            }
        }
    }
    
    private func addNewTask() {
        if !newTaskText.isEmpty {
            tasks.append(Task(title: newTaskText, dueDate: newTaskDueDate))
            newTaskText = ""
            newTaskDueDate = Date() // Reset to today's date
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    private func markTaskCompleted(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].completed = true
        }
    }
    
    private func filteredTasks() -> [Task] {
        let now = Date()
        switch selectedFilterIndex {
        case 1: // Today
            return tasks.filter { Calendar.current.isDateInToday($0.dueDate ?? now) && !$0.completed }
        case 2: // Tomorrow
            return tasks.filter { Calendar.current.isDateInTomorrow($0.dueDate ?? now) && !$0.completed }
        case 3: // Next 7 Days
            let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: now) ?? now
            return tasks.filter { ($0.dueDate ?? now) <= nextWeek && !$0.completed }
        default: // All
            return tasks.filter { !$0.completed }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct TaskArchiveContentView: View {
    let tasks: [Task]
    
    var body: some View {
        VStack {
            Text("Archived Tasks")
                .font(.title)
                .padding()
            
            List {
                ForEach(tasks.filter { $0.completed }, id: \.id) { task in
                    Text(task.title)
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Task Archive")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
