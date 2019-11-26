//
//  ViewController.swift
//  Match
//
//  Created by Samarth Goel on 11/13/19.
//  Copyright © 2019 Samarth Goel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timeLeft: UILabel!
    
    var model = CardModel()
    var cardArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float = 60 * 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SoundManager.playSound(.shuffle)
        
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timeElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc func timeElapsed(){
        milliseconds -= 1
        let seconds = String(format: "%.2f", milliseconds/1000)
        timeLeft.text = "Time Remaining: \(seconds)"
        
        if milliseconds == 0{
            timer?.invalidate()
            timeLeft.textColor = UIColor.red
            checkForCompletion()
        }
    }
    
    //MARK: - UICollectionView Protocol Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        cell.setCard(cardArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if milliseconds == 0{
            return
        }
        else{
            let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
            let card = cardArray[indexPath.row]
            
            if !card.flipped && !card.matched{
                cell.flip()
                card.flipped = true
                SoundManager.playSound(.flip)
                if firstFlippedCardIndex == nil{
                    firstFlippedCardIndex = indexPath
                }
                else{
                    matchCheck(indexPath)
                }
            }
        }
    }
    
    func matchCheck(_ secondCardIndex:IndexPath){
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondCardIndex) as? CardCollectionViewCell
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondCardIndex.row]
        
        if cardOne.imageName == cardTwo.imageName{
            //its a match
            
            //update status of cards
            cardOne.matched = true
            cardTwo.matched = true
            
            //remove cards from cell
            cardOneCell?.remove()
            cardTwoCell?.remove()
            SoundManager.playSound(.match)
            checkForCompletion()
        }
        else{
            //no match
            
            //set status
            cardOne.flipped = false
            cardTwo.flipped = false
            
            //return cards to original state
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            SoundManager.playSound(.wrong)
        }
        if cardOneCell == nil{
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        firstFlippedCardIndex = nil
    }
    
    func checkForCompletion(){
        //Determine if there are any cards unmatched
        var isWon = true
        
        for card in cardArray{
            if !card.matched{
                isWon = false
                break
            }
        }
        
        var title = ""
        var message = ""
        
        if isWon{
            if milliseconds > 0{
                timer?.invalidate()
            }
            title = "Congrats!"
            message = "You've won!"
        }
        else{
            if milliseconds > 0{
                return
            }
            title = "Game over"
            message = "You've lost"
        }
        showAlert(title, message)
    }
    
    func showAlert(_ title:String, _ message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}

