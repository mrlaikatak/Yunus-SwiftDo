import Foundation

internal struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var priority: Priority
    var notes: String?
    var createdAt: Date
    var completedAt: Date?
    
    enum Priority: String, Codable, CaseIterable {
        case low = "Düşük"
        case medium = "Orta"
        case high = "Yüksek"
        
        var color: String {
            switch self {
            case .low: return "PriorityLow"
            case .medium: return "PriorityMedium"
            case .high: return "PriorityHigh"
            }
        }
        
        var icon: String {
            switch self {
            case .low: return "arrow.down.circle.fill"
            case .medium: return "equal.circle.fill"
            case .high: return "exclamationmark.circle.fill"
            }
        }
    }
    
    internal init(id: UUID = UUID(), 
         title: String, 
         isCompleted: Bool = false,
         dueDate: Date? = nil,
         priority: Priority = .medium,
         notes: String? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.priority = priority
        self.notes = notes
        self.createdAt = Date()
        self.completedAt = nil
    }
    
    mutating func toggleCompletion() {
        isCompleted.toggle()
        completedAt = isCompleted ? Date() : nil
    }
} 
