//
//  MainVC.swift
//  MealsApp
//
//  Created by FareedQ on 2016-01-21.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit
import AudioToolbox

class WeeklyDinnersVC: UIViewController {
    
    //IBOUtlets
    @IBOutlet weak var plannedMealsCV: UICollectionView!
    @IBOutlet weak var mealChoicesCV: UICollectionView!
    
    //Struct Data Models
    let food = Food()
    let daysOfTheWeek = DaysOfTheWeek()
    
    //Selection Array
    var weeklyMealSelection = [Int]()
    
    //Required Variables to create selection animation
    var imageSize = CGSize()
    var selectedImage = UIImageView()
    var selectedImageHorizontalConstraint = NSLayoutConstraint()
    var selectedImageVerticalConstraint = NSLayoutConstraint()
    var mealSelected = NSIndexPath()
    var mealToBeReplaced = NSIndexPath()
    var possibleMealToBeReplacedCell = preparedMealsCell()
    var highlightedCellBackground = UIColor.grayColor()
    var defaultCellBackground = UIColor.whiteColor()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecongizers()
        loadWeeksRandomSelection()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setTheDefaultImageSizeForAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("did recieve a memory warning error in the weekly dinners vc", "")
    }
    
    @IBAction func radomMealsButton(sender: AnyObject) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        loadWeeksRandomSelection()
        plannedMealsCV.reloadData()
    }
    
    //note - the preloaded first element and the while loop is to ensure the same meals doesn't happen two days in a row
    func loadWeeksRandomSelection(){
        weeklyMealSelection = [Int]()
        var randomSelection = Int(arc4random_uniform(UInt32(food.meals.count)))
        weeklyMealSelection.append(randomSelection)
        for index in 1...daysOfTheWeek.names.count {
            while randomSelection == weeklyMealSelection[index - 1] {
                randomSelection = Int(arc4random_uniform(UInt32(food.meals.count)))
            }
            weeklyMealSelection.append(randomSelection)
        }
    }
    
}



//This extension is to manage the CollectionView
extension WeeklyDinnersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == plannedMealsCV {
            return daysOfTheWeek.names.count
        }
        if collectionView == mealChoicesCV {
            return food.meals.count
        }
        return daysOfTheWeek.names.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == plannedMealsCV {
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("preparedMealsCell", forIndexPath: indexPath) as? preparedMealsCell else {return UICollectionViewCell()}
            cell.foodImage?.image = UIImage(named: food.imageNames[weeklyMealSelection[indexPath.row]])
            cell.dayOfWeekLabel?.text = daysOfTheWeek.names[indexPath.row]
            return cell
        }
        if collectionView == mealChoicesCV {
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("mealChoiceCell", forIndexPath: indexPath) as? mealChoicesCell else {return UICollectionViewCell()}
            let myData = Food()
            cell.mealChoiceLabel?.text = myData.meals[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            if collectionView == plannedMealsCV {
                let mySize = CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.width*1.5)
                return mySize
            }
            if collectionView == mealChoicesCV {
                let mySize = CGSize(width: collectionView.bounds.size.width, height: 45)
                return mySize
            }
            return CGSize(width: 0, height: 0)
    }
    
}

//This extension is to manage the selection gesutre and animations
extension WeeklyDinnersVC {
    
    func setupGestureRecongizers(){
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "selectedOption:")
        gestureRecognizer.minimumPressDuration = 0.1
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    func setTheDefaultImageSizeForAnimation(){
        guard let anImageCell = plannedMealsCV.cellForItemAtIndexPath(plannedMealsCV.indexPathsForVisibleItems()[0]) as? preparedMealsCell else {return}
        imageSize = anImageCell.foodImage.bounds.size
    }
    
    func selectedOption(sender: UILongPressGestureRecognizer){
        let myTouchInView = sender.locationInView(view)
        
        switch sender.state {
        case .Began:
            let myTouchInCollection = sender.locationInView(mealChoicesCV)
            guard let indexPath = mealChoicesCV.indexPathForItemAtPoint(myTouchInCollection) else {return}
            mealSelected = indexPath
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            createImageOfSelectedOptionUnderTouch(myTouchInView, index: indexPath.row)
            break
            
        case .Changed:
            if mealSelected != NSIndexPath() {
                selectedImageHorizontalConstraint.constant = myTouchInView.x
                selectedImageVerticalConstraint.constant = myTouchInView.y
                
                possibleMealToBeReplacedCell.backgroundColor = defaultCellBackground

                selectCellThatIsBeingTouched(sender)
            }
            break
            
        case .Ended:
            if mealSelected != NSIndexPath(){
                possibleMealToBeReplacedCell.backgroundColor = UIColor.whiteColor()
                if mealToBeReplaced != NSIndexPath() {
                    replaceSelectedMeal()
                }
                removeTheMealSelected()
            }
            break
            
        default:
            break
            
        }
    }
    
    func replaceSelectedMeal(){
        weeklyMealSelection[mealToBeReplaced.row] = mealSelected.row
        plannedMealsCV.reloadData()
    }
    
    func removeTheMealSelected(){
        mealSelected = NSIndexPath()
        let viewToRemove = view.viewWithTag(1)
        viewToRemove?.removeConstraint(selectedImageVerticalConstraint)
        viewToRemove?.removeConstraint(selectedImageHorizontalConstraint)
        viewToRemove?.removeFromSuperview()
    }
    
    func selectCellThatIsBeingTouched(sender: UILongPressGestureRecognizer){
        let myTouchInView = sender.locationInView(view)
        if CGRectContainsPoint(plannedMealsCV.frame, myTouchInView) {
            let myTouchInPlannedMeals = sender.locationInView(plannedMealsCV)
            guard let indexPath = plannedMealsCV.indexPathForItemAtPoint(myTouchInPlannedMeals) else {return}
            guard let selectedChangeMealCell = plannedMealsCV.cellForItemAtIndexPath(indexPath) as? preparedMealsCell else {return}
            possibleMealToBeReplacedCell = selectedChangeMealCell
            possibleMealToBeReplacedCell.backgroundColor = highlightedCellBackground
            mealToBeReplaced = indexPath
        } else {
            possibleMealToBeReplacedCell.backgroundColor = defaultCellBackground
            mealToBeReplaced = NSIndexPath()
        }
    }
    
    func createImageOfSelectedOptionUnderTouch(givenTouch:CGPoint, index:Int){
        
        selectedImage = UIImageView(frame: CGRectMake(0,0,0,0))
        selectedImage.image = UIImage(named: food.imageNames[index])
        selectedImage.translatesAutoresizingMaskIntoConstraints = false
        selectedImage.tag = 1
        selectedImage.alpha = 0
        selectedImage.transform = CGAffineTransformMakeScale(0.3, 0.3)
        view.addSubview(selectedImage)
        
        selectedImageHorizontalConstraint = NSLayoutConstraint(item: selectedImage, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: givenTouch.x)
        view.addConstraint(selectedImageHorizontalConstraint)
        
        selectedImageVerticalConstraint = NSLayoutConstraint(item: selectedImage, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: givenTouch.y)
        view.addConstraint(selectedImageVerticalConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: selectedImage, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: imageSize.height)
        view.addConstraint(heightConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: selectedImage, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: imageSize.width)
        view.addConstraint(widthConstraint)
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.selectedImage.alpha = 1
            self.selectedImage.transform = CGAffineTransformMakeScale(1, 1)
        }
    }
    
}
