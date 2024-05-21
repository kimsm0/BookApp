/**
 @class Array+Ex.swift
 @date 5/20/24
 @writer kimsoomin
 @brief
 @update history
 -
 */

import Foundation


public extension Array {
    //콜렉션, 리스트, 시퀀스 등 집합의 특정 member elements에 간단하게 접근할 수 있는 문법
    //추가적인 메소드 없이 특정 값을 할당하거나 가져올 수 있다.
    
    //collection 타입의 데이터에서 특정 요소에 간단하게 접근할 수 있는 문법.
    
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil //~= 연산자는 대상이 특정 범위에 속하는지 범위를 체크
    }
    
    mutating func removeElement(_ element: Element) {
        guard let objIndex = firstIndex(where: { $0 as AnyObject === element as AnyObject }) else {
            return
        }
        remove(at: objIndex)
    }
}

