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
//        let provider = BaseProvider()
//        pageDownloading(provider: provider) { [weak self] result in
//            guard let self else { return }
//            switch result {
//            case .success(let page):
//                imagesDownloading(provider: provider, page: page)
//            case .failure(let error):
//                break
//            }
//        }
    }

    private func pageDownloading(provider: UnsplashProviderProtocol, completion: @escaping (Result<UnsplasPage, InternalError>) -> Void) {
        debugPrint("▶️ Page downloading start")
        let timer = BenchTimer()
        provider.getPage(with: 0, completion: { pageResult in
            debugPrint("⏸️ Page downloading end in: \(timer.stop())")
            completion(pageResult)
        })
    }

    private func imagesDownloading(provider: ImageDownloadProviderProtocol, page: UnsplasPage) {
        let dispatchGroup = DispatchGroup()
        debugPrint("▶️ Image downloading start")
        let timer = BenchTimer()
        page.forEach({ pageItem in
            dispatchGroup.enter()
            DispatchQueue.main.async {
                provider.downloadImage(fromURL: pageItem.urls.small) { pageResult in
                    switch pageResult {
                    case .success(_):
                        debugPrint("✅ image download success")
                    case .failure(let error):
                        debugPrint("❌ image download error: \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
        })
        dispatchGroup.notify(queue: .main) {
            debugPrint("⏸️ Image downloading end in: \(timer.stop())")
        }
    }
}
