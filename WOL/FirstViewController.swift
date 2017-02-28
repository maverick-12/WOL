//
//  FirstViewController.swift
//  WOL
//
//  Created by Roberto Fregiaro on 27/02/17.
//  Copyright © 2017 Marco Fregiaro. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    
    let host = "192.168.91.100"
    let port = 7
    var client: UDPClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client = UDPClient(address: host, port: Int32(port))
    }
    
    @IBAction func sendButtonAction() {
        guard let client = client else { return }
        
        switch client.connect(timeout: 10) {
        case .success:
            appendToTextField(string: "Connected to host \(client.address)")
            if let response = sendRequest(string: "GET / HTTP/1.0\n\n", using: client) {
                appendToTextField(string: "Response: \(response)")
            }
        case .failure(let error):
            appendToTextField(string: String(describing: error))
        }
    }
    
    private func sendRequest(string: String, using client: UDPClient) -> String? {
        appendToTextField(string: "Sending data ... ")
        
        switch client.send(string: string) {
        case .success:
            return readResponse(from: client)
        case .failure(let error):
            appendToTextField(string: String(describing: error))
            return nil
        }
    }
    
    private func readResponse(from client: UDPClient) -> String? {
        guard let response = client.read(1024*10) else { return nil }
        
        return String(bytes: response, encoding: .utf8)
    }
    
    private func appendToTextField(string: String) {
        print(string)
        textView.text = textView.text.appending("\n\(string)")
    }

    
    
    // ------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

