/**
 @class String+Ex
 @date 5/20/24
 @writer kimsoomin
 @brief
 @update history
 -
 */
import Foundation

public extension String {
    func toDate(formatType: DateFormatType) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.format
        dateFormatter.locale = Locale(identifier: "ko")
        if let date = dateFormatter.date(from: self) {
            return date
        }        
        return nil
    }
    
    func changeFormat(formatType: DateFormatType) -> String{
        // DateFormatter 생성
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatType.defaultFullWithTZType.format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        // UTC 시간 문자열을 Date로 변환
        guard let utcDate = dateFormatter.date(from: self) else {            
            return self
        }

        // 한국 시간대로 변환
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = formatType.format
        let koreanTimeString = dateFormatter.string(from: utcDate)

        return koreanTimeString
    }
}
