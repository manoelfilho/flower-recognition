//
//  ViewController.swift
//  flowers-recognition
//
//  Created by Manoel Filho on 25/01/21.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    let wikipediaURl = "https://pt.wikipedia.org/w/api.php"
    
    @IBOutlet weak var text: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.isEditing = true
        text.isEditable = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            guard let convertedCIImage = CIImage(image: userPickedImage) else {
                fatalError("Erro ao converter a imagem")
            }
            
            self.imageView.image = userPickedImage

            detect(image: convertedCIImage)
            
        }
        
        self.imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("Can't load model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let result = request.results?.first as? VNClassificationObservation else {
                fatalError("Could not complete classfication")
            }
                        
            self.navigationItem.title = result.identifier.capitalized
            
            self.requestInfo(flowerString: result.identifier)
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
        
    }
    
    func requestInfo(flowerString: String) {
       
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts",
            "exintro" : "",
            "explaintext" : "",
            "titles" : flowerString,
            "indexpageids" : "",
            "redirects" : "1",
        ]
        
        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("Got the wikipidia info...")
                print(JSON(response.result.value!))
                
                let flowerJson: JSON = JSON(response.result.value!)
                
                let pageid = flowerJson["query"]["pageids"][0].stringValue
                
                let flowerDescription = flowerJson["query"]["pages"][pageid]["extract"].stringValue
                
                self.text.text = flowerDescription
                
                
            }else{
                print("Error on request infos...")
            }
        }
    }
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

