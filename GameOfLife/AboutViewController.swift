//
//  AboutViewController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 10.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit
import MessageUI


class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var sendMailBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendMailBtn.backgroundColor = .white
        sendMailBtn.setTitleColor(.orange, for: .normal)
        sendMailBtn.layer.cornerRadius = 10

    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["patrickniepel@web.de"])
        mailComposerVC.setSubject("Game Of Life")
        mailComposerVC.setMessageBody("The App is great! ;)", isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send the email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendMail(_ sender: UIButton) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
}
