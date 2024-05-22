/**
 @class
 @date
 @writer kimsoomin
 @brief
 @update history
 -
 */

import Foundation
import ArchitectureModule

final class AppComponent: DependencyBox<EmptyDependency>, AppRootDependency,AppRootTestDependency {
  
  init() {
    super.init(dependency: EmptyDependencyBox())
  }
  
}
