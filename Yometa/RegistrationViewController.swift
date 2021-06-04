//
//  RegistrationViewController.swift
//  Yometa
//
//  Created by 川上知宏 on 2021/05/23.
//

import UIKit
import RealmSwift

class RegistrationViewController: UIViewController {
    
    var textNum = Int()
    var wordNum = Int()
    
    var realm: Realm!
    var texts: Results<Text>!
    
    @IBOutlet var englishTextField: UITextField!
    @IBOutlet var japaneseTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        
        //print(textNum)
        //print(wordNum)
        
        texts = realm.objects(Text.self)
        englishTextField.text = texts[textNum].textWords[wordNum].textWord

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        texts = realm.objects(Text.self)
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
