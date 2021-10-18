//
//  ViewController.swift
//  Instagrid
//
//  Created by Déborah Suon on 15/04/2021.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(startAnimation))
        guard let swipeGesture = swipeGesture else {return}
        swipeGesture.direction = .up
        pictureView.addGestureRecognizer(swipeGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(setupSwipeDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @IBOutlet var layoutButtons: [UIButton]!
    
    @IBOutlet var pictureView: UIView!
    
    @IBOutlet var topLeftPictureView: UIButton!
    @IBOutlet var topRightPictureView: UIButton!
    @IBOutlet var bottomLeftPictureView: UIButton!
    @IBOutlet var bottomRightPictureView: UIButton!
    
    let imagePickerController = UIImagePickerController()
    var currentButton: UIButton?
    var swipeGesture: UISwipeGestureRecognizer?
    
    //function to add a picture from the library
    @IBAction func plusButtonTap(_ sender: UIButton) {
        currentButton = sender
        present(imagePickerController, animated: true)
    }
    // function layoutSelected to select a Layout with the buttons
    @IBAction func layoutSelected(_ sender: UIButton) {
        for button in layoutButtons {
            button.isSelected = false
        }
        
        sender.isSelected = true
        switch sender.tag {
        case 0:
            style = .leftLayout
        case 1:
            style = .centerLayout
        case 2:
            style = .rightLayout
        default: break
        }
    }
    // change the composition of the Layout according to the style
    enum Layout {
        case leftLayout, centerLayout, rightLayout
    }
    
    var style: Layout = .rightLayout {
        didSet {
            chooseYourLayout(style)
        }
    }
    
    // function to change the hidden box according to the leftLayout, the centerLayout or the rightLayout
    private func chooseYourLayout(_ style: Layout) {
        switch style {
        case.leftLayout:
            
            topRightPictureView.isHidden = false
            bottomRightPictureView.isHidden = true
            
        case.centerLayout:
            
            bottomRightPictureView.isHidden = false
            topRightPictureView.isHidden = true
            
        case.rightLayout:
            
            topRightPictureView.isHidden = false
            bottomRightPictureView.isHidden = false
        }
    }
    // function for the swipeGesture on the pictureView according to portrait or landscape mode
    @objc private func startAnimation() {
        
        let height = self.view.frame.height
        let width = self.view.frame.width
        if swipeGesture?.direction == .up {
            UIView.animate(withDuration: 0.5) {
                self.pictureView.transform = CGAffineTransform(translationX: 0, y: -height)
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.pictureView.transform = CGAffineTransform(translationX: -width, y: 0)
            }
        }
        shareLayout()
    }
    // function for the setup of the swipeGesture according to the direction: Left or Up
    @objc private func setupSwipeDirection() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            swipeGesture?.direction = .left
        } else {
            swipeGesture?.direction = .up
            
        }
    }
    // function to share the Layout on other apps  
    private func shareLayout(){
        
        let activityViewController = UIActivityViewController(activityItems: [pictureView.image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.openInIBooks]
        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            UIView.animate(withDuration: 0.5) {
                self.pictureView.transform = .identity
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        currentButton?.setImage(selectedImage, for: .normal)
        dismiss(animated: true)
    }
}
