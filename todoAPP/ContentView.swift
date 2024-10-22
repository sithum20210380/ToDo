//
//  ContentView.swift
//  todoAPP
//
//  Created by Sithum Raveesha on 2024-10-04.
//

import SwiftUI
 
struct TaskItem: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var description: String
    var isComplete: Bool
}

class ViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    
    func updateTask(task: TaskItem) {
        let index = tasks.firstIndex(where: {
            $0.id == task.id
        })
        guard let unwrappedIndex = index else { return }
        tasks[unwrappedIndex].isComplete.toggle()
    }
}

struct ContentView: View {
    @StateObject var viewModel: ViewModel = ViewModel()
    @State var isAddOpen: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.tasks) { task in
                    HStack {
                        Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                viewModel.updateTask(task: task)
                            }
                        
                        VStack(alignment: .leading) {
                            Text(task.title)
                                .font(.headline)
                            Text(task.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationTitle("My Tasks")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("", systemImage: "plus") {
                            isAddOpen.toggle()
                        }
                    }
                }
                .sheet(isPresented: $isAddOpen) {
                    AddNewTask(isAddOpen: $isAddOpen, addTask: { title, description in
                        let newTask = TaskItem(title: title, description: description, isComplete: false)
                        viewModel.tasks.append(newTask)
                    })
                }
            }
        }
    }
}

struct AddNewTask: View {
    @State var title: String = ""
    @State var description: String = ""
    @Binding var isAddOpen: Bool
    var addTask: (String, String) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Task Title", text: $title)
                TextField("Task Description", text: $description)
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        addTask(title, description)
                        isAddOpen = false
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
