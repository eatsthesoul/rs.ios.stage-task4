import Foundation

final class CallStation {
    
    private var usersArray = [User]()
    private var callsArray = [Call]()
}

extension CallStation: Station {
    
    func users() -> [User] {
        usersArray
    }
    
    func add(user: User) {
        if !usersArray.contains(user) { usersArray.append(user) }
    }
    
    func remove(user: User) {
        if usersArray.contains(user) { usersArray.remove(at: usersArray.firstIndex(of: user)!) }
    }
    
    func execute(action: CallAction) -> CallID? {
        
        switch action {
        
        case let .start(from: user1, to: user2):
            
            //users base don't contain both of users
            if !usersArray.contains(user1) && !usersArray.contains(user2) { return nil }
            
            //users base don't contain one of users
            if !usersArray.contains(user1) || !usersArray.contains(user2) {
                let call = Call(id: UUID(), incomingUser: user1, outgoingUser: user2, status: .ended(reason: .error))
                callsArray.append(call)
                return call.id
            }
            
            //check whether the receiver is talking now
            if currentCall(user: user2) != nil {
                let call = Call(id: UUID(), incomingUser: user1, outgoingUser: user2, status: .ended(reason: .userBusy))
                callsArray.append(call)
                return call.id
            }
            
            //the best way
            let call = Call(id: UUID(), incomingUser: user1, outgoingUser: user2, status: .calling)
            callsArray.append(call)
            return call.id

        case let .answer(from: user):
            
            if usersArray.contains(user) {
                for (index, call) in callsArray.enumerated() {
                    if call.outgoingUser == user && call.status == .calling {
                        let talkingCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .talk)
                        callsArray.remove(at: index)
                        callsArray.append(talkingCall)
                        return talkingCall.id
                    }
                }
            }
            
            //case when user will be removed during the call
            for (index, call) in callsArray.enumerated() {
                
                if call.outgoingUser == user || call.incomingUser == user {
                        let errorCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .error))
                        callsArray.remove(at: index)
                        callsArray.append(errorCall)
                    }
            }
            
            return nil
            
        case let .end(from: user):
            
            for (index, call) in callsArray.enumerated() {
                
                if call.outgoingUser == user || call.incomingUser == user {
                    if call.status == .calling {
                        let cancelCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .cancel))
                        callsArray.remove(at: index)
                        callsArray.append(cancelCall)
                        return cancelCall.id
                    }
                    
                    if call.status == .talk {
                        let endedCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .end))
                        callsArray.remove(at: index)
                        callsArray.append(endedCall)
                        return endedCall.id
                    }
                }
            }
            return nil
        }
    }
    
    func calls() -> [Call] {
        callsArray
    }
    
    func calls(user: User) -> [Call] {
        
        var userCalls = [Call]()
        
        for call in callsArray {
            if call.incomingUser == user || call.outgoingUser == user { userCalls.append(call) }
        }
        return userCalls
    }
    
    func call(id: CallID) -> Call? {
        for call in callsArray {
            if call.id == id { return call }
        }
        return nil
    }
    
    func currentCall(user: User) -> Call? {
        for call in callsArray {
            if (call.incomingUser == user || call.outgoingUser == user) && (call.status == .calling || call.status == .talk) {
                return call
            }
        }
        return nil
    }
}

