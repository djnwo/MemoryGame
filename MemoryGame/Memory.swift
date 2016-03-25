//
//  Memory.swift
//  MemoryGame
//
//  Created by Hen Goldburd on 18/03/2016.
//  Copyright © 2016 Hen Goldburd. All rights reserved.
//

import Foundation

class MemoryGame
{
    var cards = [[Card]]()
    var values =  [String]()
    var solveNum = 0
    var endGame = false
    var totalCards = 0
    
    func getCardValue(x : Int,y : Int) -> String
    {
        return cards[x][y].value
    }
    
    init(numOfCards : Int)
    {
        self.initCards(numOfCards)
    }
    
    func initCards(numOfCards : Int)
    {
        
        cards = [[Card]]()
        values =  [String]()
        solveNum = 0
        endGame = false
        totalCards = numOfCards * numOfCards
        
        let start = 0x1F601
        let end = 0x1F601+(numOfCards*numOfCards)/2 - 1
        
        for i in start...end {
            values.append( String(UnicodeScalar(i)))
            values.append( String(UnicodeScalar(i)))
        }

        
        for _ in 1...numOfCards {
            var row = [Card]()
            for _ in 1...numOfCards {
                let diceRoll = Int(arc4random_uniform(UInt32(values.count)))
                row.append(Card(value: values[diceRoll]))
                values.removeAtIndex(diceRoll)
            }
            cards.append(row)
        }
    }
    
    func getCard(x : Int,y : Int) -> Card
    {
        return cards[x][y]
    }
    
    func doesCarsMatch(x1 : Int , y1 : Int, x2: Int, y2: Int) -> Bool
    {
        let card1 = getCard(x1, y: y1)
        let card2 = getCard(x2, y: y2)
        
        if(card1 == card2 && !card1.solved && !card2.solved)
        {
            card1.solved = true
            card2.solved = true
            solveNum+=1
            if(solveNum >= totalCards/2)
            {
                endGame = true
            }
            return true;
        }
        else
        {
            return false;
        }
    }
}

class Card
{
    var value: String = ""
    var solved: Bool = false
    
    init (value: String)
    {
        self.value = value;
    }

}

func ==(left: Card, right: Card) -> Bool
{
    return (left.value == right.value)
}

func !=(left: Card, right: Card) -> Bool
{
    return !(left == right)
}


