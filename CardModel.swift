//
//  CardModel.swift
//  Match
//
//  Created by Samarth Goel on 11/13/19.
//  Copyright © 2019 Samarth Goel. All rights reserved.
//

import Foundation

class CardModel{
    func getCards() -> [Card]{
        //declare array
        var cardArray = [Card]()
        var arr = [Int](1...13)
        
        //randomly generate pairs of cards
        for _ in 1...8{
            let randomNum = arr.randomElement()!
            let indexOfNum = arr.firstIndex(of: randomNum)!
            arr.remove(at: indexOfNum)

            //generate Card 1
            let cardOne = Card()
            cardOne.imageName = "card\(randomNum)"
            
            //generate Card 2
            let cardTwo = Card()
            cardTwo.imageName = "card\(randomNum)"
            
            //add cards to array
            cardArray.append(cardOne)
            cardArray.append(cardTwo)
        }
        //Randomize Cards
        for _ in 1...100{
            let num1 = Int.random(in: 0...cardArray.count - 1)
            let num2 = Int.random(in: 0...cardArray.count - 1)
            let temp = cardArray[num1]
            cardArray[num1] = cardArray[num2]
            cardArray[num2] = temp
        }
        
        //return array
        return cardArray
    }
}
