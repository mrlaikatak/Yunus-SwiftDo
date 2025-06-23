//
//  ContentView.swift
//  SwiftDo
//
//  Created by Yunus ACAR on 23.06.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var showingAddTask = false
    @State private var showingFilterSheet = false
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: Theme.Metrics.padding) {
                        // Header Stats Card
                        VStack(spacing: Theme.Metrics.smallPadding) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Görevlerim")
                                        .font(Theme.Typography.largeTitle)
                                        .foregroundStyle(.primary)
                                    
                                    Text("Bugün \(viewModel.todayTasks.count) görevin var")
                                        .font(Theme.Typography.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("\(viewModel.completionStats.completed)/\(viewModel.completionStats.total)")
                                    .font(Theme.Typography.title2)
                                    .foregroundStyle(.secondary)
                                    .padding(12)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            // Progress Bar
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.secondary.opacity(0.2))
                                        .frame(height: 8)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Theme.primary, Theme.primary.opacity(0.8)]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: geometry.size.width * viewModel.completionPercentage, height: 8)
                                }
                            }
                            .frame(height: 8)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Metrics.cornerRadius)
                                .fill(.ultraThinMaterial)
                        )
                        .padding(.horizontal)
                        
                        // Filter Pills
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Theme.Metrics.smallPadding) {
                                ForEach(TaskViewModel.TaskFilter.allCases, id: \.self) { filter in
                                    FilterPill(filter: filter, selectedFilter: $viewModel.selectedFilter)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Search Field
                        HStack(spacing: Theme.Metrics.smallPadding) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            
                            TextField("Görev ara...", text: $viewModel.searchText)
                                .textFieldStyle(.plain)
                            
                            if !viewModel.searchText.isEmpty {
                                Button {
                                    viewModel.searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Metrics.cornerRadius)
                                .fill(.ultraThinMaterial)
                        )
                        .padding(.horizontal)
                        
                        // Tasks List
                        LazyVStack(spacing: Theme.Metrics.padding) {
                            if viewModel.filteredTasks.isEmpty {
                                EmptyStateView()
                            } else {
                                ForEach(viewModel.filteredTasks) { task in
                                    TaskRowView(task: task) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            viewModel.toggleTask(task)
                                        }
                                    }
                                    .transition(.scale.combined(with: .opacity))
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        if !viewModel.filteredTasks.isEmpty && viewModel.completionStats.completed > 0 {
                            Button(role: .destructive) {
                                withAnimation {
                                    viewModel.deleteCompletedTasks()
                                }
                            } label: {
                                Label("Tamamlananları Temizle", systemImage: "trash")
                                    .font(Theme.Typography.callout)
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(.bordered)
                            .padding(.top)
                        }
                    }
                    .padding(.vertical)
                }
                
                // Floating Action Button
                Button {
                    showingAddTask = true
                } label: {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Theme.primary, Theme.primary.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                        .overlay {
                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .shadow(color: Theme.primary.opacity(0.3),
                               radius: 10, x: 0, y: 5)
                }
                .padding(.bottom, 32)
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(viewModel: viewModel)
        }
    }
}

struct FilterPill: View {
    let filter: TaskViewModel.TaskFilter
    @Binding var selectedFilter: TaskViewModel.TaskFilter
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                selectedFilter = filter
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: filter.icon)
                    .font(.system(size: 14, weight: .semibold))
                Text(filter.rawValue)
                    .font(Theme.Typography.callout)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                Capsule()
                    .fill(selectedFilter == filter ? Theme.primary : .clear)
                    .overlay(
                        Capsule()
                            .strokeBorder(
                                selectedFilter == filter ? Color.clear : .secondary.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            )
            .foregroundStyle(selectedFilter == filter ? .white : .primary)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: Theme.Metrics.padding) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 48))
                .foregroundStyle(Theme.primary)
            
            Text("Henüz görev yok")
                .font(Theme.Typography.title3)
            
            Text("Yeni görev eklemek için + butonuna dokun")
                .font(Theme.Typography.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}

#Preview {
    ContentView()
}
