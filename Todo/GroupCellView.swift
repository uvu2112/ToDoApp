//
//  GroupCellView.swift
//  Todo
//
//  Created by Alec Saunders on 8/31/17.
//  Copyright © 2017 Alec Saunders. All rights reserved.
//

import Cocoa

protocol GroupCellViewDelegate: class {
    func changeSidebarTitle(newTitle title: String, forGroupID id: String)
}

class GroupCellView: NSTableCellView {
    weak var groupCellViewDelegate: GroupCellViewDelegate?
    @IBOutlet var sidebarGroupTitle: NSTextField!
    @IBAction func sidebarGroupTitle(_ sender: NSTextField) {
        guard let id = groupID else { return }
        groupCellViewDelegate?.changeSidebarTitle(newTitle: sidebarGroupTitle.stringValue, forGroupID: id)
    }
    var groupID: String?
    @IBOutlet var txtGroup: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func setFocus() {
        sidebarGroupTitle.becomeFirstResponder()
    }
}
