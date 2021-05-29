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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupVision()
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
                self.textView.text = self.resultingText
            })
        }
    }
}

