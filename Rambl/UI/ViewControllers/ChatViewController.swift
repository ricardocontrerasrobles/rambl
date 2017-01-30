//
//  ChatViewController.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/28/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController
{
    @IBOutlet weak var table: UITableView!
    var viewModel: ChatViewModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func startRecording(_ sender: Any)
    {
        viewModel?.startRecording()
    }
    @IBAction func stopRecording(_ sender: Any)
    {
        viewModel?.stopRecording()
    }
    @IBAction func dismiss(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
}

extension ChatViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel?.numberOfChats() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let chatCell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        chatCell.textLabel?.text = viewModel?.textForChat(index: indexPath.row)
        return chatCell
    }
}

extension ChatViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        viewModel?.playChat(index: indexPath.row)
    }
}

private extension ChatViewController
{
    func setup()
    {
        viewModel?.updateChatList = { [weak self] in
            self?.table.reloadData()
        }
        
        viewModel?.audioPlayerStatus = { [weak self] (status) in
            switch status
            {
            case .Playing:
                print("todo")
            case .Loading:
                print("todo")
            case .Finished:
                print("todo")
            }
        }
    }
}

