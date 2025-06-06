import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';
import '../models/answer.dart';
import '../models/chat_message.dart';

class ApiService {
  // TODO: 백엔드 개발자가 실제 API 엔드포인트로 변경해야 함
  static const String baseUrl = 'https://your-backend-api.com/api';
  
  // 목업 데이터를 static으로 선언하여 상태 유지
  static List<Answer>? _mockAnswers;
  
  // 질문 관련 API
  Future<List<Question>> getQuestions({String? category, String? search}) async {
    // TODO: 실제 API 호출로 대체
    // 현재는 목업 데이터 반환
    final allQuestions = _getMockQuestions();
    
    // 카테고리 필터링
    if (category != null && category != '전체') {
      if (category == '공식') {
        // 공식 카테고리는 isOfficial이 true인 질문들을 반환
        return allQuestions.where((q) => q.isOfficial).toList();
      } else {
        // 다른 카테고리는 기존 로직 유지
        return allQuestions.where((q) => q.category == category).toList();
      }
    }
    
    return allQuestions;
  }

  // 인기 질문 목록 조회 (조회수 기준)
  Future<List<Question>> getPopularQuestions({int limit = 10, String period = '전체기간'}) async {
    // TODO: 백엔드 API 호출
    // final response = await http.get('/api/questions/popular?limit=$limit&period=$period');
    
    await Future.delayed(const Duration(milliseconds: 500)); // API 호출 시뮬레이션
    
    final allQuestions = _getMockQuestions();
    
    // 기간 필터 적용
    List<Question> filteredQuestions;
    if (period == '일주일') {
      final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
      filteredQuestions = allQuestions
          .where((q) => q.createdAt.isAfter(oneWeekAgo))
          .toList();
    } else {
      filteredQuestions = allQuestions;
    }
    
    // 조회수 기준으로 정렬하고 제한
    filteredQuestions.sort((a, b) => b.viewCount.compareTo(a.viewCount));
    return filteredQuestions.take(limit).toList();
  }

  // 자주 받은 질문 목록 조회 (답변 수 기준)
  Future<List<Question>> getFrequentlyAskedQuestions({int limit = 10, String period = '전체기간'}) async {
    // TODO: 백엔드 API 호출
    // final response = await http.get('/api/questions/frequent?limit=$limit&period=$period');
    
    await Future.delayed(const Duration(milliseconds: 500)); // API 호출 시뮬레이션
    
    final allQuestions = _getMockQuestions();
    
    // 기간 필터 적용
    List<Question> filteredQuestions;
    if (period == '일주일') {
      final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
      filteredQuestions = allQuestions
          .where((q) => q.createdAt.isAfter(oneWeekAgo))
          .toList();
    } else {
      filteredQuestions = allQuestions;
    }
    
    // 답변 수 기준으로 정렬하고 제한
    filteredQuestions.sort((a, b) => b.answerCount.compareTo(a.answerCount));
    return filteredQuestions.take(limit).toList();
  }

  Future<List<Question>> getOfficialQuestions({int limit = 10}) async {
    // TODO: 실제 API 호출로 대체
    return _getMockQuestions().where((q) => q.isOfficial).take(limit).toList();
  }

  Future<List<Question>> getUnansweredQuestions({int limit = 10}) async {
    // TODO: 실제 API 호출로 대체
    // 답변 수가 0인 질문들을 반환
    return _getMockQuestions().where((q) => q.answerCount == 0).take(limit).toList();
  }

  Future<List<Question>> searchQuestions(String query) async {
    // TODO: 실제 API 호출로 대체
    return _getMockQuestions()
        .where((q) => q.title.contains(query) || q.content.contains(query))
        .toList();
  }

  Future<Question> createQuestion(Question question) async {
    // TODO: 실제 API 호출로 대체
    // POST /api/questions
    return question;
  }

  Future<Question> getQuestionById(String id) async {
    // TODO: 실제 API 호출로 대체
    return _getMockQuestions().firstWhere((q) => q.id == id);
  }

