//
//  BaseViewModel.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 11.10.2023.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    
    let isLoad = BehaviorRelay<Bool>.init(value: false)
    let disposeBag = DisposeBag()
    
}
