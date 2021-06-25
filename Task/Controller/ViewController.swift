//
//  ViewController.swift
//  Task
//
//  Created by Khaled Bohout on 25/06/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var sectorPickerView: UIPickerView!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var sectors = [String]()
    var selectedSector: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectorPickerView.delegate = self
        sectorPickerView.dataSource = self
        getSectors()
        // Do any additional setup after loading the view.
    }
    
    func showPicker() {
        
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let datePickerVC = homeStoryboard.instantiateViewController(withIdentifier: "DatePickerVC") as! DatePickerVC
        datePickerVC.delegate = self
        self.addChild(datePickerVC)
        datePickerVC.view.frame = self.view.frame
        self.view.addSubview((datePickerVC.view)!)
        datePickerVC.didMove(toParent: self)
    }

    @IBAction func dateBtnTapped(_ sender: Any) {
        
        showPicker()
    }
    
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        guard nameTextField.text != nil else {
            
            Toast.show(message: "please enter your name", controller: self)
            return
        }
        
        guard dateTextField.text != nil else {
            
            Toast.show(message: "please enter your date of birth", controller: self)
            return
        }
        
        guard ageTextField.text != nil else {
            
            Toast.show(message: "please enter your date of birth", controller: self)
            return
        }
        
        guard selectedSector != nil else {
            
            Toast.show(message: "please enter your industry", controller: self)
            return
        }
        
        guard emailAddressTextField.text != nil else {
            
            Toast.show(message: "please enter your email", controller: self)
            return
        }
        
        guard isValidEmail(testStr: emailAddressTextField.text!) else {
            Toast.show(message: "email is in wrong format, please try again", controller: self)
            return
        }
        
        guard phoneNumberTextField.text != nil else {
            
            Toast.show(message: "please enter your name", controller: self)
            return
        }
        
        guard isValidPhone(phone: phoneNumberTextField.text!) else {
            
            Toast.show(message: "phone number format is wrong, please try again", controller: self)
            return
        }
        
        let name = nameTextField.text!
        let date = dateTextField.text!
        let age = ageTextField.text!
        let industry = selectedSector!
        let email = emailAddressTextField.text!
        let phone = phoneNumberTextField.text!
        
        let user = User(name: name, bdIslamic: date, email: email, phoneNumber: phone, industry: industry, age: age)
        
        sendData(user: user)
        
    }
    
}

extension ViewController: DateDelegate {
    
    func passSelectedDate(date: Date) {
        
        let date = date
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        formatter1.calendar = Calendar(identifier: .islamicUmmAlQura)
        
        self.dateTextField.text = formatter1.string(from: date)
        
        let calendar = Calendar(identifier: .islamicUmmAlQura)
        let components = calendar.dateComponents([.year], from: date)
        let year = components.year
        let month = components.month
        let day = components.day

        
        let dob = DateComponents(calendar: Calendar(identifier: .islamicUmmAlQura), year: year, month: month, day: day).date!
        let age = dob.age
        
        self.ageTextField.text = "\(age)"
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource  {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sectors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sectors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedSector = sectors[row]
    }
    
    
    
}

extension ViewController {
    
    func getSectors() {
        
        let req = GetSectorsRequest()
        
        Network.request(req: req) { result in
            switch result {
            
            case .success(let sectorts):
                print(sectorts)
                self.sectors = sectorts.industries
                self.sectorPickerView.reloadAllComponents()
            case .cancel(let cancelError):
                print(cancelError!)
            case .failure(let error):
                print(error!)
            }
        }
    }
    
    func sendData(user: User) {
        
        let req = PostUserRequest(user: user)
        
        Network.request(req: req) { result in
            switch result {
            case .success(let user):
                print(user)
            case .cancel(let cancelError):
                print(cancelError!)
            case .failure(let error):
                print(error!)
            }
        }
    }
}

