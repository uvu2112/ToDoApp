//
//  Controller.swift
//  Todo
//
//  Created by Alec Saunders on 8/19/17.
//  Copyright © 2017 Alec Saunders. All rights reserved.
//

import Foundation
import Cocoa
import CoreData

protocol MainControllerDelegate {
//    func assigneToDoToGroup(moID: NSManagedObjectID, group: Group)
}

class MainController: NSObject, NSFetchedResultsControllerDelegate, InfoControllerDelegate, TableViewMenuDelegate, MainControllerDelegate, FBControllerDelegate {
    
    var firebaseController: FirebaseController!
    weak var mainTableViewDelgate: MainTableViewDelgate?
    var categoryDelegate: CategoryDelegate?
    
    override init() {
        firebaseController = FirebaseController()
        super.init()
        firebaseController.fbControlDel = self
        firebaseController?.loadDataFromFirebase()
    }
    
    func reloadUI() {
        mainTableViewDelgate?.reloadData()
    }

    
    func getToDo(moID: NSManagedObjectID?) -> ToDo? {
//        guard let managedObjectID = moID else { return nil }
//        guard let theToDo = dataController.managedObjectContext.object(with: managedObjectID) as? ToDo else { return nil }
        let theToDo = ToDo(id: "id", title: "title", note: "", daily: false, createdDate: Date(), completedDate: nil)
        return theToDo
    }

    func save(addedToDoTitle: String, newToDoSidebarSelection: SidebarItem?) {
        if addedToDoTitle.isEmpty {
            print("do not add a new to do item")
        } else {
            let newKey = firebaseController.getNewKey()
            let newToDo = ToDo(id: newKey, title: addedToDoTitle, note: "", daily: false, createdDate: Date(), completedDate: nil)
            firebaseController.saveToDoToFirebase(toDo: newToDo)
//            if let sbCat = (newToDoSidebarSelection as? SidebarCategoryItem)?.sbCategory {
//                theToDo.group = sbCat
//            }
//            mainTableViewDelgate?.reloadData()
        }
    }

    func markCompleted(atIndex index: Int, complete: Bool) {
        var completedToDo = firebaseController.fetchedToDos[index]
        if complete {
            completedToDo.completedDate = Date()
        } else {
            completedToDo.completedDate = nil
        }
        firebaseController.update(toDo: completedToDo, property: "completedDate", with: completedToDo.completedDate)
    }
    
    func removeToDoEntityRecord(atIndex: Int) {
        print("removing to do record")
//        guard let fetchedObjs = toDoFetchedResultsController.fetchedObjects else { return }
//        guard let object = fetchedObjs[atIndex] as? NSManagedObject else { return }
//        dataController.managedObjectContext.delete(object)
//        dataController.saveMoc()
//        mainTableViewDelgate?.reloadData()
    }
    
    func updateNote(newNote: String, moID: NSManagedObjectID?) {
//        guard let theToDo = getToDo(moID: moID) else { return }
//        theToDo.note = newNote
//        dataController.saveMoc()
    }
    
    
    // MARK: - Update View
    func completedWasChecked(state: Int, btnIndex index: Int) {
        switch state {
        case 1:
            markCompleted(atIndex: index, complete: true)
        case 0:
            markCompleted(atIndex: index, complete: false)
        default:
            break
        }
    }
    
//    func assigneToDoToGroup(moID: NSManagedObjectID, group: Group) {
//        guard let theToDo = getToDo(moID: moID) else { return }
//        theToDo.group = group
//        dataController.saveMoc()
//    }
    
    func setToDaily(moID: NSManagedObjectID, isDaily: Bool) {
        if let toDo = getToDo(moID: moID) {
//            toDo.daily = isDaily
//            dataController.saveMoc()
            mainTableViewDelgate?.reloadData()
        }
    }
    
    //MARK: - Table View Menu Delegate Functions
    func setMenuDailyState(sender: NSMenuItem) {
        guard let mTvDel = mainTableViewDelgate else { return }
        guard let clickedToDo = mTvDel.clickedToDo else { return }
        
        if clickedToDo.daily {
            sender.state = .on
        } else {
            sender.state = .off
        }
    }

}
