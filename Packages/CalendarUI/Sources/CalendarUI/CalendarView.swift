// The Swift Programming Language
import SwiftUI
import FSCalendar
import Combine

public struct CalanderView: View {
    
    @State private var selectedDate: Date?
    
    public var body: some View {
        
        VStack {
            
            FSCalanderView { date in
                
                DispatchQueue.main.async {
                    
                    selectedDate = date
                    
                }
                
            }
            
            if let date = selectedDate {
                
                
                
            }
            
        }
        
    }
    
}

#Preview {
    CalanderView()
}


class FSCalendarCoordinator: NSObject {
    
    let pub = PassthroughSubject<Date, Never>()
    
}

// FSCalendarDelegate
extension FSCalendarCoordinator: FSCalendarDelegate {
 
    
    
}

// FSCalendarDataSource
extension FSCalendarCoordinator: FSCalendarDataSource {
    
    // 날짜를 선택했을 때 할일을 지정
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        pub.send(date)
    
    }
    
}

// FSCalendarDelegateAppearance
extension FSCalendarCoordinator: FSCalendarDelegateAppearance {
    
    // 선택된 날짜의 채워진 색상 지정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return appearance.selectionColor
    }
    
    // 선택된 날짜 테두리 색상
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return UIColor.white
    }
    
    // 모든 날짜의 채워진 색상 지정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return UIColor.white
    }
    
    // title의 디폴트 색상
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return UIColor.black
    }
    
    // subtitle의 디폴트 색상
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        return UIColor.black
    }
    
}

class MySub {
    
    var sub: AnyCancellable?
    
}



struct FSCalanderView: UIViewRepresentable {
    
    public typealias SubClosure = (Date) -> ()
    
    typealias UIViewType = FSCalendar
    
    var mySub = MySub()
    
    var completion: SubClosure
    
    public init(completion: @escaping SubClosure) {
        
        self.completion = completion
        
    }
    
    func makeUIView(context: Context) -> FSCalendar {
        
        let calendar = FSCalendar()
        
        let coodinator = context.coordinator
        
        calendar.delegate = coodinator
        calendar.dataSource = coodinator
        
        setCalendarUI(calendar: calendar)
        
        mySub.sub = context.coordinator.pub.sink(receiveCompletion: { result in
            
        }, receiveValue: {
            
            completion($0)
            
        })
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        
        
        
    }
    
    func makeCoordinator() -> FSCalendarCoordinator {
        
        return FSCalendarCoordinator()
        
    }
    
    
}


extension FSCalanderView {
    
    func setCalendarUI(calendar: FSCalendar) {
        
        // calendar? locale > 한국으로 설정
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 상단 요일을 한글로! 변경
        calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "토"
        
//        // 월~일 글자 폰트 및 사이즈 지정
//        calendar.appearance.weekdayFont = UIFont.SpoqaHanSans(type: .Regular, size: 14)
//        // 숫자들 글자 폰트 및 사이즈 지정
//        calendar.appearance.titleFont = UIFont.SpoqaHanSans(type: .Regular, size: 16)
        
        // 캘린더 스크롤 가능하게 지정
        calendar.scrollEnabled = true
        // 캘린더 스크롤 방향 지정
        calendar.scrollDirection = .horizontal
        
        // Header dateFormat, 년도, 월 폰트(사이즈)와 색, 가운데 정렬
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        
//        calendar.appearance.headerTitleFont = UIFont.SpoqaHanSans(type: .Bold, size: 20)
        
        calendar.appearance.headerTitleColor = UIColor(named: "FFFFFF")?.withAlphaComponent(0.9)
        calendar.appearance.headerTitleAlignment = .center
        
        // 요일 글자 색
        calendar.appearance.weekdayTextColor = UIColor(named: "F5F5F5")?.withAlphaComponent(0.2)
        
        // 캘린더 높이 지정
        calendar.headerHeight = 68
        // 캘린더의 cornerRadius 지정
        calendar.layer.cornerRadius = 10
        
        // 양옆 년도, 월 지우기
        calendar.appearance.headerMinimumDissolvedAlpha = 0.5
        
        // 달에 유효하지 않은 날짜의 색 지정
        calendar.appearance.titlePlaceholderColor = UIColor.white.withAlphaComponent(0.2)
        // 평일 날짜 색
        calendar.appearance.titleDefaultColor = UIColor.white.withAlphaComponent(0.5)
        
        // 달에 유효하지않은 날짜 지우기
        calendar.placeholderType = .none
        
        // 캘린더 숫자와 subtitle간의 간격 조정
        calendar.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
    }
    
}
