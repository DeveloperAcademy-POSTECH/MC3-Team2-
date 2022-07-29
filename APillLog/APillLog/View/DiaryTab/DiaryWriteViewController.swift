//
//  DiaryWriteViewController.swift
//  APillLog
//
//  Created by dohankim on 2022/07/20.
//

import UIKit
import CoreData

class DiaryWriteViewController: UIViewController {
    @IBOutlet weak var mistakeTextView: UITextView!
    @IBOutlet weak var recognizeTextView: UITextView!
    @IBOutlet weak var actionTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var diaryWriteDatePicker: UIDatePicker!
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        CoreDataManager.shared.addCBT(selectDate: diaryWriteDatePicker.date, mistakeContext: mistakeTextView.text, recognizeContext: recognizeTextView.text!, actionContext: actionTextView.text!)
        _ = navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryWriteDatePicker.tintColor = UIColor.AColor.accent
        // Do any additional setup after loading the view.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
               hideKeyboard()
           }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mistakeTextView.becomeFirstResponder()
    }
    
//    MARK: - For the Sprint2  (in case of moving textview)
//    @objc func keyboardWillShow(notification: NSNotification) {
//
//            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//               // if keyboard size is not available for some reason, dont do anything
//               return
//            }
//
//          // move the root view up by the distance of keyboard height
//          self.view.frame.origin.y = 0 - keyboardSize.height
//        }
//
//        @objc func keyboardWillHide(notification: NSNotification) {
//          // move back the root view origin to zero
//          self.view.frame.origin.y = 0
//        }

    func hideKeyboard() {

            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