  // 답변 관련 API
  Future<List<Answer>> getAnswersByQuestionId(String questionId) async {
    // TODO: 실제 API 호출로 대체
    return _getMockAnswers().where((a) => a.questionId == questionId).toList();
  }

  Future<Answer> createAnswer(Answer answer) async {
    // TODO: 실제 API 호출로 대체
    // POST /api/answers
    return answer;
  }

  // 답변 채택
  Future<Answer> acceptAnswer(String answerId, String questionId) async {
    // TODO: 실제 API 호출로 대체
    // PUT /api/answers/{answerId}/accept
    
    await Future.delayed(const Duration(milliseconds: 500)); // API 호출 시뮬레이션
    
    // 목업: 해당 답변을 채택된 상태로 변경
    final answers = _getMockAnswers(); // static 데이터 가져오기
    final answerIndex = answers.indexWhere((a) => a.id == answerId);
    
    if (answerIndex != -1) {
      // 같은 질문의 다른 답변들의 채택 상태를 해제
      for (int i = 0; i < answers.length; i++) {
        if (answers[i].questionId == questionId && answers[i].isAccepted) {
          answers[i] = answers[i].copyWith(isAccepted: false);
        }
      }
      
      // 선택된 답변을 채택 상태로 변경
      answers[answerIndex] = answers[answerIndex].copyWith(isAccepted: true);
      
      // static 데이터 업데이트
      _mockAnswers = answers;
      
      return answers[answerIndex];
    }
    
    throw Exception('답변을 찾을 수 없습니다.');
  }

  // 답변 좋아요/좋아요 취소
  Future<Answer> toggleAnswerLike(String answerId) async {
    // TODO: 실제 API 호출로 대체
    // PUT /api/answers/{answerId}/like
    
    await Future.delayed(const Duration(milliseconds: 300)); // API 호출 시뮬레이션
    
    // 목업: 해당 답변의 좋아요 상태 토글
    final answers = _getMockAnswers(); // static 데이터 가져오기
    final answerIndex = answers.indexWhere((a) => a.id == answerId);
    
    if (answerIndex != -1) {
      final currentAnswer = answers[answerIndex];
      final newIsLiked = !currentAnswer.isLiked;
      final newLikeCount = newIsLiked 
          ? currentAnswer.likeCount + 1 
          : currentAnswer.likeCount - 1;
      
      // 답변 업데이트
      answers[answerIndex] = currentAnswer.copyWith(
        isLiked: newIsLiked,
        likeCount: newLikeCount,
      );
      
      // static 데이터 업데이트
      _mockAnswers = answers;
      
      return answers[answerIndex];
    }
    
    throw Exception('답변을 찾을 수 없습니다.');
  }

  // 채팅 관련 API
  Future<List<ChatMessage>> processChatMessage(String message) async {
    // TODO: 실제 AI/백엔드 API 호출로 대체
    // POST /api/chat/process
    
    // 현재는 간단한 목업 응답
    await Future.delayed(const Duration(seconds: 1)); // 네트워크 지연 시뮬레이션
    
    // 사용자 메시지는 제외하고 AI 답변만 반환
    return [
      ChatMessage.assistant(
        '죄송합니다. 현재 백엔드 연동 대기 중입니다.\n백엔드 개발자가 API를 구현하면 정상적으로 작동할 예정입니다.',
        metadata: {'type': 'mock_response'},
      ),
    ];
  }

  // 카테고리 자동 감지 (백엔드에서 처리할 예정)
  String detectCategory(String content) {
    // TODO: 백엔드 AI API로 대체
    final text = content.toLowerCase();
    
    if (text.contains('수강신청') || text.contains('학사일정') || text.contains('성적') || text.contains('학점')) {
      return '학사';
    } else if (text.contains('장학금') || text.contains('등록금') || text.contains('학비')) {
      return '장학금';
    } else if (text.contains('취업') || text.contains('인턴') || text.contains('채용') || text.contains('진로')) {
      return '취업';
    } else if (text.contains('동아리') || text.contains('행사') || text.contains('프로그램') || text.contains('활동')) {
      return '교내프로그램';
    }
    
    return '기타';
  }

