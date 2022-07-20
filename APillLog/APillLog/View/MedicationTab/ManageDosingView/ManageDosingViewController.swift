//
//  ManageDosingViewController.swift
//  APillLog
//
//  Created by Park Sungmin on 2022/07/20.
//

import Foundation
import UIKit

class ManageDosingViewController: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Property
    var coreDataManager: CoreDataManager = CoreDataManager()
    
    let cellIdentifier = "ManageDosingCell"
    
    var primaryPillList: [PrimaryPill] = []
    
    // MARK: LifeCycle Function
    override func viewDidLoad() {
        viewTitle.font = UIFont.AFont.navigationTitle
        
        primaryPillList = coreDataManager.fetchPrimaryPill()
    }
    
    // MARK: Function
    private func dosingCycleToString(dosingCycle: Int16) -> String {
        var str = ""
        
        if dosingCycle & 1 == 1 {
            str.append("아침")
        }
        
        if dosingCycle & 2 == 2 {
            if str.isEmpty == false {
                str.append(", ")
            }
            
            str.append("점심")
        }
        
        if dosingCycle & 4 == 4 {
            if str.isEmpty == false {
                str.append(", ")
            }
            str.append("저녁")
        }
        
        return str
    }
    
    // MARK: @IBAction
    @IBAction func addPillData(_ sender: Any) {
        coreDataManager.addPrimaryPill(name: "콘서타", dosage: "18mg", dosingCycle: 3)
        primaryPillList = coreDataManager.fetchPrimaryPill()
        tableView.reloadData()
    }
}

extension ManageDosingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.dummies.count
        return self.primaryPillList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ManageDosingTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ManageDosingTableViewCell else {
            return UITableViewCell()
        }
        
        cell.dosingCycleLabel.font = UIFont.AFont.caption
        cell.nameAndDosageLabel.font = UIFont.AFont.tableViewBody
        
        cell.dosingCycleLabel.textColor = UIColor.AColor.gray
        cell.nameAndDosageLabel.textColor = UIColor.AColor.black
        
        
        cell.primaryPill = primaryPillList[indexPath.row]
        cell.nameAndDosageLabel.text = (primaryPillList[indexPath.row].name ?? "NONAME") + " " + (primaryPillList[indexPath.row].dosage ?? "NODOSAGE")
        cell.dosingCycleLabel.text = dosingCycleToString(dosingCycle: primaryPillList[indexPath.row].dosingCycle)
        cell.isShowingSwitch.isOn = primaryPillList[indexPath.row].isShowing
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            coreDataManager.deletePrimaryPill(pill: primaryPillList[indexPath.row])
            
            primaryPillList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else {
            return
        }
    }
}

extension ManageDosingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
}


// ManageDosingTableViewCell
class ManageDosingTableViewCell: UITableViewCell {
    
    // MARK: @IBOutlet
    @IBOutlet weak var dosingCycleLabel: UILabel!
    @IBOutlet weak var nameAndDosageLabel: UILabel!
    @IBOutlet weak var isShowingSwitch: UISwitch!
    
    // MARK: Property
    var primaryPill: PrimaryPill? = nil
    var coreDataManager = CoreDataManager()

    // MARK: @IBAction
    @IBAction func toggleIsShowing(_ sender: UISwitch) {
        coreDataManager.togglePrimaryPillIsShowing(pill: primaryPill!)
    }
}
