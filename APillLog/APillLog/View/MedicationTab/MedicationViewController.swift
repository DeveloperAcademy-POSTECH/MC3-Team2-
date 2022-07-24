//
//  MedicationViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class MedicationViewController: UIViewController, UITableViewDelegate {
    
    let cellIdentifier = "medicationPillCell"
    
    var coreDataManager = CoreDataManager()
    
    var primaryPillList: [ShowPrimaryPill] = []
    var primaryPillListMorning: [ShowPrimaryPill] = []
    var primaryPillListLunch: [ShowPrimaryPill] = []
    var primaryPillListDinner: [ShowPrimaryPill] = []
    var primaryPillListDataSource: [ShowPrimaryPill] = []
    
    var secondaryPillList: [ShowSecondaryPill] = []
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter
    }()
    
    // MARK: - IBOutlets
    
    // Symptom Button
    @IBOutlet weak var symptomButton: UIButton!
    @IBOutlet weak var symptomButtonBackgroundView: UIView!
    
    // Primary Pill
    @IBOutlet weak var primaryPillField: UIView!
    @IBOutlet weak var primaryPillViewLinkButton: UIButton!
    @IBOutlet weak var primaryPillTableView: UITableView!
    @IBOutlet weak var primaryPillTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var primaryPillFieldHeight: NSLayoutConstraint!
    // Secondary Pill
    @IBOutlet weak var secondaryPillField: UIView!
    @IBOutlet weak var secondaryPillModalButton: UIButton!
    @IBOutlet weak var secondaryPillTableView: UITableView!
    
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setPillTableViews()
        
        reloadPrimaryPillTableView()
        reloadSecondaryPillTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadPrimaryPillTableView()
        reloadSecondaryPillTableView()
        
        self.primaryPillTableView.addObserver(self, forKeyPath: "primaryPillTableViewContentSize", options: .new, context: nil)
        
//        self.primaryPillField.addObserver(self, forKeyPath: "primaryPillFieldContentsize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.primaryPillTableView.removeObserver(self, forKeyPath: "primaryPillTableViewContentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "primaryPillTableViewContentSize"
            {
                if object is UITableView
                {
                    if let newValue = change?[.newKey]{
                        let newSize = newValue as! CGSize
                        self.primaryPillTableViewHeight.constant = newSize.height
                        print("뉴 사이즈: ", newSize.height)
                    }
                }
            }
    
//            if keyPath == "secondaryPillTableViewContentSize"
//            {
//                if object is UITableView
//                {
//                    if let newValue = change?[.newKey]{
//                        let newSize = newValue as! CGSize
//                        self.secondaryPillTableViewHeight.constant = newSize.height
//                    }
//                }
//            }
        }
    
    @IBAction func selectTimeSegmentedControl(_ sender: Any) {
        switch(timeSegmentedControl.selectedSegmentIndex) {
        case 0:
            primaryPillListDataSource = primaryPillListMorning
        case 1:
            primaryPillListDataSource = primaryPillListLunch
        case 2:
            primaryPillListDataSource = primaryPillListDinner
        default:
            primaryPillListDataSource = []
        }
        primaryPillTableView.reloadData()
    }
    
    private func setStyle(){
        self.view.backgroundColor = .systemGray6
        setSymptomButtonStyle()
        setPrimaryPillViewStyle()
        setSecondaryPillViewStyle()
    }
    
    private func setPillTableViews() {
        let nibName = UINib(nibName: "MedicationPillCell", bundle: nil)
        primaryPillTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
        secondaryPillTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
        primaryPillTableView.delegate = self
        primaryPillTableView.dataSource = self
        secondaryPillTableView.delegate = self
        secondaryPillTableView.dataSource = self
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
    
    private func reloadPrimaryPillTableView() {
        coreDataManager.sendPrimarypillToShowPrimaryPill()
        primaryPillList = coreDataManager.fetchShowPrimaryPill(selectedDate: Date())
        
        primaryPillListMorning = coreDataManager.fetchShowPrimaryPillMorning(TodayTotalPrimaryPill: primaryPillList)
        primaryPillListLunch = coreDataManager.fetchShowPrimaryPillLunch(TodayTotalPrimaryPill: primaryPillList)
        primaryPillListDinner = coreDataManager.fetchShowPrimaryPillDinner(TodayTotalPrimaryPill: primaryPillList)
        
        switch(timeSegmentedControl.selectedSegmentIndex) {
        case 0:
            primaryPillListDataSource = primaryPillListMorning
        case 1:
            primaryPillListDataSource = primaryPillListLunch
        case 2:
            primaryPillListDataSource = primaryPillListDinner
        default:
            primaryPillListDataSource = []
        }
        
        primaryPillTableViewHeight.constant = 75.0 * CGFloat(primaryPillListDataSource.count)
        print(primaryPillListDataSource.count)
        primaryPillFieldHeight.constant = CGFloat(primaryPillTableViewHeight.constant) + 120
        
        primaryPillTableView.reloadData()
    }
    
    private func reloadSecondaryPillTableView() {
        secondaryPillList = coreDataManager.fetchShowSecondaryPill(selectedDate: Date())
        
        secondaryPillTableView.reloadData()
    }
    
    @IBAction func tapAddSecondaryPillButton() {
        let storyboard: UIStoryboard = UIStoryboard(name: "AddSecondaryPillView", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "AddSecondPillStoryboard") as! AddSecondaryPillViewController
        
        nextViewController.delegate = self
        
        self.present(nextViewController, animated: true)
    }
    
    @IBAction func tapAddConditionButton(_ sender: UIButton) {
        guard let checkConditionViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckConditionViewController") as? CheckConditionViewController else { return }
        
        self.navigationController?.pushViewController(checkConditionViewController, animated: true)
        
    }
}

