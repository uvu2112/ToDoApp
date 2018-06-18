//
//  FirebaseController.swift
//  Todo
//
//  Created by Alec Saunders on 6/16/18.
//  Copyright © 2018 Alec Saunders. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

protocol FBControllerDelegate {
    var dataArray: [ToDo]? { get set }
    func reloadUI()
}

class FirebaseController {
    var fbControlDel: FBControllerDelegate?
    var ref: DatabaseReference!
    var fbItem: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
        fbItem = ref.child("item")
    }
    
    func loadDataFromFirebase() {
        fbItem.observeSingleEvent(of: .value, with: { (snapshot) in
            var newDataArray: [ToDo] = []
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                do {
                    guard let fbChildToDoDict = child.value as? [String: Any] else { return }
                    let toDoData = try JSONSerialization.data(withJSONObject: fbChildToDoDict, options: [])
                    let decodedToDo = try JSONDecoder().decode(ToDo.self, from: toDoData)
                    newDataArray.append(decodedToDo)
                } catch {
                    print("error decoding \(error)")
                }
            }
            if self.fbControlDel != nil {
                self.fbControlDel?.dataArray = newDataArray
                self.fbControlDel?.reloadUI()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func saveToDoToFirebase(toDo: ToDo) {
        fbItem.child(toDo.id).setValue(toDo.getDictionary())
    }
    
    func getNewKey() -> String {
        return ref.child("item").childByAutoId().key
    }
    
    func delete(item: ToDo) {
        fbItem.child(item.id).removeValue(completionBlock: { (error, ref) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Deleted item")
            }
        })
    }
    
    func markDaily(forToDo toDo: ToDo) {
        fbItem.child(toDo.id).child("daily").setValue(toDo.daily.hashValue.description)
    }
    
    func update(toDo: ToDo, property prop: String, with newVal: Any?) {
        if let newValUnwrapped = newVal {
            switch prop {
            case "id", "title", "note":
                let newValTyped = newValUnwrapped as! String
                fbItem.child(toDo.id).child(prop).setValue(newValTyped)
            case "daily":
                let newValTyped = newValUnwrapped as! Bool
                fbItem.child(toDo.id).child(prop).setValue(newValTyped)
            case "createdDate", "completedDate":
                let newValTyped = (newValUnwrapped as! Date).timeIntervalSince1970
                fbItem.child(toDo.id).child(prop).setValue(newValTyped)
            default:
                print("nothing to do")
            }
            
        }
    }
}
