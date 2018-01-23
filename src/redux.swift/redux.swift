//
//  redux.swift
//  redux.swift
//
//  Created by Xuyang Wang on 23/01/2018.
//  Copyright © 2018 Xuyang Wang. All rights reserved.
//

import Foundation

typealias Reducer<S, A> = (_ state: S, _ action: A) -> S
typealias Listener = () -> Void

class Store<S, A> {
    var currentReducer: Reducer<S, A>
    var currentState: S
    var currentListeners: [Int:Listener]
    var nextListeners: [Int:Listener]
    var isDispatching: Bool
    
    init(_ reducer: @escaping Reducer<S, A>, preloadedState: S){
        currentReducer = reducer
        currentState = preloadedState
        currentListeners = [:]
        nextListeners = currentListeners
        isDispatching = false
    }
    
    func getState() -> S {
        guard !isDispatching else {
            fatalError(
                "You may not call store.getState() while the reducer is executing. " +
                    "The reducer has already received the state as an argument. " +
                "Pass it down from the top reducer instead of reading it from the store."
            )
        }
        return currentState
    }
    
    func subscribe(listener: @escaping Listener) -> () -> Void {
        guard !isDispatching else {
            fatalError(
                "You may not call store.subscribe() while the reducer is executing. " +
                    "If you would like to be notified after the store has been updated, subscribe from a " +
                "component and invoke store.getState() in the callback to access the latest state. "
            )
        }
        
        var isSubscribed = true
        
        let key = Int(arc4random_uniform(UInt32(6)))
        nextListeners.updateValue(listener, forKey: key)
        
        return {
            guard isSubscribed else { return }
            guard !self.isDispatching else {
                fatalError("You may not unsubscribe from a store listener while the reducer is executing. ")
            }
            
            isSubscribed = false
            
            self.nextListeners.removeValue(forKey: key)
        }
    }
    
    func dispatch(action: A) -> A {
        guard !isDispatching else {
            fatalError("Reducers may not dispatch actions.")
        }
        
        isDispatching = true
        currentState = currentReducer(currentState, action)
        isDispatching = false
        
        currentListeners = nextListeners
        for listener in currentListeners.values {
            listener()
        }
        
        return action
    }
    
}
