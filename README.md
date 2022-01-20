## 신용카드 추천 리스트 만들기
> Firebase Realtime Database 사용하기

### 1) 구현기능
- Firebase Realtime DB 사용하여 데이터 Retrieve

### 2) 기본 개념

#### (1) Database
- 데이터의 집합체
- 일반적으로 관계형 데이터베이스 형태

#### (2) Firebase Realtime Database
- NOSQL
- 비관계형 클라우드 데이터베이스
- 대량 데이터 수집 관리에 적합
- 하나의 큰 JSON 트리
    - 최대 32 단계 데이터 중첩 허용
    - 데이터 평면화 권장
    - 쿼리 성능 때문에
- 실시간 작동 (HTTP 요청 아님)
- 오프라인
    - 로컬에 저장 후 네트워크 연결 시 동기화
- 서버없이 데이터베이스와 클라이언트 직접 액세스
- 정렬 || 필터
- 깊고 좁은 쿼리 (하위 json에 접근 가능)

<img src=“https://www.ficode.co.uk/wp-content/uploads/2020/01/firebaseblog.png”>

##### datatype
- String
- Number (Int,float,double)
- Dictionary
- Array
-json data를 upload 할 수도 있다.

##### 용어 정리

1. DatabaseReference
> https://firebase.google.com/docs/reference/swift/firebasedatabase/api/reference/Classes?authuser=0#databasereference
> https://firebase.google.com/docs/database/ios/read-and-write?hl=ko
DatabaseRefrence represents a particular location in your Firebase Database and can be used for reading or writing or writing data to that Firebase Database location.
This class is the starting point for all Firebase Database operations.

2. DataSnapshot
> https://firebase.google.com/docs/reference/swift/firebasedatabase/api/reference/Classes?authuser=0#datasnapshot

DataSnapshot contains data from a Firebase Database location.
Any time you read Firebase data, you receive the data as a FIRDataSnapshot.
They are efficiently-generated immutable copies of the data at a Firebase Database location.
*They can’t be modified and will never change*
To modify data at a location, user a FIRDatabaseReference.

FIRDataSnapshot은 NSDictionary와 같은 적절한 네이티브 유형에 할당할 수 있다.

```swift
refHandle = postRef.observe(DataEventType.value, with: { snapshot in
  // ...
})
```
리스너는 이벤트 발생 시점에 데이터베이스에서 지정된 위치에 있는 데이터를 포함한 *FIRDataSnapshot*을
*value* 속성에 수신합니다. 이 값을 NSDictionary 같은 네이티브 유형에 할당할 수 있고
해당 위치에 데이터가 없으면 value는 nil

3. Query 
- queryOrderedByChild: 지정된 하위 키 또는 중첩된 하위 경로의 값에 따라 결과를 정렬
-  queryEqualTovalue: 선택한 정렬 기준 메서드에 따라 지정된 키 또는 값과 동일한 항목을 반환

```swift
// 쿼리문을 통해 특정
        ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {
            [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: [String:Any]],
                  let key = value.keys.first else { return }
            self.ref.child("\(key)/isSelected").setValue(true)
        }
})


#### (3) Cloud Firestore
- 비관계형 클라우드 데이터 베이스
- 실시간 동기화 
- 오프라인
- 서버Less
- 고급 쿼리 지원
- 문서와 컬렉션 조합
- 정렬 && 필터
- 얇고 넓은 쿼리 (하위 문서, 컬렉션 접근 X)

##### datatype
- JSON encoding이 가능한 swift 객체를 바로 업로드할 수 있다.

##### 용어 정리

1. DocumentSnapshot

A FIRDocumentSnapshot contains at a read from a document in your Firestore database.
The data can be extracted with the data property or by using subscript syntax to access a specific field.
For a FIRDocumentSnapshot that points to a non-existing document,
Any data access will return nil.
You can use the exists property to explicitly verify a documents existence

2. FIRDocumentReference
It refers to a document location in a Firestore database and can be used to *write/read/listen to the location*
The document at the referenced location may or may not exist.
    -Writing Data
        -setData()
        -updateData()
        -delete()

```swift

db.collection("cities").document("SF")
    .addSnapshotListener { documentSnapshot, error in
      guard let document = documentSnapshot else {
        print("Error fetching document: \(error!)")
        return
      }
      guard let data = document.data() else {
        print("Document data was empty.")
        return
      }
      print("Current data: \(data)")
    }


db.collection("cities").whereField("capital", isEqualTo: true)
    .getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
            }
        }
}



