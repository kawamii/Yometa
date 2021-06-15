//
//  TextViewController.swift
//  Yometa
//
//  Created by 川上知宏 on 2021/05/23.
//

import UIKit
import RealmSwift

class TextViewController: UIViewController {
    
    var num = Int()
    
    var realm: Realm!
    var texts: Results<Text>!
    
    @IBOutlet var aWordButton: UIButton!
    @IBOutlet var rWordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        texts = realm.objects(Text.self)
        //print(num)
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = texts[num].title

        self.aWordButton.layer.masksToBounds = true
        self.aWordButton.layer.cornerRadius = 8.0
        
        self.rWordButton.layer.masksToBounds = true
        self.rWordButton.layer.cornerRadius = 8.0
        
    }
    
    @IBAction func allWordsButton(_ sender: Any) {
        performSegue(withIdentifier: "toAllWordsTableViewController", sender: nil)
    }
    
    @IBAction func reviewWordsButton(_ sender: Any) {
        performSegue(withIdentifier: "toWordsTableViewController", sender: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "toAllWordsTableViewController") {
            let next = segue.destination as? AllWordsTableViewController
            next?.textNum = num
        }
        
        if (segue.identifier == "toWordsTableViewController") {
            let next = segue.destination as? WordsTableViewController
            next?.textNum = num
        }
     
    }
    


}
