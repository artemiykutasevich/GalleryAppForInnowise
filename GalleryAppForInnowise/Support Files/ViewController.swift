//
//  ViewController.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 30.03.24.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let provider: BaseProviderProtocol = BaseProvider() as BaseProviderProtocol
        provider.getPage(with: 0, completion: { [weak self] answer in
            switch answer {
            case .success(let success):
                print(success.count)
            case .failure(let failure):
                print(String(describing: failure))
            }
        })
    }
}

