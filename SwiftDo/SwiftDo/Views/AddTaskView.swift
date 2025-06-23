import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TaskViewModel
    
    @State private var title = ""
    @State private var priority = Task.Priority.medium
    @State private var dueDate: Date = Date().addingTimeInterval(86400)
    @State private var notes = ""
    @State private var includeDueDate = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Metrics.padding) {
                    // Title Input
                    VStack(alignment: .leading, spacing: Theme.Metrics.smallPadding) {
                        Text("Görev Başlığı")
                            .font(Theme.Typography.headline)
                            .foregroundColor(.secondary)
                        
                        TextField("Yeni görev...", text: $title)
                            .font(Theme.Typography.body)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(Theme.Metrics.cornerRadius)
                    }
                    .padding(.top)
                    
                    // Priority Selection
                    VStack(alignment: .leading, spacing: Theme.Metrics.smallPadding) {
                        Text("Öncelik")
                            .font(Theme.Typography.headline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: Theme.Metrics.padding) {
                            ForEach(Task.Priority.allCases, id: \.self) { priorityOption in
                                PriorityButton(
                                    priority: priorityOption,
                                    isSelected: priority == priorityOption,
                                    action: { priority = priorityOption }
                                )
                            }
                        }
                    }
                    
                    // Due Date
                    VStack(alignment: .leading, spacing: Theme.Metrics.smallPadding) {
                        Toggle(isOn: $includeDueDate) {
                            Text("Son Tarih")
                                .font(Theme.Typography.headline)
                                .foregroundColor(.secondary)
                        }
                        
                        if includeDueDate {
                            DatePicker("",
                                     selection: $dueDate,
                                     in: Date()...,
                                     displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.graphical)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(Theme.Metrics.cornerRadius)
                        }
                    }
                    
                    // Notes
                    VStack(alignment: .leading, spacing: Theme.Metrics.smallPadding) {
                        Text("Notlar")
                            .font(Theme.Typography.headline)
                            .foregroundColor(.secondary)
                        
                        TextEditor(text: $notes)
                            .frame(minHeight: 100)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(Theme.Metrics.cornerRadius)
                    }
                }
                .padding()
            }
            .navigationTitle("Yeni Görev")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        addTask()
                    } label: {
                        Text("Ekle")
                            .bold()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func addTask() {
        viewModel.addTask(
            title: title,
            dueDate: includeDueDate ? dueDate : nil,
            priority: priority,
            notes: notes.isEmpty ? nil : notes
        )
        dismiss()
    }
}

struct PriorityButton: View {
    let priority: Task.Priority
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: priority.icon)
                    .font(.system(size: 24))
                Text(priority.rawValue)
                    .font(Theme.Typography.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color(priority.color) : Color.secondary.opacity(0.1))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(Theme.Metrics.cornerRadius)
            .animation(.spring(response: 0.2), value: isSelected)
        }
    }
}

#Preview {
    AddTaskView(viewModel: TaskViewModel())
} 