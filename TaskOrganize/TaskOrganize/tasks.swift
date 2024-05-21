import Foundation

struct Task: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var completed: Bool = false
    var dueDate: Date?
}
