//
//  DatePickerVC.swift
//  Task
//
//  Created by Khaled Bohout on 25/06/2021.
//

import Foundation
import UIKit

protocol DateDelegate: AnyObject {
    func passSelectedDate(date: Date)
}

class DatePickerVC: UIViewController {

    var datePicker: UIDatePicker?
    var datePickerConstraints = [NSLayoutConstraint]()
    
    var selectedDate: Date?
    
    weak var delegate: DateDelegate?
    
    @IBOutlet weak var pickerContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setUpUI() {
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        pickerContainer.backgroundColor = UIColor(white: 1, alpha: 1.0)
        showDatePicker()
        self.navigationController?.navigationBar.isHidden = true
        let dismisViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismisView))
        dismisViewGesture.delegate = self
        self.view.addGestureRecognizer(dismisViewGesture)
    }

    
    func showDatePicker() {
        
        datePicker = UIDatePicker()
        datePicker?.date = Date()
        datePicker?.locale = .current
        datePicker?.datePickerMode = .date
        datePicker?.calendar = Calendar(identifier: .islamicUmmAlQura)
        datePicker?.tintColor = hexStringToUIColor(hex: "#00C1B2")
        
            if #available(iOS 14.0, *) {
                datePicker?.preferredDatePickerStyle = .inline
            } else {
                // Fallback on earlier versions
            }
        datePicker?.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
        addDatePickerAsSubview()
    }

    
    
    
    func addDatePickerAsSubview() {
        guard let datePicker = datePicker else { return }
        self.pickerContainer.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        updateDatePickerConstraints()
    }
    
    
    func updateDatePickerConstraints() {
        guard let datePicker = datePicker else { return }
        
        // Remove any previously set constraints.
        self.view.removeConstraints(datePickerConstraints)
        datePickerConstraints.removeAll()
        
        // Set new constraints depending on the date picker style.
        datePickerConstraints.append(datePicker.centerYAnchor.constraint(equalTo: self.pickerContainer.centerYAnchor))
        
        if #available(iOS 14.0, *) {
      //      if datePicker.preferredDatePickerStyle != .inline {
      //          datePickerConstraints.append(datePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
//            } else {
                datePickerConstraints.append(datePicker.leadingAnchor.constraint(equalTo: self.pickerContainer.leadingAnchor, constant: 0))
                datePickerConstraints.append(datePicker.trailingAnchor.constraint(equalTo: self.pickerContainer.trailingAnchor, constant: 0))
//            }
        } else {
            // Fallback on earlier versions
        }

        // Activate all constraints.
        NSLayoutConstraint.activate(datePickerConstraints)
    }
    
    
    @objc func handleDateSelection() {
        guard let picker = datePicker else { return }
        print("Selected date/time:", picker.date)
        self.selectedDate = picker.date
        self.delegate?.passSelectedDate(date: picker.date)
    }
    
    @objc func dismisView(_ sender: UITapGestureRecognizer) {
        self.view.removeFromSuperview()
    }
    
}

extension DatePickerVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.pickerContainer) == true {
            return false
        }
        return true
    }
}
