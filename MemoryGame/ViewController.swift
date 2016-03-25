//
//  ViewController.swift
//  MemoryGame
//
//  Created by Hen Goldburd on 04/03/2016.
//  Copyright © 2016 Hen Goldburd. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collection: UICollectionView!
    
    var level = 4
    var game : MemoryGame!
    var activePath : NSIndexPath?
    var activeCell : Cell?
    var activeCounter = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = MemoryGame(numOfCards: level)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return level
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return level
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellID", forIndexPath: indexPath) as! Cell
        cell.setValue(game.getCardValue(indexPath.row, y: indexPath.section))
        self.activeCounter=0
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Column \(indexPath.row) Row \(indexPath.section)")
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? Cell
        flipCardUp(indexPath,cell: cell!)
        
    }
    
    func flipCardUp(path : NSIndexPath,cell : Cell)
    {
        if(game.getCard(path.row, y: path.section).solved || (activeCounter != 0 && self.activeCell == nil) || activeCounter >= 2 || cell == activeCell)
        {
            return
        }
        cell.flipUp();
        activeCounter+=1
      
        if(self.activeCell == nil)
        {
            activeCell = cell
            activePath = path
            
        }
        else
        {
            if(game.doesCarsMatch(activePath!.row, y1: activePath!.section, x2: path.row, y2: path.section))
            {
                activeCell!.solved()
                cell.solved()
            }
        }
        flipDownAsync(path,cell: cell)
        if(game.endGame)
        {
            resetGame()
        }
    }
    
    func flipDownAsync(path : NSIndexPath,cell : Cell)
    {
        if(self.game.getCard(path.row, y: path.section).solved)
        {
            releaseActive()
            return
        }
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            if(self.game.getCard(path.row, y: path.section).solved)
            {
                self.releaseActive()
                return
            }
            sleep(4)
            dispatch_async(dispatch_get_main_queue(), {
                
            cell.flipDown();
            self.releaseActive()
                
        }); });
    }
    
    private func releaseActive()
    {
        self.activeCell=nil
        self.activePath=nil
        self.activeCounter-=1
    }
    
    func resetGame()
    {
        let alertController = UIAlertController(title: "Game Over", message: "Reseting Game", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
    
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            sleep(4)
            dispatch_async(dispatch_get_main_queue(), {
                
                self.game.initCards(self.level)
                self.releaseActive()
                
                self.collection.reloadData()
                
            }); });
        
        
        sleep(4)
        
        
        
    }

}