  // 채팅에서 질문 생성 (백엔드에서 처리할 예정)
  Future<Question> createQuestionFromChat(String title, String content, String category) async {
    // TODO: 백엔드 API 호출로 대체
    // POST /api/questions/from-chat
    
    final question = Question(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      userId: 'user_001', // TODO: 실제 사용자 ID로 대체
      userName: '익명',
      createdAt: DateTime.now(),
      category: category,
      tags: _extractKeywords(content).take(3).toList(),
    );
    
    // 목업: 실제로는 백엔드에 저장
    return question;
  }

  // 키워드 추출 (백엔드에서 처리할 예정)
  List<String> _extractKeywords(String text) {
    // TODO: 백엔드 AI API로 대체
    final keywords = <String>[];
    final words = text.toLowerCase().replaceAll(RegExp(r'[^\w\s가-힣]'), '').split(' ');
    
    for (final word in words) {
      if (word.length > 1) {
        keywords.add(word);
      }
    }
    
    return keywords;
  }

  // 목업 데이터 (백엔드 연동 전까지 임시 사용)
  List<Question> _getMockQuestions() {
    return [
      Question(
        id: '1',
        title: '2024년 1학기 수강신청 일정이 언제인가요?',
        content: '수강신청 일정을 알고 싶습니다.',
        userId: 'admin',
        userName: '학사팀',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        category: '학사',
        isOfficial: true,
        viewCount: 150,
        answerCount: 1,
        tags: ['수강신청', '일정', '학사'],
      ),
      Question(
        id: '2',
        title: '장학금 신청 방법을 알려주세요',
        content: '성적 장학금 신청하려면 어떻게 해야 하나요?',
        userId: 'user1',
        userName: '익명',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        category: '장학금',
        viewCount: 89,
        answerCount: 2,
        tags: ['장학금', '신청'],
      ),
      Question(
        id: '3',
        title: '도서관 이용시간이 어떻게 되나요?',
        content: '중앙도서관 평일/주말 이용시간을 알고 싶습니다.',
        userId: 'admin',
        userName: '도서관',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        category: '기타',
        isOfficial: true,
        viewCount: 234,
        answerCount: 1,
        tags: ['도서관', '이용시간'],
      ),
      Question(
        id: '4',
        title: '졸업요건이 어떻게 되나요?',
        content: '컴퓨터공학과 졸업요건을 알고 싶습니다.',
        userId: 'user2',
        userName: '학생',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        category: '학사',
        viewCount: 67,
        answerCount: 3,
        tags: ['졸업요건', '학사'],
      ),
      Question(
        id: '5',
        title: '국가장학금 신청 기간이 언제인가요?',
        content: '국가장학금 1차 신청 기간을 알려주세요.',
        userId: 'admin',
        userName: '학생지원팀',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        category: '장학금',
        isOfficial: true,
        viewCount: 198,
        answerCount: 1,
        tags: ['국가장학금', '신청기간'],
      ),
      Question(
        id: '6',
        title: '교내 동아리 가입 방법',
        content: '새 학기 동아리 가입하고 싶은데 어떻게 하나요?',
        userId: 'user3',
        userName: '신입생',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        category: '교내프로그램',
        viewCount: 45,
        answerCount: 2,
        tags: ['동아리', '가입'],
      ),
      Question(
        id: '7',
        title: '취업박람회 일정 문의',
        content: '올해 취업박람회는 언제 열리나요?',
        userId: 'user4',
        userName: '4학년',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        category: '취업',
        viewCount: 123,
        answerCount: 1,
        tags: ['취업박람회', '일정'],
      ),
      Question(
        id: '8',
        title: '학식 메뉴와 운영시간',
        content: '학생식당 메뉴와 운영시간이 궁금합니다.',
        userId: 'user5',
        userName: '재학생',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        category: '기타',
        viewCount: 78,
        answerCount: 0,
        tags: ['학식', '운영시간'],
      ),
      Question(
        id: '9',
        title: '성적 이의신청 방법',
        content: '성적에 이상이 있어서 이의신청하고 싶습니다.',
        userId: 'user6',
        userName: '학생',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        category: '학사',
        viewCount: 92,
        answerCount: 2,
        tags: ['성적', '이의신청'],
      ),
      Question(
        id: '10',
        title: '교환학생 프로그램 안내',
        content: '해외 교환학생 프로그램에 대해 알고 싶습니다.',
        userId: 'admin',
        userName: '국제교류팀',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        category: '교내프로그램',
        isOfficial: true,
        viewCount: 156,
        answerCount: 1,
        tags: ['교환학생', '해외'],
      ),
      // 답변받지 못한 질문들 (테스트용)
      Question(
        id: '11',
        title: '기숙사 신청은 언제부터 가능한가요?',
        content: '새 학기 기숙사 신청 일정을 알고 싶습니다.',
        userId: 'user7',
        userName: '신입생A',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        category: '기타',
        viewCount: 15,
        answerCount: 0,
        tags: ['기숙사', '신청'],
      ),
      Question(
        id: '12',
        title: '전과 절차가 어떻게 되나요?',
        content: '다른 학과로 전과하고 싶은데 절차를 알려주세요.',
        userId: 'user8',
        userName: '2학년',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        category: '학사',
        viewCount: 32,
        answerCount: 0,
        tags: ['전과', '절차'],
      ),
      Question(
        id: '13',
        title: '학생증 재발급 방법',
        content: '학생증을 분실했는데 재발급 받으려면 어떻게 해야 하나요?',
        userId: 'user9',
        userName: '학생B',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        category: '기타',
        viewCount: 28,
        answerCount: 0,
        tags: ['학생증', '재발급'],
      ),
      Question(
        id: '14',
        title: '복수전공 신청 조건이 궁금해요',
        content: '복수전공을 하려면 어떤 조건을 만족해야 하나요?',
        userId: 'user10',
        userName: '3학년',
        createdAt: DateTime.now().subtract(const Duration(hours: 10)),
        category: '학사',
        viewCount: 41,
        answerCount: 0,
        tags: ['복수전공', '조건'],
      ),
      // 테스트 사용자가 작성한 질문 (답변 채택 테스트용)
      Question(
        id: '15',
        title: '프로그래밍 과제 도움이 필요해요',
        content: 'C++ 과제를 하고 있는데 포인터 부분이 이해가 안 됩니다. 도움 주세요!',
        userId: 'test',
        userName: 'test',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        category: '학사',
        viewCount: 23,
        answerCount: 3,
        tags: ['프로그래밍', 'C++', '과제'],
      ),
      Question(
        id: '16',
        title: '교내 아르바이트 구하는 방법',
        content: '교내에서 아르바이트를 하고 싶은데 어디서 구할 수 있나요?',
        userId: 'user11',
        userName: '학생C',
        createdAt: DateTime.now().subtract(const Duration(hours: 14)),
        category: '기타',
        viewCount: 19,
        answerCount: 0,
        tags: ['아르바이트', '교내'],
      ),
      Question(
        id: '17',
        title: '휴학 신청 기간이 언제인가요?',
        content: '다음 학기 휴학을 하려고 하는데 언제까지 신청해야 하나요?',
        userId: 'user12',
        userName: '재학생D',
        createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        category: '학사',
        viewCount: 37,
        answerCount: 0,
        tags: ['휴학', '신청기간'],
      ),
      Question(
        id: '18',
        title: '캠퍼스 내 프린터 사용법',
        content: '도서관이나 학과 사무실 프린터 사용 방법을 알려주세요.',
        userId: 'user13',
        userName: '신입생E',
        createdAt: DateTime.now().subtract(const Duration(hours: 22)),
        category: '기타',
        viewCount: 12,
        answerCount: 0,
        tags: ['프린터', '사용법'],
      ),
      Question(
        id: '19',
        title: '컴퓨터공학과 전공 필수 과목이 궁금해요',
        content: '컴퓨터공학과에서 꼭 들어야 하는 전공 필수 과목들이 무엇인지 알고 싶습니다.',
        userId: 'test',
        userName: 'test',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        category: '학사',
        viewCount: 45,
        answerCount: 2,
        tags: ['전공필수', '컴퓨터공학과'],
      ),
      Question(
        id: '20',
        title: '도서관 스터디룸 예약 방법',
        content: '중앙도서관 스터디룸을 예약하려면 어떻게 해야 하나요?',
        userId: 'test',
        userName: 'test',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        category: '기타',
        viewCount: 32,
        answerCount: 1,
        tags: ['도서관', '스터디룸', '예약'],
      ),
      Question(
        id: '21',
        title: '교내 Wi-Fi 연결 문제',
        content: '교내 Wi-Fi에 연결이 안 되는데 해결 방법이 있을까요?',
        userId: 'test',
        userName: 'test',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        category: '기타',
        viewCount: 18,
        answerCount: 0,
        tags: ['Wi-Fi', '연결문제'],
      ),
      Question(
        id: '22',
        title: '인턴십 프로그램 신청 기간',
        content: '여름 인턴십 프로그램 신청은 언제부터 시작되나요?',
        userId: 'test',
        userName: 'test',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        category: '취업',
        viewCount: 67,
        answerCount: 0,
        tags: ['인턴십', '신청기간'],
      ),
      Question(
        id: '23',
        title: '학점 교류 프로그램 문의',
        content: '타 대학과의 학점 교류 프로그램에 대해 알고 싶습니다.',
        userId: 'test',
        userName: 'test',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        category: '학사',
        viewCount: 29,
        answerCount: 1,
        tags: ['학점교류', '타대학'],
      ),
    ];
  }