extension MedicationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == primaryPillTableView {
            return self.primaryPillListDataSource.count == 0 ? 1 : self.primaryPillListDataSource.count
        } else {
            return self.secondaryPillList.count  == 0 ? 1 : self.secondaryPillList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MedicationPillCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MedicationPillCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        if tableView == primaryPillTableView {
            
            if primaryPillListDataSource.count == 0 {
                
                guard let emptyCell: EmptyPrimaryPillCell = tableView.dequeueReusableCell(withIdentifier: "EmptyPrimaryPillCell") as? EmptyPrimaryPillCell else { return UITableViewCell() }
                emptyCell.captionLabel.text = "먹어야할 약이 없어요"
                emptyCell.captionLabel.textColor = UIColor.AColor.gray
                emptyCell.captionLabel.font = UIFont.AFont.explainText
                        
                return emptyCell
                
            } else {
                // Image
                cell.pillImageView.image = UIImage(named: "primaryPill")
                // Title
                cell.cellTitleLabel.text = primaryPillListDataSource[indexPath.row].name! + " " + primaryPillListDataSource[indexPath.row].dosage!
                // Time
                cell.pillTimeLabel.text = primaryPillListDataSource[indexPath.row].takeTime != nil ? dateFormatter.string(from:  primaryPillListDataSource[indexPath.row].takeTime!) + "에 먹었어요" : "아직 복약 전이예요"
                // Taking Button
                cell.takingPillButton.isSelected = primaryPillListDataSource[indexPath.row].isTaking
                cell.changeTakingPillButtonState(cell.takingPillButton)
                // Data for delegate
                cell.rowNumber = indexPath.row
                cell.isPrimary = true
                // Style
                cell.cellTitleLabel.font = UIFont.AFont.chipText
                cell.pillTimeLabel.font = UIFont.AFont.caption
            }
            
        } else {
            
            if secondaryPillList.count == 0 {

                guard let emptyCell: EmptySecondaryPillCell = tableView.dequeueReusableCell(withIdentifier: "EmptySecondaryPillCell") as? EmptySecondaryPillCell else { return UITableViewCell() }
                emptyCell.captionLabel.text = "추가로 복용한 약이 있다면 추가해주세요"
                emptyCell.captionLabel.textColor = UIColor.AColor.gray
                emptyCell.captionLabel.font = UIFont.AFont.explainText

                return emptyCell
                
            } else {
                // Image
                cell.pillImageView.image = UIImage(named: "secondaryPill")
                // Title
                cell.cellTitleLabel.text = secondaryPillList[indexPath.row].name! + " " + secondaryPillList[indexPath.row].dosage!
                // Time
                cell.pillTimeLabel.text = secondaryPillList[indexPath.row].takeTime != nil ? dateFormatter.string(from: secondaryPillList[indexPath.row].takeTime!) + "에 먹었어요" : "아직 복약 전이예요"
                // Taking Button
                cell.takingPillButton.isSelected = secondaryPillList[indexPath.row].isTaking
                cell.changeTakingPillButtonState(cell.takingPillButton)
                // Data for delegate
                cell.rowNumber = indexPath.row
                cell.isPrimary = false
                // Style
                cell.cellTitleLabel.font = UIFont.AFont.chipText
                cell.pillTimeLabel.font = UIFont.AFont.caption
            }
        }
        return cell
    }
}

extension MedicationViewController: AddSecondaryPillViewControllerDelegate {
    func didFinishModal() {
        // TODO : 아래에 추가약 복용 추가하기 모달이 내려간 이후 수행할 함수 작성
        reloadSecondaryPillTableView()
    }
}

extension MedicationViewController: TakeMedicationDelegate {
    func setPillTake(rowNumber: Int, isPrimary: Bool) {
        if isPrimary {
            coreDataManager.recordHistoryAndChangeShowPrimaryIsTaking(showPrimaryPill: primaryPillListDataSource[rowNumber])
            primaryPillTableView.reloadData()
        } else {
            coreDataManager.recordHistoryAndChangeShowSecondaryIsTaking(showSecondaryPill: secondaryPillList[rowNumber])
            secondaryPillTableView.reloadData()
        }
    }
}

// 비어있는 테이블에 대해서
class EmptyPrimaryPillCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
}

class EmptySecondaryPillCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
}
