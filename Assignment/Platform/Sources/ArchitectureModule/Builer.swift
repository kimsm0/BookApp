
/**
 @class Builder
 @date 24.5.20
 @writer kimsoomin
 @brief
 - 초기화에서 로직 진행에 필요한 dependency를 주입받는다.
 - 리블렛의 모든 구성요소들의 초기화를 진행한다.
 - 리블렛의 Buildable 프로토콜에 build함수를 정의하고, 해당 build 함수를 통해 Presentable 리턴하는 구조를 갖는다.
 @update history
 -
 */
public protocol Buildable: AnyObject { }

open class Builder<DependencyType>: Buildable {
    
    public let dependency: DependencyType
    
    public init(dependency: DependencyType) {
        self.dependency = dependency
    }
}
