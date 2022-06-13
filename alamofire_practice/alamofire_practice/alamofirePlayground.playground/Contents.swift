import Foundation
import UIKit
import Alamofire

// MARK: 구조체 선언 부분
struct multipartStruct: Codable {
    var title: String
    var number: Int
    
    init(title: String, number: Int){
        self.title = title
        self.number = number
    }
}


// MARK: 파라미터 선언 부분
// GetRequest와 PostRequest 함수용 parameter들
let multipartParam: [multipartStruct] = [
    multipartStruct(title: "title1", number: 1),
    multipartStruct(title: "title2", number: 2),
]

let parameters: [String: [String]] = [
    "foo": ["bar"],
    "baz": ["a", "b"],
    "qux": ["x", "y", "z"]
]


// MARK: 함수 선언 부분
func testGetRequest(url: URL) {
    AF.request(url).response { response in
        debugPrint(response)
    }
}

func testPostRequest(url: URL) {
    AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
        debugPrint(response)
    }
}


// MARK: 이미지 업로드 성공사례
let urlpath = Bundle.main.path(forResource: "IMG_5688", ofType: "JPG")
let url = URL(fileURLWithPath: urlpath!)

func testMultipartUpload(to: URL, url: URL) {

    let fileName = url.lastPathComponent
    guard let imageFile: Data = try? Data (contentsOf: url) else {return}
    AF.upload(multipartFormData: { (multipartFormData) in
        multipartFormData.append(imageFile, withName: "image", fileName: fileName, mimeType: "image/jpg")
    }, to: to)
    // MARK: responseJSON은 deprecated 될 위험 있기 떄문에
    // MARK: 아래의 responseData로 하는게 좋음!
    .responseJSON { (response) in
        debugPrint(response)
    }

}

testMultipartUpload(
    to: URL(string: "http://13.124.90.96:8080/api/v1/testing/image")!,
    url: url
)




// MARK: 오디오 업로드
let audioUrlpath = Bundle.main.path(forResource: "test1", ofType: "m4a")
let audioUrl = URL(fileURLWithPath: audioUrlpath!)

func testAudioUpload(to: URL, url: URL) {

    let audioName = url.lastPathComponent
    guard let audioFile: Data = try? Data(contentsOf: url) else { return }
    AF.upload(multipartFormData: { multipartFormData in

        multipartFormData.append(
            audioFile,
            withName: "voiceMail",
            fileName: audioName,
            mimeType: "audio/m4a"
        )

    }, to: to)
    .responseData { response in
        switch response.result {
            
        case .success(let data):
            let asJSON = try? JSONSerialization.jsonObject(with: data)
            print(asJSON!)
            
        case .failure(let error):
            print(error)
        }
    }
}

testAudioUpload(
    to: URL(string: "http://13.124.90.96:8080/api/v1/gifts/voicemail")!,
    url: audioUrl
)
