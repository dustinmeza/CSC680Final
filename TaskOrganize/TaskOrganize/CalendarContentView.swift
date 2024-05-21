import SwiftUI
/**This SwiftUI code defines a CalendarContentView that displays a calendar for May 2024, allowing users to view and select dates. When a date is selected, the view shows associated events and tasks. The code includes functionality to determine the number of days in the month, the starting weekday, and highlights dates with tasks.**/

/**for this view, i used https://michaelabadi.com/articles/create-calendar-view-swiftui/ as a guide for getting my calendar view**/

struct CalendarContentView: View {
    @State private var events: [Date: [String]] = [
        Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 18))!: ["Meeting at 10 AM", "Lunch with Sarah"]
    ]
    
    @State private var tasks: [Task] = [
        Task(title: "Task 1", dueDate: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 18))),
        Task(title: "Task 2", dueDate: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 19))),
        Task(title: "Task 3", dueDate: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 20)))
    ]
    
    @State private var selectedDate: Date? = nil
    
    var body: some View {
        ScrollView {
        VStack {
            Text("Calendar View")
                .font(.title)
                .padding()
            
            //calculat the number of days in the current month and the first weekday
                let daysInMonth = getDaysInMonth()
                let firstWeekdayOfMonth = getFirstWeekdayOfMonth()
                
                VStack {
                    ForEach(0..<6) { row in
                        HStack {
                            ForEach(0..<7) { column in
                                let day = getDayForCell(row: row, column: column, firstWeekday: firstWeekdayOfMonth, daysInMonth: daysInMonth)
                                let date = day != nil ? Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: day!)) : nil
                                
                                Button(action: {
                                    if let day = day {
                                        selectedDate = Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: day))
                                    }
                                }) { // Display calendar grid
                                    VStack {
                                        Text(day.map { "\($0)" } ?? "")
                                        if date != nil && hasTask(for: date!) {
                                            Circle()
                                                .fill(Color.green)
                                                .frame(width: 6, height: 6)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(day != nil && selectedDate != nil && Calendar.current.isDate(selectedDate!, equalTo: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: day!))!, toGranularity: .day) ? Color.blue.opacity(0.2) : Color.clear)
                                }
                                .padding(5)
                                .border(Color.gray, width: 1)
                            }
                        }
                    }
                }
                .padding()
            }
            // Check if ther are any tasks for a given date
            if let selectedDate = selectedDate {
                let formattedDateStr = formattedDate(selectedDate)
                if let eventsForSelectedDate = events[selectedDate] {
                    VStack {
                        Text("Events for \(formattedDateStr)")
                            .font(.headline)
                            .padding()
                        
                        ForEach(eventsForSelectedDate, id: \.self) { event in
                            Text(event)
                        }
                    }
                }
                if let tasksForSelectedDate = tasksForDate(selectedDate) {
                    VStack {
                        Text("Tasks for \(formattedDateStr)")
                            .font(.headline)
                            .padding()
                        
                        ForEach(tasksForSelectedDate, id: \.id) { task in
                            Text(task.title)
                        }
                    }
                }
            }
            
            Spacer()
        }
    }

    private func getDaysInMonth() -> Int {
        let dateComponents = DateComponents(year: 2024, month: 5)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    private func getFirstWeekdayOfMonth() -> Int {
        let dateComponents = DateComponents(year: 2024, month: 5)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        return calendar.component(.weekday, from: date) - 1
    }
    
    private func getDayForCell(row: Int, column: Int, firstWeekday: Int, daysInMonth: Int) -> Int? {
        let day = row * 7 + column - firstWeekday + 1
        return (day > 0 && day <= daysInMonth) ? day : nil
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func hasTask(for date: Date) -> Bool {//check if there are any tasks for a given date
        return tasks.contains { task in
            if let dueDate = task.dueDate {
                return Calendar.current.isDate(dueDate, inSameDayAs: date)
            }
            return false
        }
    }
    
    private func tasksForDate(_ date: Date) -> [task]? {//Get tasks for a specific date
        let filteredTasks = tasks.filter { task in
            if let dueDate = task.dueDate {
                return Calendar.current.isDate(dueDate, inSameDayAs: date)
            }
            return false
        }
        return filteredTasks.isEmpty ? nil : (filteredTasks as! [task] )
    }
}

struct task: Identifiable {
    let id = UUID()
    var title: String
    var dueDate: Date?
}

struct CalendarContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContentView()
    }
}
