//
//  AddPrimaryPillViewController.swift
//  APillLog
//
//  Created by 이영준 on 2022/07/18.
//

import UIKit

protocol AddPrimaryPillViewControllerDelegate {
    func didAddPrimaryPill()
}

class AddPrimaryPillViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    // MARK: @IBOutlet
    @IBOutlet weak var primaryPillMorningButton: UIButton!
    @IBOutlet weak var primaryPillAfternoonButton: UIButton!
    @IBOutlet weak var primaryPillEveningButton: UIButton!
    
    @IBOutlet weak var PrimaryPillName: UITextField!
    @IBOutlet weak var PrimaryPillDosage: UITextField!
    
    @IBOutlet weak var savePrimaryPillButton: UIButton!
    @IBOutlet weak var cancleButton: UIButton!
    
    
    // MARK: Property
    var coredataManager:CoreDataManager = CoreDataManager()
    var primaryPillDosingCycle: Int = 0
    
    var delegate: AddPrimaryPillViewControllerDelegate?
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    // MARK: LifeCycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sheetPresentationController.detents = [.medium()]
        savePrimaryPillButton.isEnabled = false
    }
    
    // MARK: @IBAction
    @IBAction func tapCancelButton() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func tapSaveButton() {
        let pillName = PrimaryPillName.text ?? ""
        let pillDosage = PrimaryPillDosage.text ?? ""
        
        coredataManager.addPrimaryPill(name: pillName, dosage: pillDosage, dosingCycle: Int16(primaryPillDosingCycle))
        
        self.presentingViewController?.dismiss(animated: true)
        delegate?.didAddPrimaryPill()
    }
    
    @IBAction func detectNameTextField(){
        detectEnableSaveButton()
        
    }
    @IBAction func detectDosageTextField(){
        detectEnableSaveButton()
    }
    
    @IBAction func togglePrimaryPillMorning(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.primaryPillDosingCycle += 1
        } else {
            self.primaryPillDosingCycle -= 1
        }
        changePrimaryPillDosingButtonState(sender)
        detectEnableSaveButton()
    }
    
    @IBAction func togglePrimaryPillAfternoon(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.primaryPillDosingCycle += 2
        } else {
            self.primaryPillDosingCycle -= 2
        }
        changePrimaryPillDosingButtonState(sender)
        detectEnableSaveButton()
    }
    
    @IBAction func togglePrimaryPillEvening(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.primaryPillDosingCycle += 4
        } else {
            self.primaryPillDosingCycle -= 4
        }
        changePrimaryPillDosingButtonState(sender)
        detectEnableSaveButton()
    }
    
    
    // MARK: Function
    func changePrimaryPillDosingButtonState(_ button: UIButton) {
        if button.isSelected {
            button.backgroundColor = UIColor.AColor.accent
            button.setTitleColor(UIColor.AColor.white, for: .selected)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        } else {
            button.backgroundColor = .white
            button.setTitleColor(UIColor.AColor.gray, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.AColor.disable.cgColor
        }
    }
    
    func detectEnableSaveButton(){
        let pillName = PrimaryPillName.text ?? ""
        let pillDosage = PrimaryPillDosage.text ?? ""
        
        if (pillName != "" && pillDosage != "" && primaryPillDosingCycle != 0)
        {
            savePrimaryPillButton.isEnabled = true
        }
        else{
            savePrimaryPillButton.isEnabled = false
        }
        
        
    }
}

