// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ジュニ';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラーが発生しました';

  @override
  String get retry => '再試行';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get delete => '削除';

  @override
  String get login => 'ログイン';

  @override
  String get logout => 'ログアウト';

  @override
  String get loginWithGoogle => 'Googleでログイン';

  @override
  String get loginWithGithub => 'GitHubでログイン';

  @override
  String get welcomeHost => 'こんにちは！今日のご気分はいかがですか？';

  @override
  String get welcomeConcierge => '介護者ダッシュボード';

  @override
  String get startLive => 'ライブ開始';

  @override
  String get endLive => 'ライブ終了';

  @override
  String get watchLive => 'ライブを見る';

  @override
  String get speakToSenior => '話す';

  @override
  String get medications => '服薬管理';

  @override
  String get wellness => '健康記録';

  @override
  String get liveSession => 'ライブセッション';

  @override
  String get connecting => '接続中...';

  @override
  String get connected => '接続済み';

  @override
  String get disconnected => '切断されました';

  @override
  String get noMedications => '予定された服薬はありません。';

  @override
  String get noWellnessLogs => '健康記録がまだありません。';

  @override
  String get errAuth001 => 'ログイン時間が切れました。再度接続いたします。';

  @override
  String get errAuth002 => '認証情報が正しくありません。もう一度お試しください。';

  @override
  String get errAuth003 => 'セッションの種類が正しくありません。再度ログインしてください。';

  @override
  String get errAuthz001 => 'この操作の権限がありません。';

  @override
  String get errRes001 => 'ケア関係が見つかりません。';

  @override
  String get errRes002 => '健康記録が見つかりません。もう一度確認しましょう。';

  @override
  String get errRes003 => '薬の情報が見つかりません。';

  @override
  String get errVal001 => '無効な介護者の役割です。';

  @override
  String get errVal002 => '自分自身とのケア関係は作成できません。';

  @override
  String get errSvc001 => '通話サーバーとの接続が不安定です。しばらくしてからもう一度お試しください。';

  @override
  String get errSvc002 => 'AIサービスが現在利用できません。';

  @override
  String get errSvc003 => 'ログインプロバイダーからメールを取得できませんでした。';

  @override
  String get errUnknown => '不明なエラーが発生しました。';
}
