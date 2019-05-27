//
//  DropDownManager.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import UIKit
import DropDown

class DropDownManager: NSObject {
    
    static let shared: DropDownManager = {
        let instance = DropDownManager.init()
        instance.commonInit()
        return instance
    }()
    
    var dropDown = DropDown.init()
    
    fileprivate var tuple: (arrayIndexes: [Int], arrayItems: [String]) = ([],[])
    
    fileprivate func commonInit() {
        
        // Basic setup
        let appearance = DropDown.appearance()
        appearance.cellHeight = 40
        appearance.backgroundColor = UIColor.lightGray
        appearance.textColor = UIColor.black
        
        self.dropDown.cellNib = UINib(nibName: String(describing: SimpleDropDownCellView.self), bundle: nil)
        self.dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? SimpleDropDownCellView else { return }
            
            // Setup your custom UI components
            cell.optionLabel.text = item
        }
        
        self.dropDown.dismissMode = .onTap
        self.dropDown.direction = .bottom
        
    }
    
}

extension DropDownManager {
    
    func addDropDown(onButton button: UIButton, dataSource: [String], isMultiSelect: Bool = false, preselectedIndexes: [Int] = [0], selectionCompletion: ((Int, String)->())? = nil, multiSelectionCompletion: (([Int], [String])->())? = nil) {
        
        self.dropDown.anchorView = button
        self.dropDown.bottomOffset = CGPoint(x: 0, y: button.bounds.height)
        
        self.dropDown.dataSource = dataSource
        
        if isMultiSelect == true {
            self.dropDown.selectionAction = nil
            self.dropDown.selectRows(at: Set.init(preselectedIndexes))
            self.dropDown.multiSelectionAction = { (arrayIndex, arrayItem) in
                self.tuple = (arrayIndexes: arrayIndex, arrayItems: arrayItem)
            }
            self.dropDown.cancelAction = {
                multiSelectionCompletion?(self.tuple.arrayIndexes, self.tuple.arrayItems)
            }
        } else {
            self.dropDown.multiSelectionAction = nil
            self.dropDown.cancelAction = nil
            self.dropDown.selectRow(at: preselectedIndexes.first ?? 0)
            selectionCompletion?(preselectedIndexes.first ?? 0, dataSource.first ?? "")
            self.dropDown.selectionAction = { (index, item) in
                selectionCompletion?(index, item)
            }
        }
        
    }
    
    func showDropDown() {
        self.dropDown.show()
    }
    
}
