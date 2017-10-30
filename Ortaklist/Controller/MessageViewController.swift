//
//  MessageViewController.swift
//  Ortaklist
//
//  Created by MacMini on 20.10.2017.
//  Copyright © 2017 Ortakfikir. All rights reserved.
//

import UIKit
import JSQMessagesViewController
class MessageViewController: JSQMessagesViewController {
    @IBOutlet weak var mesajBaslık: UIButton!
     var gorevId=""
     var message = [JSQMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mesajCek(urlString: "", gorevId: gorevId)
        inputToolbar.contentView.leftBarButtonItem = nil
        //collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
     //   collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mesajCek(urlString:String,gorevId:String)
    {
        let urlRequest = URL(string: urlString)
        var request = URLRequest(url: urlRequest! as URL)
        request.httpMethod = "POST"
        let parameters = ""
        
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil
            {
                print(error!)
            }
            else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
                    
                    if let jsonDic = json
                    {
                        for i in 0..<jsonDic.count
                        {
                            if let jsonVeri = jsonDic[i] as? NSDictionary
                            {
                                 let gelenMesajAd = jsonVeri[""] as? String
                                 let gelenUyeId = jsonVeri[""] as? String
                                 let gelenMesaj = jsonVeri[""] as? String
                                 if !(gelenMesaj?.isEmpty)!
                                 {
                                    DispatchQueue.main.async {
                                        if let message=JSQMessage(senderId: gelenUyeId, displayName: gelenMesajAd, text: gelenMesaj)
                                        {
                                            self.message.append(message)
                                            self.finishReceivingMessage()
                                            self.collectionView.reloadData()
                                        }
                                    }
                                    }
                               
   
                            }
                           
                        }
                        
                    }
              
                }
                catch{
                    print(error)
                }
                
            }
            
        })
        task.resume()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return message.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return message[indexPath.item]
    }
    
    lazy var outgoingBubble:JSQMessagesBubbleImage =
    {
        return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
    }()
    
    lazy var incomingBubble:JSQMessagesBubbleImage =
    {
        return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.gray)
    }()
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapCellAt indexPath: IndexPath!, touchLocation: CGPoint) {
        self.view.endEditing(true)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        return message[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named:"user"), diameter: 30)
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        //return message[indexPath.item].senderId == senderId ? nil : NSAttributedString(string:message[indexPath.item].senderDisplayName)
        
        
        return NSAttributedString(string:message[indexPath.item].senderDisplayName)
    }
   
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        //return message[indexPath.item].senderId == senderId ? 0 : 20
        return 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        self.message.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        collectionView.reloadData()
        messajKaydet(urlString:"",uyeID: senderId, gorevId: gorevId, mesaj: text)
        finishSendingMessage()
    }
    func messajKaydet(urlString:String,uyeID:String,gorevId:String,mesaj:String)
    {
        let urlRequest = URL(string: urlString)
        var request = URLRequest(url: urlRequest! as URL)
        request.httpMethod = "POST"
        let parameters = ""
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil
            {
                print(error!)
            }
            else {
                print("başarılı")
            }
          
        })
        task.resume()
    }
   

}
