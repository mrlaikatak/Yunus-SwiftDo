import Foundation
import SwiftUI
import Combine

@MainActor
class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var selectedFilter: TaskFilter = .all
    @Published var searchText = ""
    
    private let tasksKey = "tasks"
    
    enum TaskFilter: String, CaseIterable {
        case all = "Tümü"
        case active = "Aktif"
        case completed = "Tamamlanan"
        
        var icon: String {
            switch self {
            case .all: return "list.bullet"
            case .active: return "clock"
            case .completed: return "checkmark"
            }
        }
    }
    
    var filteredTasks: [Task] {
        let filtered = tasks.filter { task in
            switch selectedFilter {
            case .all: return true
            case .active: return !task.isCompleted
            case .completed: return task.isCompleted
            }
        }
        
        if searchText.isEmpty {
            return filtered.sorted { $0.createdAt > $1.createdAt }
        }
        
        return filtered
            .filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    var completionStats: (completed: Int, total: Int) {
        let completed = tasks.filter { $0.isCompleted }.count
        return (completed, tasks.count)
    }
    
    var completionPercentage: Double {
        guard completionStats.total > 0 else { return 0 }
        return Double(completionStats.completed) / Double(completionStats.total)
    }
    
    var todayTasks: [Task] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return tasks.filter { task in
            if let dueDate = task.dueDate {
                return calendar.isDate(calendar.startOfDay(for: dueDate), inSameDayAs: today)
            }
            return true  // Include tasks with no due date
        }
    }
    
    init() {
        loadTasks()
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let savedTasks = try? JSONDecoder().decode([Task].self, from: data) {
            self.tasks = savedTasks
        }
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }
    
    func addTask(title: String, dueDate: Date? = nil, priority: Task.Priority = .medium, notes: String? = nil) {
        let task = Task(title: title, dueDate: dueDate, priority: priority, notes: notes)
        tasks.append(task)
        saveTasks()
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
        }
    }
    
    func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            var updatedTask = task
            updatedTask.toggleCompletion()
            tasks[index] = updatedTask
            saveTasks()
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func deleteCompletedTasks() {
        tasks.removeAll { $0.isCompleted }
        saveTasks()
    }
    
    func moveTask(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
        saveTasks()
    }
} 