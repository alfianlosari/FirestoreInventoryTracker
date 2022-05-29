//
//  InventoryListViewModel.swift
//  inventorytracker
//
//  Created by Alfian Losari on 29/05/22.
//

import FirebaseFirestore
import SwiftUI
import FirebaseFirestoreSwift

class InventoryListViewModel: ObservableObject {
    
    private let db = Firestore.firestore().collection("inventories")
    
    @Published var selectedSortType = SortType.createdAt
    @Published var isDescending = true
    @Published var editedName = ""
    
    var predicates: [QueryPredicate] { [.order(by: selectedSortType.rawValue, descending: isDescending)] }

    func addItem() {
        let item = InventoryItem(name: "New Item", quantity: 1)
        _ = try? db.addDocument(from: item)
    }
    
    func updateItem(_ item: InventoryItem, data: [String: Any]) {
        guard let id = item.id else { return }
        var _data = data
        _data["updatedAt"] = FieldValue.serverTimestamp()
        db.document(id).updateData(_data)
    }
    
    func onDelete(items: [InventoryItem], indexset: IndexSet) {
        for index in indexset {
            guard let id = items[index].id else { continue }
            db.document(id).delete()
        }
    }
    
    func onEditingItemNameChanged(item: InventoryItem, isEditing: Bool) {
        if !isEditing {
            if item.name != editedName {
                updateItem(item, data: ["name": editedName])
            }
            editedName = ""
        } else {
            editedName = item.name
        }
    }
    
}
