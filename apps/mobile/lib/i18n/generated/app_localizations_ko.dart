// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '쥬니';

  @override
  String get loading => '로딩 중...';

  @override
  String get error => '오류가 발생했습니다';

  @override
  String get retry => '재시도';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get delete => '삭제';

  @override
  String get login => '로그인';

  @override
  String get logout => '로그아웃';

  @override
  String get loginWithGoogle => 'Google로 로그인';

  @override
  String get loginWithGithub => 'GitHub로 로그인';

  @override
  String get welcomeHost => '어르신, 안녕하세요! 오늘 기분은 어떠세요?';

  @override
  String get welcomeConcierge => '보호자 대시보드';

  @override
  String get startLive => '라이브 시작';

  @override
  String get endLive => '라이브 종료';

  @override
  String get watchLive => '라이브 보기';

  @override
  String get speakToSenior => '말하기';

  @override
  String get medications => '복약 관리';

  @override
  String get wellness => '건강 기록';

  @override
  String get liveSession => '라이브 세션';

  @override
  String get connecting => '연결 중...';

  @override
  String get connected => '연결됨';

  @override
  String get disconnected => '연결 끊김';

  @override
  String get noMedications => '예정된 복약이 없습니다.';

  @override
  String get noWellnessLogs => '건강 기록이 아직 없어요.';

  @override
  String get errAuth001 => '어르신, 로그인 시간이 다 되었어요. 다시 연결해 드릴게요.';

  @override
  String get errAuth002 => '인증 정보가 올바르지 않아요. 다시 시도해 주세요.';

  @override
  String get errAuth003 => '세션 유형이 올바르지 않아요. 다시 로그인해 주세요.';

  @override
  String get errAuthz001 => '이 작업에 대한 권한이 없어요.';

  @override
  String get errRes001 => '돌봄 관계를 찾을 수 없어요.';

  @override
  String get errRes002 => '앗, 건강 기록을 찾을 수 없어요. 다시 한 번 확인해 볼까요?';

  @override
  String get errRes003 => '약 정보를 찾을 수 없어요.';

  @override
  String get errVal001 => '올바르지 않은 보호자 역할이에요.';

  @override
  String get errVal002 => '자기 자신과는 돌봄 관계를 만들 수 없어요.';

  @override
  String get errSvc001 => '현재 통화 서버와 연결이 원활하지 않아요. 잠시 후 다시 시도해 주세요.';

  @override
  String get errSvc002 => 'AI 서비스가 현재 사용할 수 없어요.';

  @override
  String get errSvc003 => '로그인 제공자로부터 이메일을 받을 수 없었어요.';

  @override
  String get errUnknown => '알 수 없는 오류가 발생했어요.';
}
