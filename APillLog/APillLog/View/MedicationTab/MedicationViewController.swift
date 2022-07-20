//
//  MedicationViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class MedicationViewController: UIViewController {

    // MARK: - IBOutlets
    // DatePicker
    @IBOutlet weak var lastDayButton: UIButton!
    @IBOutlet weak var nextDayButton: UIButton!
    @IBOutlet weak var dayLabel: UILabel!

    // Symptom Button
    @IBOutlet weak var symptomButton: UIButton!
    @IBOutlet weak var symptomButtonBackgroundView: UIView!
    
    // Primary Pill
    @IBOutlet weak var primaryPillTableView: UITableView!
    @IBOutlet weak var primaryPillField: UIView!
    @IBOutlet weak var primaryPillViewLinkButton: UIButton!
    
    // Secondary Pill
    @IBOutlet weak var secondaryPillTableView: UITableView!
    @IBOutlet weak var secondaryPillField: UIView!
    @IBOutlet weak var secondaryPillModalButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
//        setMedicationTableViews()
        setStyle()
    }
    
    private func setMedicationTableViews() {
        // Primary Pill TableView
//        primaryPillTableView.delegate = self
//        primaryPillTableView.dataSource = self
        // Secondary Pill TableView
//        secondaryPillTableView.delegate = self
//        secondaryPillTableView.dataSource = self
    }
    
    private func setStyle(){
        self.view.backgroundColor = .systemGray6
        setDatePickerStyle()
        setSymptomButtonStyle()
        setPrimaryPillViewStyle()
        setSecondaryPillViewStyle()
    }
    
    private func setDatePickerStyle() {
        // image
        lastDayButton.setImage(UIImage(named: "left-black"), for: .normal)
        nextDayButton.setImage(UIImage(named: "right-gray"), for: .normal)
        // color
        lastDayButton.tintColor = .darkGray
        nextDayButton.tintColor = .darkGray
    }
    
    private func setSymptomButtonStyle() {
        symptomButtonBackgroundView.layer.cornerRadius = 10
    }
    
    private func setPrimaryPillViewStyle() {
        primaryPillField.layer.cornerRadius = 10
    }
    
    private func setSecondaryPillViewStyle() {
        secondaryPillField.layer.cornerRadius = 10
    }

}

extension MedicationViewController: AddSecondaryPillViewControllerDelegate {

    // MARK: AddSecondaryPillViewControllerDelegate
    func didFinishModal(selectedPill: String) {
        // TODO : 아래에 추가약 복용 추가하기 모달이 내려간 이후 수행할 함수 작성
    
    }

    @IBAction func tapAddSecondaryPillButton() {
        let storyboard: UIStoryboard = UIStoryboard(name: "AddSecondaryPillView", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "AddSecondPillStoryboard") as! AddSecondaryPillViewController
        
        nextViewController.delegate = self
        
        self.present(nextViewController, animated: true)
    }
}

//extension MedicationViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return data.counr
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.
//    }
//}
//
//extension MedicationViewController: UITableViewDelegate {
//
//}
