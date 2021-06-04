//
//  RegisterTextViewController.swift
//  Yometa
//
//  Created by 川上知宏 on 2021/05/30.
//

import UIKit
import RealmSwift

class RegisterTextViewController: UIViewController {
    
    var textWords: [String] = []
    var textWordsTmp: [TextWord] = []
    @IBOutlet var titleTextField: UITextField!
    var realm: Realm!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        realm = try! Realm()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
    
    @IBAction func registration() {
        let text = Text()

        for element in textWords {
            let textWordTmp = TextWord()
            textWordTmp.textWord = element
            textWordsTmp.append(textWordTmp)
        }
        text.title = titleTextField.text ?? "Undefined"

        text.textWords.append(objectsIn: self.textWordsTmp)
        
        try! realm.write {
            realm.add(text)
            //print(text)
        }
       
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
