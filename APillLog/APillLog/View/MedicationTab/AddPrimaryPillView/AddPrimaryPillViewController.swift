//
//  AddPrimaryPillViewController.swift
//  APillLog
//
//  Created by 이영준 on 2022/07/18.
//

import UIKit

class AddPrimaryPillViewController: UIViewController, UISheetPresentationControllerDelegate {

    // MARK: @IBOutlet
    @IBOutlet weak var primaryPillMorningButton: UIButton!
    @IBOutlet weak var primaryPillAfternoonButton: UIButton!
    @IBOutlet weak var primaryPillEveningButton: UIButton!
    
    
    // MARK: Property
    var primaryPillDosingCycle: Int = 0
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    // MARK: LifeCycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetPresentationController.detents = [.medium()]
    }
    
    // MARK: @IBAction
    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func tapSaveButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func togglePrimaryPillMorning(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.primaryPillDosingCycle += 1
        } else {
            self.primaryPillDosingCycle -= 1
        }
        changePrimaryPillDosingButtonState(sender)
    }
    
    @IBAction func togglePrimaryPillAfternoon(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.primaryPillDosingCycle += 2
        } else {
            self.primaryPillDosingCycle -= 2
        }
        changePrimaryPillDosingButtonState(sender)
    }
    
    @IBAction func togglePrimaryPillEvening(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.primaryPillDosingCycle += 4
        } else {
            self.primaryPillDosingCycle -= 4
        }
        changePrimaryPillDosingButtonState(sender)
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
}

