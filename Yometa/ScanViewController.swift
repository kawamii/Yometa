//
//  ScanViewController.swift
//  Yometa
//
//  Created by 川上知宏 on 2021/05/30.
//

import UIKit
import Vision
import VisionKit

class ScanViewController: UIViewController {
    
    @IBOutlet private weak var textView: UITextView!
    
    var requests = [VNRequest]()
    var resultingText = ""
    var text = ""
    var textWords: [String] = []
    var orderSet: NSOrderedSet = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupVision()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRegisterTextViewController" {
            let next = segue.destination as? RegisterTextViewController
            next?.textWords = self.textWords
        }
    }
    
    func setupVision() {
        let textRecognitionRequest = VNRecognizeTextRequest { request, _ in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("The observations are of an unexpected type.")
                return
            }
            
            let maximumCandidates = 1
            for observation in observations {
                guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                self.resultingText += candidate.string + "\n"
            }
        }
        
        textRecognitionRequest.recognitionLevel = .accurate
        self.requests = [textRecognitionRequest]
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    
    
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        text = textView.text!
        text = text.replacingOccurrences(of: ",", with: "")
        text = text.replacingOccurrences(of: ".", with: "")
        text = text.replacingOccurrences(of: "?", with: "")
        text = text.replacingOccurrences(of: "\"", with: "")
        
        //print(text)
        textWords = text.components(separatedBy: " ")
        textWords.sort()
        //print(textWords)
        orderSet = NSOrderedSet(array: textWords)
        textWords = orderSet.array as! [String]
        textWords.removeAll(where: {$0 == ""})
        print(textWords)
        performSegue(withIdentifier : "toRegisterTextViewController", sender: nil)
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

extension ScanViewController: VNDocumentCameraViewControllerDelegate {

    // DocumentCamera で画像の保存に成功したときに呼ばれる
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true)

        // Dispatch queue to perform Vision requests.
        let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue",
                                                             qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
        textRecognitionWorkQueue.async {
            self.resultingText = ""
            for pageIndex in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                if let cgImage = image.cgImage {
                    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

                    do {
                        try requestHandler.perform(self.requests)
                    } catch {
                        print(error)
                    }
                }
            }
            DispatchQueue.main.async(execute: {
                // textViewに表示する
                self.resultingText = self.resultingText.replacingOccurrences(of: "\n", with: " ")
                self.textView.text = self.resultingText
                //print(self.resultingText)
            })
        }
    }
}

