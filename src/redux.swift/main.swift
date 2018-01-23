//
//  main.swift
//  redux.swift
//
//  Created by Xuyang Wang on 23/01/2018.
//  Copyright © 2018 Xuyang Wang. All rights reserved.
//

import Foundation

enum CounterAction {
    case inc(num: Int)
    case dec(num: Int)
}
typealias CounterState = Int

func counter(_ state: CounterState, _ action: CounterAction) -> CounterState {
    switch action {
    case .inc(let i):
        return state + i
    case .dec(let i):
        return state - i
    }
}

let store = Store(counter, preloadedState: 0)

func render() {
    let state = store.getState()
    print(state)
}
let unsubscribe = store.subscribe(listener: render)

store.dispatch(action: .inc(num: 1))
store.dispatch(action: .inc(num: 1))
store.dispatch(action: .inc(num: 2))
store.dispatch(action: .inc(num: 1))
store.dispatch(action: .dec(num: 1))
store.dispatch(action: .dec(num: 3))

unsubscribe()

store.dispatch(action: .inc(num: 3))