```

=> 유리한 데이터 모델이 다르므로 취사선택 

||RealtimeDatabase|CloudFireStore|
||기본적인 데이터 동기화|고급쿼리, 정렬,트랜젝션|
||적은양의 데이터가 자주 변경|대용량 데이터가 자주 읽힘|
||간단한 JSON 트리|구조화된 컬렉션|
||많은 데이터베이스|단일 데이터 베이스|

https://firebase.google.com/docs/firestore/rtdb-vs-firestore?hl=ko

#### (3) Kingfisher
이미지 관리를 더욱 편하게 
https://github.com/onevcat/Kingfisher
이미지를 로컬이나 서버에 저장해서 가져오는 것이 아니라 웹 이미지의 url 사용

#### (4) Lottie
https://airbnb.io/lottie/#/ios?id=installing-lottie
an open source animation file format that’s tiny, high quality, interactive, and can be manipulated at runtime

- json으로 되어 있는 움직이는 이미지를 해석하여 view 로 만들어준다
```swift
let animationView = AnimationView(name: "money")
        lottieView.contentMode = .scaleAspectFit
        lottieView.addSubview(animationView)
        animationView.frame = lottieView.bounds
        animationView.loopMode = .loop
        animationView.play()
```

### 3) 새롭게 알게 된 것

- 기본 UIViewController 와 UITableViewController 에는 무슨 차이가 있을까?
    - UITableViewController 는 별도의 datasorce, delegate 선언을 필요로 하지 않는다
    - Rootview 로 UITableView를 가진다.

- provisioning profile vs certificate?
    - certificate is included in provisioning profile
    - 

- 클라이언트 객체
    - 백엔드 data, 화면 data 를 고려해 모델링
    
- 프로토 타입 셀을 커스텀하면서 Xib 파일을 함께 생성한 이유?
    -Xib 파일에서 UI를 구성할 수 있기 때문 

- 커스텀한 table view cell 을 register 
    - registers a class to use in creating new table cells
    - prior to dequeueing any cells, call this method to tell the table view how to create new cells.
    - if a cell of the specified type is not currently in a reuse queue, the table view uses the provided information to create a new cell object automatically

```swift

let nibName = UINib(nibName: "CardListCell", bundle: nil)
tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
```

- 나는 단일 section 을 생성하고 있지만, 만약 multiple sections 라면? numberofTowsInSection은 어떻게 사용할까?
```swift
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        If section == 0 {
            return array1.count
        } else if section == 1 {
        // …
        }
    }
```
https://letcreateanapp.com/2021/04/15/how-to-create-uitableview-with-sections-in-swift-5/

- present vs push 
    - present: modal 로 세로 뷰 전개
        + 연속적인 화면의 뷰 보다는 유저 흐름을 깨는 뷰를 띄우기에 적당
        + dismiss
        + UIViewController 의 메소드
    - push: 가로로 뷰 전개
        + pop
        + UINavigationController의 메소드
    - https://unnnyong.me/2019/02/17/ios-present-vs-push/
    - 한편 push 와 show 의 차이는?
        + pushes vc onto the navigation stack in a similar way as the pushViewController method
        + you can call this method directly if you want
        + but typically this method is called from elsewhere in the view controller hierarchy when a new view controller needs to be shown.
        + view hierarchy를 무시하고 view 를 불러올 수 있는 모양이다
        + the show segue uses this method to display a new view controller

https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621872-show

- JSONSerialization
    - to convert JSON to Foundation Objects
    - to convert Foundation objects to JSON
    - data(withJSONObject:options:)
        - returns JSON data from a Foundation object

- Dictionary.values
    - A collection containing just the values of the dictionary
- Dictionary.keys
    - A collection containing just the keys of the dictionary
    - .first : the first element of the collection

-Array.sorted(by:)
    - returns the elements of the sequence, sorted using the given predicate as the comparison between elements
    - when you want to sort a sequence of elements that dons’t conform to the Comparable protocol
    - pass a predicate to this method that returns true when the first element should be ordered before the second
    - you also use this method to sort elements that conform to the Comparable protocol in descending order

    ```swift
func sorted(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> [Element]

enum HTTPResponse {
    case ok
    case error(Int)
}

let responses: [HTTPResponse] = [.error(500), .ok, .ok, .error(404), .error(403)]
let sortedResponses = responses.sorted {
    switch ($0, $1) {
    // Order errors by code
    case let (.error(aCode), .error(bCode)):
        return aCode < bCode

    // All successes are equivalent, so none is before any other
    case (.ok, .ok): return false

    // Order errors before successes
    case (.error, .ok): return true
    case (.ok, .error): return false
    }
}
print(sortedResponses)
// Prints "[.error(403), .error(404), .error(500), .ok, .ok]"


let students: Set = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
let descendingStudents = students.sorted(by: >)
print(descendingStudents)
// Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"

```

- pod install 중 could not find compatible versions for pod 
    - pod update 한다

- cardlist dummy 를 build 하던 중 precede argument~ 와 관련한 에러 메시지를 만남
    - struct 는 생성자를 내가 작성한 멤버 변수의 순서 그대로 만드나 봄
    - 데이터와 내 CreditCard prop의 작성 순서가 달라서 생긴 오류였음
    
