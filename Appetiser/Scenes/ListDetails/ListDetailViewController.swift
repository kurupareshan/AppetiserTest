//
//  ListDetailViewController.swift
//  Appetiser
//
//  Created by kurupareshan pathmanathan on 5/30/22.
//

import UIKit

class ListDetailViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    
    var viewModel: ListDetailsViewModel? = nil
    
    public class var storyboardName: String {
        return "ListDetails"
    }
    
    static func create(viewModel: ListDetailsViewModel) -> ListDetailViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: ListDetailViewController.self)) as? ListDetailViewController
        viewController!.viewModel = viewModel
        return viewController!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageButton.setTitle("", for: .normal)
        nameLabel.text = viewModel?.name
        textView.text = viewModel?.description
        imageButton.setImage(UIImage(named: "like2"), for: .normal)
        setupButton()
        identifyLikedMovie()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupButton() {
        imageButton.layer.borderWidth = 1.0
        imageButton.layer.masksToBounds = false
        imageButton.layer.borderColor = UIColor.white.cgColor
        imageButton.layer.cornerRadius = imageButton.frame.size.width / 2
        imageButton.clipsToBounds = true
    }
    
    func identifyLikedMovie() {
        if let array = UserDefaults.standard.stringArray(forKey: "name") {
            if (array.contains(viewModel!.name)) {
                imageButton.backgroundColor = .red
            }else {
                imageButton.backgroundColor = .clear
            }
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        var array = [String]()
        array = UserDefaults.standard.stringArray(forKey: "name")!
        if !(array.contains(viewModel!.name)) {
            imageButton.backgroundColor = .red
            array.append(viewModel!.name)
            UserDefaults.standard.set(array, forKey: "name")
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        let vc = ListViewController.create(viewModel: ListViewModel())
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}