  List<Answer> _getMockAnswers() {
    // static 변수가 null이면 초기화
    _mockAnswers ??= [
      Answer(
        id: '1',
        questionId: '1',
        content: '2024년 1학기 수강신청은 2월 5일부터 시작됩니다.\n자세한 일정은 학사공지를 확인해주세요.',
        userId: 'admin',
        userName: '학사팀',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        isAccepted: true,
        isLiked: false,
        likeCount: 25,
        department: '학사처',
        isVerified: true,
        userLevel: 5,
      ),
      Answer(
        id: '2',
        questionId: '2',
        content: '성적 장학금은 매 학기 말에 신청 가능합니다.\n학사시스템에서 온라인으로 신청하시면 됩니다.',
        userId: 'user2',
        userName: '선배',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isLiked: false,
        likeCount: 12,
        department: '컴퓨터공학과',
        studentId: '****1234',
        isVerified: true,
        userLevel: 3,
      ),
      Answer(
        id: '3',
        questionId: '2',
        content: '장학금 신청 시 성적증명서와 가족관계증명서가 필요합니다.\n서류는 온라인으로 제출 가능해요.',
        userId: 'user3',
        userName: '도우미',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isLiked: false,
        likeCount: 8,
        userLevel: 2,
      ),
      Answer(
        id: '4',
        questionId: '3',
        content: '중앙도서관 이용시간:\n평일: 09:00 - 22:00\n주말: 09:00 - 18:00',
        userId: 'admin',
        userName: '도서관',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        isAccepted: true,
        isLiked: false,
        likeCount: 18,
        department: '도서관',
        isVerified: true,
        userLevel: 5,
      ),
      Answer(
        id: '5',
        questionId: '4',
        content: '컴퓨터공학과 졸업요건:\n- 전공 72학점 이상\n- 교양 30학점 이상\n- 총 130학점 이상',
        userId: 'user4',
        userName: '졸업생',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        isLiked: false,
        likeCount: 15,
        department: '컴퓨터공학과',
        studentId: '****5678',
        isVerified: true,
        userLevel: 4,
      ),
      Answer(
        id: '6',
        questionId: '4',
        content: '졸업논문 또는 졸업작품 중 하나를 선택해서 제출해야 합니다.\n지도교수님과 상담 후 결정하세요.',
        userId: 'user5',
        userName: '선배',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        isLiked: false,
        likeCount: 9,
        department: '전자공학과',
        studentId: '****9012',
        isVerified: true,
        userLevel: 3,
      ),
      Answer(
        id: '7',
        questionId: '4',
        content: '캡스톤 디자인 과목도 필수로 이수해야 합니다.\n4학년 때 수강하시면 됩니다.',
        userId: 'user6',
        userName: '조교',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        isLiked: false,
        likeCount: 6,
        department: '컴퓨터공학과',
        isVerified: true,
        userLevel: 4,
      ),
      // 테스트 질문(id: '15')에 대한 답변들
      Answer(
        id: '8',
        questionId: '15',
        content: '포인터는 메모리 주소를 저장하는 변수입니다.\nint* ptr = &variable; 이런 식으로 선언하고 사용해요.',
        userId: 'user7',
        userName: '프로그래밍 선배',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        isLiked: false,
        likeCount: 12,
        department: '컴퓨터공학과',
        studentId: '****3456',
        isVerified: true,
        userLevel: 4,
      ),
      Answer(
        id: '9',
        questionId: '15',
        content: '포인터 개념이 어려우시면 먼저 메모리 구조부터 이해하시는 게 좋아요.\n참고서적: C++ Primer Plus',
        userId: 'user8',
        userName: '컴공 조교',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        isLiked: false,
        likeCount: 8,
        department: '컴퓨터공학과',
        isVerified: true,
        userLevel: 5,
      ),
      Answer(
        id: '10',
        questionId: '15',
        content: '실습을 많이 해보시는 게 중요해요.\n간단한 예제부터 차근차근 따라해보세요.\n\n```cpp\nint x = 10;\nint* ptr = &x;\ncout << *ptr; // 10 출력\n```',
        userId: 'user9',
        userName: '4학년 선배',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        isLiked: false,
        likeCount: 15,
        userLevel: 2,
      ),
    ];
    
    return _mockAnswers!;
  }

