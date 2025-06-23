import SwiftUI

struct TaskRowView: View {
    let task: Task
    let onToggle: () -> Void
    
    // Explicitly mark the initializer as internal
    internal init(task: Task, onToggle: @escaping () -> Void) {
        self.task = task
        self.onToggle = onToggle
    }
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Metrics.padding) {
            HStack(spacing: Theme.Metrics.padding) {
                // Checkbox
                Button(action: onToggle) {
                    ZStack {
                        Circle()
                            .strokeBorder(task.isCompleted ? Color.clear : .gray.opacity(0.3), lineWidth: 1.5)
                            .background(
                                Circle()
                                    .fill(task.isCompleted ? Color.green : Color.clear)
                            )
                            .frame(width: Theme.Metrics.iconSize, height: Theme.Metrics.iconSize)
                        
                        if task.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Task Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(Theme.Typography.headline)
                        .strikethrough(task.isCompleted)
                        .foregroundColor(task.isCompleted ? .secondary : .primary)
                    
                    if let notes = task.notes, !notes.isEmpty {
                        Text(notes)
                            .font(Theme.Typography.footnote)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    // Task Metadata
                    HStack(spacing: Theme.Metrics.smallPadding) {
                        if let dueDate = task.dueDate {
                            Label(dateFormatter.string(from: dueDate),
                                  systemImage: "calendar")
                        }
                        
                        Label(task.priority.rawValue,
                              systemImage: task.priority.icon)
                            .foregroundColor(Color(task.priority.color))
                    }
                    .font(Theme.Typography.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding(Theme.Metrics.padding)
        .background(
            RoundedRectangle(cornerRadius: Theme.Metrics.cornerRadius)
                .fill(Theme.taskBackground)
                .shadow(color: Color.black.opacity(0.05),
                       radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Metrics.cornerRadius)
                .strokeBorder(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: Theme.Metrics.cornerRadius))
    }
}

#Preview {
    VStack(spacing: 16) {
        TaskRowView(
            task: Task(
                title: "Premium Tasarım Örneği",
                isCompleted: false,
                dueDate: Date().addingTimeInterval(86400),
                priority: .high,
                notes: "Bu görev kartı modern iOS tasarım diline uygun olarak tasarlanmıştır."
            ),
            onToggle: {}
        )
        
        TaskRowView(
            task: Task(
                title: "Tamamlanmış Görev",
                isCompleted: true,
                dueDate: Date(),
                priority: .medium,
                notes: "Bu bir tamamlanmış görev örneğidir."
            ),
            onToggle: {}
        )
    }
    .padding()
    .background(Theme.background)
} 

