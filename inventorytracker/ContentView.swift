//
//  ContentView.swift
//  inventorytracker
//
//  Created by Alfian Losari on 29/05/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct ContentView: View {
    
    @FirestoreQuery(collectionPath: "inventories",
                    predicates: [.order(by: SortType.createdAt.rawValue, descending: true) ]
    ) private var items: [InventoryItem]
    @StateObject private var vm = InventoryListViewModel()
    
    var body: some View {
        VStack {
            if let error = $items.error {
                Text(error.localizedDescription)
            }
            
            if items.count > 0 {
                List {
                    sortBySectionView
                    listItemsSectionView
                }
                .listStyle(.insetGrouped)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("+") { vm.addItem() }.font(.title)
            }
            
            ToolbarItem(placement: .navigationBarLeading) { EditButton() }
        }
        .onChange(of: vm.selectedSortType) { _ in onSortTypeChanged() }
        .onChange(of: vm.isDescending) { _ in onSortTypeChanged() }
        .navigationTitle("Inventories")
    }
    
    private var listItemsSectionView: some View {
        Section {
            ForEach(items) { item in
                VStack {
                    TextField("Name", text: Binding<String>(
                        get: { item.name },
                        set: { vm.editedName = $0 }),
                              onEditingChanged: { vm.onEditingItemNameChanged(item: item, isEditing: $0)}
                    )
                    .disableAutocorrection(true)
                    .font(.headline)
                    
                    Stepper("Quantity: \(item.quantity)",
                            value: Binding<Int>(
                                get: { item.quantity },
                                set: { vm.updateItem(item, data: ["quantity": $0]) }),
                            in: 0...1000)
                }
            }
            .onDelete { vm.onDelete(items: items, indexset: $0) }
        }
    }
    
    private var sortBySectionView: some View {
        Section {
            DisclosureGroup("Sort by") {
                Picker("Sort by", selection: $vm.selectedSortType) {
                    ForEach(SortType.allCases, id: \.rawValue) { sortType in
                        Text(sortType.text).tag(sortType)
                    }
                }.pickerStyle(.segmented)
                
                Toggle("Is Descending", isOn: $vm.isDescending)
            }
        }
    }
    
    private func onSortTypeChanged() {
        $items.predicates = vm.predicates
    }
      
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