  // 오늘의 통계 관련 API
  Future<int> getTodayQuestionCount() async {
    // TODO: 실제 API 호출로 대체
    // GET /api/statistics/today/questions
    await Future.delayed(const Duration(milliseconds: 300));
    
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    
    return _getMockQuestions()
        .where((q) => q.createdAt.isAfter(todayStart))
        .length;
  }

  Future<int> getTodayAnswerCount() async {
    // TODO: 실제 API 호출로 대체
    // GET /api/statistics/today/answers
    await Future.delayed(const Duration(milliseconds: 300));
    
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    
    return _getMockAnswers()
        .where((a) => a.createdAt.isAfter(todayStart))
        .length;
  }

  Future<int> getTotalAnswerCount() async {
    // TODO: 실제 API 호출로 대체
    // GET /api/statistics/total/answers
    await Future.delayed(const Duration(milliseconds: 300));
    
    // 목업 데이터에서 전체 답변 수 계산
    return _getMockAnswers().length + 150; // 기존 답변들 포함한 누적 수
  }

  // 우수 답변자 목록 조회
  Future<List<TopAnswerer>> getTopAnswerers({int limit = 3}) async {
    // TODO: 실제 API 호출로 대체
    // GET /api/statistics/top-answerers?limit=$limit
    await Future.delayed(const Duration(milliseconds: 400));
    
    return _getMockTopAnswerers().take(limit).toList();
  }

