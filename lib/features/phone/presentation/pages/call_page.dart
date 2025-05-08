import 'package:flutter/material.dart';
import 'dart:async'; // Timerを使用するためにインポート
import 'package:flutter_svg/flutter_svg.dart'; // SVG表示用にインポート追加

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late DateTime _callStartTime; // 電話を受けた時刻
  late String _elapsedTime = "0:00"; // 経過時間を初期化
  late Timer _timer; // 経過時間更新用のタイマー

  @override
  void initState() {
    super.initState();

    // 電話を受けた時刻を記録
    _callStartTime = DateTime.now();
    // 経過時間を初期化し、1秒ごとに更新するタイマーを設定
    _updateElapsedTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateElapsedTime(),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // 経過時間更新用のタイマーをキャンセル
    super.dispose();
  }

  // 経過時間を更新するメソッド
  void _updateElapsedTime() {
    final now = DateTime.now();
    final difference = now.difference(_callStartTime);
    difference.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = difference.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    setState(() {
      _elapsedTime = '${difference.inMinutes}:$seconds'; // 分:秒の形式で表示
    });
  }

  // 電話を切るメソッド
  void _endCall() {
    // ホーム画面に戻る
    Navigator.of(
      context,
    ).pop(); // または Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A148C), // 添付画像を参考に背景色を設定
      body: SafeArea(
        child: Center(
          // 全体をCenterウィジェットで囲む
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 上下はそのままに
              crossAxisAlignment: CrossAxisAlignment.center, // 左右を中央揃え
              children: [
                // 上部の情報 (経過時間、ビデオ通話、名前)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start, // 上寄せ (デフォルト)
                  crossAxisAlignment: CrossAxisAlignment.center, // 横方向を中央揃え
                  children: [
                    Text(
                      _elapsedTime, // 経過時間を表示
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'ビデオ通話',
                      style: TextStyle(fontSize: 24, color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'わにゃ', // 仮の名前
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // キャラクター画像を紫の猫のSVG画像に置き換え
                SvgPicture.network(
                  'https://raw.githubusercontent.com/i-icc/kids_studio_modified/main/assets/images/purple_cat.svg',
                  width: 200,
                  height: 200,
                  placeholderBuilder: (BuildContext context) => Container(
                    width: 200,
                    height: 200,
                    color: Colors.purple[100],
                    child: const Center(
                      child: Text('にゃ〜', style: TextStyle(fontSize: 24, color: Colors.purple)),
                    ),
                  ),
                ),

                // 電話を切るボタン
                GestureDetector(
                  onTap: _endCall, // ボタンタップで電話を切る
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.red, // 電話を切るボタンは赤色
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.call_end, // 電話を切るアイコン
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}