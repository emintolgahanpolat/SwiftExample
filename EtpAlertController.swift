//
//  EtpAlertController.swift
//  EtpKit
//
//  Created by Emin Tolgahan Polat on 29.03.2020.
//  Copyright © 2020 Emin Tolgahan Polat. All rights reserved.
//

import UIKit

class EtpAlertController: UIViewController {
    
    var icon: UIImage?
    var message: String?
    var isCancelable:Bool = true
    var preferredStyle: UIAlertController.Style?
    var actions : [EtpAlertAction] = []
    
    
    private lazy var popUpView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.cornerRadius(radius: 12)
        return view
    }()
    
    private lazy var imageView:UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = icon
        return view
        
    }()
    
    private lazy var titleLabel:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.text = self.title
        lbl.textAlignment = .center
        lbl.font = .boldSystemFont(ofSize: 17)
        return lbl
    }()
    private lazy var descriptionLabel:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.text = self.message
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 17)
        return lbl
    }()
    
    
    private lazy var containerScrollView :UIScrollView = {
        var view = UIScrollView()
        view.bounces = false
        view.verticalScrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: -3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentView :UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    private lazy var btnStackView :UIStackView = {
        var view = UIStackView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution  = UIStackView.Distribution.fillEqually
        view.alignment = UIStackView.Alignment.fill
        view.spacing   = 1.0
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(popUpView)
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.configure()
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    @objc func dismissAlert(){
        if isCancelable{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func rotated() {
        configure()
    }
    
    
    func addAction(_ action:EtpAlertAction){
        actions.append(action)
        initButtons()
    }
    
    private func initButtons(){
        btnStackView.subviews.forEach{subV in
            subV.removeFromSuperview()
        }
        if !actions.isEmpty {
            for (index, alertAction) in actions.enumerated() {
                let myBtn = UIButton()
                myBtn.setTitle(alertAction.title, for: .normal)
                if alertAction.style == .default{
                    myBtn.setTitleColor(.orange, for: .normal)
                }else{
                    myBtn.setTitleColor(.gray, for: .normal)
                }
                myBtn.titleLabel?.font = .boldSystemFont(ofSize: 17)
                myBtn.tag = index
                
                myBtn.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
                btnStackView.addArrangedSubview(myBtn)
            }
            if actions.count > 2 {
                btnStackView.axis  = NSLayoutConstraint.Axis.vertical
            }else {
                btnStackView.axis  = NSLayoutConstraint.Axis.horizontal
            }
        }
        
        
        
        
        
        
    }
    
    @objc func buttonClicked(sender:UIButton){
        self.actions[sender.tag].handler?()
        dismissAlert()
    }
    
    private func configure(){
        
        
        self.view.addSubview(popUpView)
        
        popUpView.addSubview(containerScrollView)
        containerScrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(btnStackView)
        
        
        popUpView.widthAnchor.constraint(equalTo:  self.view.widthAnchor,multiplier: 0.72).isActive = true
        //popUpView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        //popUpView.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor,multiplier: 0.72).isActive = true
        popUpView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        popUpView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
        popUpView.heightAnchor.constraint(lessThanOrEqualToConstant: 700).isActive=true
        
        popUpView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        
        containerScrollView.topAnchor.constraint(equalTo: popUpView.topAnchor).isActive = true
        containerScrollView.widthAnchor.constraint(equalTo: popUpView.widthAnchor).isActive = true
        containerScrollView.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        containerScrollView.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor).isActive = true
        
        
        
        contentView.topAnchor.constraint(equalTo: containerScrollView.topAnchor,constant: 20).isActive = true
        contentView.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: containerScrollView.centerXAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor,constant: -20).isActive = true
        
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        if icon != nil {
            imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }
        
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        // imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 0.9).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        //titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 20).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 0.9).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        //descriptionLabel.bottomAnchor.constraint(equalTo: btnStackView.bottomAnchor).isActive = true
        
        
        btnStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
        btnStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        btnStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        btnStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        
        initButtons()
    }
    
    
    
    
}



extension EtpAlertController{
    convenience init(icon:UIImage?,title: String? , message: String?,preferredStyle: UIAlertController.Style) {
        self.init()
        super.modalPresentationStyle  = .overCurrentContext
        super.modalTransitionStyle = .crossDissolve
        self.icon = icon
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
        
    }
}

class EtpAlertAction  {
    init(title: String?, style: EtpAlertAction.Style, handler: (() -> Void)? = nil){
        self.title = title
        self.style = style
        self.handler = handler
    }
    var handler:(() -> Void)? = nil
    var title: String?
    var style: EtpAlertAction.Style!
}

extension EtpAlertAction {
    public enum Style : Int {
        case `default`
        case cancel
        case destructive
    }
}

private extension UIView{
    func cornerRadius(radius:CGFloat){
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}


