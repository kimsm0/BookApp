# BookApp
🍏 구조
Router, Interactor, Builder, Presenter로 구성된 모듈을 사용하였습니다. 
서드파티 없이 해당 모듈을 직접 구현, ArchitectureModule로 추가하였습니다. 
깃허브에 추가된 파일들을 Xcode File Template에 추가하면, 파일 추가시 템플릿화된 모듈 파일들을 추가할 수 있습니다. 

Router: 리블렛간의 이동을 담당합니다. 
Interactor: 리블렛의 비지니스 로직을 담당합니다. 
Presenter: UI 입니다. 
Builder: 리블렛의 컴포넌트 초기화를 담당합니다. 


🍏 모듈화 
1. Book 패키지 
- 책을 검색할 수 있는 BookSearch 리블렛과 상세화면을 담당하고 있는 BookDetail 리블렛이 있습니다.
- BookSearch, BookDetail 두개의 feature 리블렛을 Test할 때 사용할, BookTestSupport 모듈과, 네트워크 계층을 담당하는 BookRepository, 리블렛에서 사용되는 데이터 모델인 BookDataModel 모듈로 구성되어 있습니다. 

2. Platform 패키지
- 공통으로 사용되는 Extensions, Utils, CustomUI 등으로 구성되어 있습니다.  


🍏 비동기/선언적 프로그래밍
- 비동기 프로그래밍을 위해 Combine 사용하였으며, 
send를 Wrapping한 Custom Publisher 클래스와, UI컴포넌트의 이벤트를 비동기 처리하는데 Combine을 사용하기 위해 UIControl을 확장하여 커스텀한 GesturePublisher를 사용하습니다. 

 
🍏 구조 

💡 
- BookSearch 
- AppRoot리블렛에서 BookSearch을 하위로 attach 하여 시작됩니다. RootBuilder에서 BookSearch 리블렛에서 필요한 repository를 주입받습니다.
- BookSearch 화면에서 cell을 탭하면 BookDetail을 child 로 attach합니다. 
- BookDetail에서는 API 통신을 위한 repository를 주입받고, 선택한 항목의 id(isbn13)를 build메소드로 전달합니다.
- BookDetail 상세화면에서는 하단 PDF보기, 더보기 버튼을 탭하면 WebView 리블렛을 child 로 attach합니다. 
- WebView 리블렛은 WebViewType 데이터를 전달 받으며, 이 데이터에는 url과, 네비게이션 타이틀을 위한 정보가 담겨있습니다.

👉 SceneDelegate에서 UITESTING Config일 경우에는, BookTestDouble의 testMode에 맞는 리블렛을 바로 연결하기 위해, AppRootTest 리블렛으로 연결되어 있습니다.


💡 
- Repository
- Network Request를 진행한다. 
- 이미지 로드를 위한 ImageCacheService를 주입받습니다. (테스트 진행시에는 ImageCacheServiceMock 클래스를 주입하면, 시스템 이미지를 리턴합니다. )
- ImageCacheService에서는 전달받은 url을 key값으로 사용하여 캐싱처리를 합니다. 메모리 캐시를 먼저 확인 후 이미지가 없다면 디스크 캐시를 확인합니다. 디스크캐시는 파일 매니저를 이용하여 저장하였습니다. 디스크캐시에서도 이미지가 없을 경우에만 다운로드를 진행하며 완료 후에는 메모리/디스크 캐시에 모두 저장합니다. 


💡 
- Entity: 프로젝트 내부에서 사용될 데이터 모델입니다. (DTO를 기반으로 생성)
- DTO: 외부에서 전달 받은 데이터 모델입니다.
- 외부 데이터 모델의 영향도를 줄이기 위해 데이터 모델 구분하였습니다. 

⚡️Trouble Shooting 

BookSearch 화면에서 상단 SearchView에 shadow 효과를 넣었는데 Optimization Opportunities warnning이 발생하였습니다. 
렌더링 비용이 많이들고 있어, shadowPath를 설정하여 그림자 경로를 명시적으로 지정,그림자를 동적으로 계산하지 않도록 하여 렌더링 성능을 개선할 수 있습니다. 


💡 TEST
- UI Test는 UITESTING Config를 추가하여, baseURL을 local로 변경,
AppURLProtocol 클래스를 통해 Mock Data를 리턴하도록 되어있습니다.  
고정된 데이터 값을 통해, 외부로 부터 분리하여 항상 일관된 테스트 결과를 리턴할 수 있도록 구현하였다. 

- UI/ Unit TEST 진행시 공통으로 사용될 수 있는 Mock Data의 경우 BookTestDouble로 생성하여 항상 고정된 값을 리턴합니다.
- Test Target에서는 Unit Test 진행시에 필요한 router, presenter, depengency 등을 mock 데이터로 구성되어 있습니다. 다른 외부 값을 고정시켰을 때, 비지니스 로직을 담당하고 있는 interator의 로직을 확인, 항상 동일한 결과가 도출되는지 체크합니다. 
- API를 호출하는 repository의 경우, 공통으로 사용하기에 각 리블렛의 테스트 타겟이 아닌 BookTestSupport 모듈 안에 포함되어 있습니다. 


🍏 Test
- Scheme을 Test 하고자 하는 모듈로 변경 후 Test 진행하시면 됩니다. (Command + U)
- BookTestDouble에 정의된 testMode를 변경하여 원하는 리블렛을 Root에 바로 attach하여 빠르게 확인할 수 있습니다. 

🍎 Test Data
- 책을 검색하였을 때, pdf 데이터가 없는 경우가 많이 있는것으로 확인됩니다. pdf 데이터를 확인하시고자 한다면 
isbn13 값인 9781617294136 또는 Securing DevOps 으로 검색을 진행하시면 상세화면에서 pdf를 확인하실 수 있습니다.