  // 우수 답변자 목업 데이터
  List<TopAnswerer> _getMockTopAnswerers() {
    return [
      TopAnswerer(
        id: 'user_top1',
        userName: '김단국',
        profileImageUrl: '', // 빈 문자열로 설정하여 기본 아이콘 사용
        score: 128,
        rank: 1,
        answerCount: 42,
        likeCount: 85,
      ),
      TopAnswerer(
        id: 'user_top2',
        userName: '박대학',
        profileImageUrl: '', // 빈 문자열로 설정하여 기본 아이콘 사용
        score: 105,
        rank: 2,
        answerCount: 35,
        likeCount: 70,
      ),
      TopAnswerer(
        id: 'user_top3',
        userName: '이학생',
        profileImageUrl: '', // 빈 문자열로 설정하여 기본 아이콘 사용
        score: 84,
        rank: 3,
        answerCount: 28,
        likeCount: 56,
      ),
      TopAnswerer(
        id: 'user_top4',
        userName: '최교수',
        profileImageUrl: '', // 빈 문자열로 설정하여 기본 아이콘 사용
        score: 66,
        rank: 4,
        answerCount: 22,
        likeCount: 44,
      ),
      TopAnswerer(
        id: 'user_top5',
        userName: '정선배',
        profileImageUrl: '', // 빈 문자열로 설정하여 기본 아이콘 사용
        score: 54,
        rank: 5,
        answerCount: 18,
        likeCount: 36,
      ),
    ];
  }

