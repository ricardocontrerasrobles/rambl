//
//  Router.swift
//  Rambl
//
//  Created by Ricardo Contreras on 7/2/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import UIKit

struct Router
{
    private enum Route: String
    {
        case ramblChat = "goToRamblChat"
        case settings = "goToSettings"
    }
    
    func prepare(for segue: UIStoryboardSegue)
    {
        guard let identifier = segue.identifier,
            let toController = segue.destination as? BaseViewController,
            let fromController = segue.source as? BaseViewController,
            let baseViewModel = fromController.getBaseViewModel() else
        {
            return
        }
        switch identifier
        {
        case Route.ramblChat.rawValue:
            prepareRamblChat(toController: toController, fromViewModel: baseViewModel)
        case Route.settings.rawValue:
            prepareSettings(toController: toController, fromViewModel: baseViewModel)
        default:
            return
        }
    }
}

private extension Router
{
    func prepareRamblChat(toController: BaseViewController, fromViewModel: BaseViewModel)
    {
        guard let toController = toController as? ChatViewController,
            let fromViewModel = fromViewModel as? MainViewModel else
        {
            return
        }
        toController.viewModel = fromViewModel.getRamblChatViewModel()
    }
    
    func prepareSettings(toController: BaseViewController, fromViewModel: BaseViewModel)
    {
        guard let toController = toController as? SettingsViewController,
            let fromViewModel = fromViewModel as? MainViewModel else
        {
            return
        }
        toController.viewModel = fromViewModel.getSettingsViewModel()
    }
}
