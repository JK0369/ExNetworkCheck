//
//  NetworkStatus.swift
//  ExNetwork
//
//  Created by 김종권 on 2023/04/04.
//

import Alamofire
import RxSwift
import Foundation

enum NetworkStatusType {
    case disconnect
    case connect
    case unknown
}

// NSObject가 없으면 extension Reactive를 해도 rx 네임스페이스 사용 불가
final class NetworkStatus: NSObject {
    static let shared = NetworkStatus()
    fileprivate let behaviorPublish = BehaviorSubject<NetworkStatusType>(value: .connect)

    var statusObservable: Observable<NetworkStatusType> {
        behaviorPublish
            .debug()
    }
    
    private override init() {
        super.init()
        observeReachability()
    }
    
    private func observeReachability() {
        let reachability = NetworkReachabilityManager()
        reachability?.startListening(onUpdatePerforming: { [weak behaviorPublish] status in
            switch status {
            case .notReachable:
                behaviorPublish?.onNext(.disconnect)
            case
                .reachable(.ethernetOrWiFi),
                .reachable(.cellular)
            :
                behaviorPublish?.onNext(.connect)
            case .unknown :
                behaviorPublish?.onNext(.unknown)
            }
        })
    }
}

// MARK: NetworkStatus+Rx
extension Reactive where Base: NetworkStatus {
    var isNetworkConnected: Observable<Bool> {
        let status = (try? base.behaviorPublish.value()) ?? .unknown
        guard case .connect = status else { return .just(false) }
        return .just(true)
    }
}