  // 사용자 질문 통계 관련 API
  Future<Map<String, int>> getUserQuestionStats(String userId) async {
    // TODO: 실제 API 호출로 대체
    // GET /api/users/{userId}/question-stats
    await Future.delayed(const Duration(milliseconds: 300));
    
    final userQuestions = _getMockQuestions().where((q) => q.userId == userId).toList();
    final answeredQuestions = userQuestions.where((q) => q.answerCount > 0).length;
    final unansweredQuestions = userQuestions.where((q) => q.answerCount == 0).length;
    
    return {
      'total': userQuestions.length,
      'answered': answeredQuestions,
      'unanswered': unansweredQuestions,
    };
  }

  Future<List<Question>> getUserQuestions(String userId, {String? filter}) async {
    // TODO: 실제 API 호출로 대체
    // GET /api/users/{userId}/questions?filter={filter}
    await Future.delayed(const Duration(milliseconds: 500));
    
    var userQuestions = _getMockQuestions().where((q) => q.userId == userId).toList();
    
    // 필터 적용
    if (filter == 'answered') {
      userQuestions = userQuestions.where((q) => q.answerCount > 0).toList();
    } else if (filter == 'unanswered') {
      userQuestions = userQuestions.where((q) => q.answerCount == 0).toList();
    }
    
    // 최신순으로 정렬
    userQuestions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return userQuestions;
  }

  // 백엔드 개발자를 위한 API 엔드포인트 가이드
  /*
  
  === API 엔드포인트 가이드 ===
  
  1. 질문 관련 API:
     GET  /api/questions                    - 질문 목록 조회
     GET  /api/questions/{id}               - 특정 질문 조회
     POST /api/questions                    - 새 질문 작성
     GET  /api/questions/popular            - 인기 질문 목록
     GET  /api/questions/frequent           - 자주 받은 질문 목록
     GET  /api/questions/official           - 공식 질문 목록
     GET  /api/questions/search?q={query}   - 질문 검색
  
  2. 답변 관련 API:
     GET  /api/questions/{id}/answers       - 특정 질문의 답변 목록
     POST /api/answers                      - 새 답변 작성
     PUT  /api/answers/{id}/accept          - 답변 채택
     PUT  /api/answers/{id}/like            - 답변 좋아요
  
  3. 채팅 관련 API:
     POST /api/chat/process                 - 채팅 메시지 처리 (AI 응답)
  
  4. 카테고리:
     - 학사
     - 장학금
     - 교내프로그램
     - 취업
     - 기타
  
  5. 요청/응답 형식:
     - Content-Type: application/json
     - 모든 날짜는 ISO 8601 형식 (2024-01-01T00:00:00Z)
     - 페이지네이션: ?page=1&limit=10
  
  */
}

// 우수 답변자 모델
class TopAnswerer {
  final String id;
  final String userName;
  final String profileImageUrl;
  final int score;
  final int rank;
  final int answerCount;
  final int likeCount;

  TopAnswerer({
    required this.id,
    required this.userName,
    required this.profileImageUrl,
    required this.score,
    required this.rank,
    required this.answerCount,
    required this.likeCount,
  });
} 