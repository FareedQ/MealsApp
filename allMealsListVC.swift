//
//  TableViewController.swift
//  MealsApp
//
//  Created by FareedQ on 2016-01-21.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit

class allMealsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let myData = Food()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("Did recieve a memory warning in the TableViewController", "")
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData.meals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = myData.meals[indexPath.row]
        return cell
    }
}
