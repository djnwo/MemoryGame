//
//  Cell.swift
//  MemoryGame
//
//  Created by Hen Goldburd on 04/03/2016.
//  Copyright © 2016 Hen Goldburd. All rights reserved.
//

import Foundation
import UIKit


class Cell: UICollectionViewCell  {
    
    @IBOutlet weak var lbl: UILabel!
    var isSolved = false
    
    
    func setValue(value: String)
    {
        lbl.text = value
        lbl.hidden = true
        isSolved = false
    }
    
    func flipUp()
    {
        lbl.hidden = false
       
    }
    
    func flipDown()
    {
        
        if (isSolved)
        {
            solved()
            return
        }
        lbl.hidden = true
    }
    
    func solved()
    {
        lbl.hidden = false
        lbl.text = "Solved!"
        isSolved = true
    }

}
