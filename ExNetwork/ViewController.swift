//
//  ViewController.swift
//  ExNetwork
//
//  Created by 김종권 on 2023/04/04.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NetworkStatus.shared.statusObservable
//            .subscribe(onNext: {
//                print($0)
//            })
//            .disposed(by: disposeBag)
        
        NetworkStatus.shared.rx.isNetworkConnected
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}
