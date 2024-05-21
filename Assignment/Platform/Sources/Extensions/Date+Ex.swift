/**
 @class Date+Ex
 @date 5/20/24
 @writer kimsoomin
 @brief Date Extension 파일
 @update history
 -
 */
import Foundation


public extension Date {
    
    /**
     @brief 매개변수로 전달받은 포맷으로 변환, 문자열로 리턴.
     - locale: 디바이스 설정의 언어, 지역 정보를 담고 있음.
     @param
     - format: DateFormatType enum으로 전달받아 format 프로퍼티를 이용해 string 적용.
     - 기본값:  defaultFullWithTZType = yyyy-MM-dd'T'HH:mm:ss.SSS'Z
     @return
     - 매개변수의 포맷으로 변환된 Date를 String 타입으로 리턴.
     */
    func convertToString(formatType: DateFormatType = .defaultFullWithTZType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.format
        dateFormatter.locale = Locale(identifier: "ko")
        return dateFormatter.string(from: self)
    }
}

public enum DateFormatType {
    
    public enum DateType {
        case dot
        case slash
        case simple
        case hyphen
        
        var format: String {
            switch self {
            case .dot:
                return "yyyy.MM.dd"
            case .slash:
                return "yyyy/MM/dd"
            case .simple:
                return "MM. dd."
            case .hyphen:
                return "yyyy-MM-dd"
            }
        }
    }
    
    public enum TimeType {
        case half
        case full
        case half24
        case full24
               
        var format: String {
            switch self {
            case .half:
                return "h:s:m"
            case .full:
                return "hh:mm:ss"
            case .half24:
                return "H:m:s"
            case .full24:
                return "HH:mm:ss"
            }
        }
    }
    
    case total(date: DateType, time: TimeType)
    case totalWithWeekDay(date: DateType, time: TimeType)
    case defaultFullWithTZType
    case date(date: DateType)
    case time(time: TimeType)
    
    var format: String {
        switch self {
        case let .total(dateType, timeType):
            return "\(dateType.format) \(timeType.format)"
        case let .totalWithWeekDay(dateType, timeType):
            return "\(dateType.format) E \(timeType.format)"
        case .defaultFullWithTZType:
            return "yyyy-MM-dd'T'HH:mm:ssZ"
        case .date(let dateType):
            return "\(dateType.format)"
        case .time(let timeType):
            return "\(timeType.format)"
        }
    }
}


