//
//  ViewController.swift
//  imageClassification
//
//  Created by Abdulsamed Arslan on 8.09.2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            
            imagePicker.dismiss(animated: true, completion: nil)
            
            detect(image: image)
        }
    }
    func detect(image:UIImage){
        
        if let model = try? MyImageClassifier_1(configuration:MLModelConfiguration()){
            do{
                let resized = image.resize(size: CGSize(width: 299, height: 299))
                let buffered = resized?.getCVPixelBuffer()
                let predictions = try model.prediction(image: buffered!)
                imageView.image = image
                self.navigationItem.title=predictions.classLabel
                
            }
            
            catch{
                ShowAlert(with: "Cant predict the image", "Prediction error")
            }
            
        }
        else{
            ShowAlert(with: "Model Not found", "Model error")
            
        }
        
        
    }
    
    func ShowAlert(with message: String,_ title:String)  {
        let alertController = UIAlertController(title:title , message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

