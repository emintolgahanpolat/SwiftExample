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
        view.backgroundColor = .lightGray
        view.cornerRadius(radius: 12)
        return view
    }()
    
    
    private lazy var containerScrollView :UIScrollView = {
        var view = UIScrollView()
        view.bounces = false
        view.verticalScrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: -3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    private lazy var containerStackView :UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution  = UIStackView.Distribution.fill
        view.alignment = UIStackView.Alignment.fill
        view.spacing   =  0.5
        view.axis  = NSLayoutConstraint.Axis.vertical
        return view
    }()
    
    
    private lazy var contentStackView :UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution  = UIStackView.Distribution.fill
        view.alignment = UIStackView.Alignment.fill
        view.spacing   = 20.0
        view.axis  = NSLayoutConstraint.Axis.vertical
        return view
    }()
    
    private lazy var contentView :UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    
    
    private lazy var btnStackView :UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution  = UIStackView.Distribution.fillEqually
        view.alignment = UIStackView.Alignment.fill
        view.spacing   = 0.5
        return view
    }()
    
    
    
    
    lazy var imageView:UIImageView = {
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(popUpView)
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.configure()
        
        if isCancelable{
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
            NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        }
        
        
    }
    
    @objc func dismissAlert(){
        
        self.dismiss(animated: true, completion: nil)
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
                myBtn.translatesAutoresizingMaskIntoConstraints = false
                myBtn.heightAnchor.constraint(equalToConstant: 46).isActive=true
                myBtn.setTitle(alertAction.title, for: .normal)
                myBtn.backgroundColor = .white
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
        containerScrollView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(contentView)
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        containerStackView.addArrangedSubview(btnStackView)
        
        
        let h1 = popUpView.heightAnchor.constraint(equalTo: containerStackView.heightAnchor)
        h1.priority = .defaultLow
        h1.isActive = true
        
        popUpView.widthAnchor.constraint(equalTo:  self.view.widthAnchor,multiplier: 0.72).isActive = true
        popUpView.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor,multiplier: 0.72).isActive = true
        popUpView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        popUpView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
        
        containerScrollView.topAnchor.constraint(equalTo: popUpView.topAnchor).isActive = true
        containerScrollView.widthAnchor.constraint(equalTo: popUpView.widthAnchor).isActive = true
        containerScrollView.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        containerScrollView.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor).isActive = true
        
        
        
        containerStackView.topAnchor.constraint(equalTo: containerScrollView.topAnchor).isActive = true
        containerStackView.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor).isActive = true
        containerStackView.centerXAnchor.constraint(equalTo: containerScrollView.centerXAnchor).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor).isActive = true
        
        
        
        contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        contentStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 0.9).isActive = true
        contentStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -20).isActive = true
        
        if icon != nil {
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        }
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


