使っているライブラリ
    ・Puma
        WebRickとかUnicornとか色々あるらしいが、
        Railsのデフォルトがこれとのことなので採用
    ・Rack
        フレームワークのスターターキットとの認識。Rubyでフレームワークといえばこれ。
        これ以外の選択肢があまり目に付かなかったので採用
    ・guard, guard-puma
        ソースの自動反映のために採用。
        Rack::ReloaderとGuard＋Guard-Pumaの構成にするしかない？？？
    ・mysql2
        RubyでMySQLといえばこれらしい
    ・dotenv
        確かPHPのDotenvのRuby版。名前の通りENVの読み込みに使う。
    ・bcrypt
        passwordのハッシュ化。
    ・jwt
        Tokenの暗号化。最初、JWTを「ジョット」って呼ぶって聞いたんだけど、
        誰かが「ジョット」って呼んでるところを見たことがない気がする。

しっくりこなくてやめたライブラリ
    ・Roda
        ルーティングのライブラリというか、フレームワークというか。
        ループの中に書くスタイルがしっくりこなくてやめてしまった。
        結局ルーティングは自作した。

設計思想
    DDD
        ドメイン駆動設計。リポジトリの名前の通り、これの勉強がメインテーマだが、
        おそらく継続的に運用保守をしないとこれの威力は感じられないと思う。
        デプロイでもしてやろうかな。
    レイヤードアーキテクチャ
        Interface層からInfrastructure層に向かうように交通整理。流しそうめん。

ぶち当たった問題
    ・ソースの変更が自動で反映されない！
        →GuardとGuard-pumaをInstallした上でRack::Reloader,0をconfig.ruに追加。
        ここに辿り着くまでに１時間くらいかかった。これで合ってるのかもよくわからん。
        ネイティブRuby開発の記事が少なすぎる！！おこ
        →Middlewareを編集する時はなんかうまくいかなかった。REloaderの位置とか？？？
    ・MySQLに繋がらない！
        →（Puma caught this error: Can't connect to local server through socket '/var/run/mysqld/mysqld.s ock' (2) (Mysql2::Error::ConnectionError)）
        だいぶ詰まった。体感で２時間くらい。
        →my.cnfに[client]socket=/var/run/mysqld/mysqld.sockを追加したら動くようになったがこれは正しいのだろうか。
    ・Response返すときにJsonにできなかったり返せなかったり。
        →#<NoMethodError: undefined method `to_i' for {"Content-Type"=>"application/json"}:Hash>　など
        たぶんRubyの型についてよくわかってない俺が悪い。ちゃんと勉強しよう！
    ・エラーハンドリング！エラーを５００番で返す！
        →面白くない！GPTがMiddlewareでなんとかしろと言うので誤魔化した。
        本来はRackのMiddlewareなどを使うべきなのだろうなと。
        Railsの教材とかでRackのMiddlewareに触れているものもある模様。パーフェクトRailsとか。
        一応以下パーフェクトRailsのリンク(Amazon)。俺は読んでない。
        https://amzn.asia/d/g75EL43
    ・JWTの認証ってどうやるのが正しいのだ？？
        →認証のような横断的関心事(cross-cutting concern)はMiddlewareを使うのが一般的か。

参考にしたもの
    GPT, Claude
        相棒。こいつらが吐いたコードが半分くらい。This is シンギュラリティ。
    Rack
        ・https://gihyo.jp/dev/serial/01/ruby/0025
            Rackとは何か全３回。Rackが誕生した背景からミドルウェアについてまで
        ・https://blog.akanumahiroaki.com/entry/2019/04/06/235500
            Rackをシンプルに動かしてみる。
        ・https://qiita.com/ta1m1kam/items/0a2658776d3dffa1cc86
            RubyでWebフレームワークを自作する。
    認証
        ・https://zenn.dev/socialplus/articles/ruby-jwt-verification
            JWTについて。Gemの名前がjwtって潔すぎる。
        ・https://github.com/jwt/ruby-jwt
            JWTのGemのリポジトリ

2024/08/04:
    今日からコード書いた日には日記を残そうと思う。
    今日やったのは主にJWT認証用Middlewareの実装。JWTの発行まで済んで、あとはLogoutとUserメソッドの実装。
    JWTはLogoutの瞬間にどこかの記憶領域にブラックリストとして保存しておいて、
    Middlewareで認証するときに参照するようになる。
    TokenUsecaseないしToeknServiceでExistsを作ってInterface層からの呼び出しとする。
    Token認証の解像度があがればCookieをHttpOnly、Samesite=Laxにした上でCookieにJWTを引っ付けて
    CSRFTokenと一緒に吐き出さす、プロレベルのスタンダードなやり方が実現できるかも。
    やっぱりRackアプリケーションのライフサイクルというか、なぜMiddlewareが動作しているかがわからない。
    結局今日１日別プロジェクトもあるのにこれをずっとやってしまった。反省。
    気づいたらだいぶモリモリの実装になってどこに出しても恥ずかしくない気がしている。
    まじでフロントもなんとなく書いてデプロイしてやろうかな。
    Railsの勉強も兼ねてネイティブRuby開発やりたがってるマッチョがあと５人くらいいないかしら。

2024/08/08:
    今日はToken周りまでなんとなく実装。
    テストでトークン認証の動作確認するなどやりたい
    Token認証のフローが結構めんどくさくて雑な実装になっている希ガス。