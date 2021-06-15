//
//  WordsTableViewController.swift
//  Yometa
//
//  Created by 川上知宏 on 2021/06/02.
//

import UIKit
import RealmSwift

class WordsTableViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    var realm: Realm!
    
    var texts: Results<Text>!
    
    var textNum = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        realm = try! Realm()
        
        texts = realm.objects(Text.self)
        table.reloadData()
        
        // make UIImageView instance
        let imageView = UIImageView(frame: CGRect.init(x:0, y:0, width: self.tableView.frame.width, height: self.tableView.frame.height))
        // read image
        let image = UIImage(named: "gray_back.jpg")
        // set image to ImageView
        imageView.image = image
        /*
        // set alpha value of imageView
        imageView.alpha = 1.0
        */
        // set imageView to backgroundView of TableView
        self.tableView.backgroundView = imageView
        
        tableView.separatorStyle = .none
        
        //print(textNum)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        texts = realm.objects(Text.self)
        table.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return texts[textNum].registrationWords.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "registrationCell", for: indexPath) as! RegistrationWordTableViewCell
        
        cell.english.text = texts[textNum].registrationWords[indexPath.row].english
        cell.japanese.text = texts[textNum].registrationWords[indexPath.row].japanese
        // Configure the cell...
        
        cell.back.layer.cornerRadius = 8
        
        /*
        cell.back.layer.shadowColor = UIColor.black.cgColor
        cell.back.layer.shadowOpacity = 1
        cell.back.layer.shadowRadius = 8
        cell.back.layer.shadowOffset = CGSize(width: 4, height: 4)
 */
        // cellの背景を透過
        cell.backgroundColor = UIColor.clear
        // cell内のcontentViewの背景を透過
        cell.contentView.backgroundColor = UIColor.clear
        
        if texts[textNum].registrationWords[indexPath.row].check == true {
            cell.gazou.image = UIImage(named: "ok.jpg")
        } else {
            cell.gazou.image = UIImage(named: "mada.jpg")
        }
        
        return cell
    }
    
    override func tableView (_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 61
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
      {
        return true
      }
      //スワイプしたセルを削除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
          try! realm.write {
            realm.delete(texts[textNum].registrationWords[indexPath.row])
          }
          tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
      }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        let x = tableView.dequeueReusableCell(withIdentifier: "registrationCell", for: indexPath) as! RegistrationWordTableViewCell
        
        try! realm.write {
            texts[textNum].registrationWords[indexPath.row].check = !(texts[textNum].registrationWords[indexPath.row].check)
        }
        
        if texts[textNum].registrationWords[indexPath.row].check {
            x.gazou.image = UIImage(named: "ok.jpg")
        } else {
            x.gazou.image = UIImage(named: "mada.jpg")
        }
        
        self.table.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        
    }
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
