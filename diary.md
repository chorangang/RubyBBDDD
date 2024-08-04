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

しっくりこなくてやめたライブラリ
    ・Roda
        ルーティングのライブラリというか、フレームワークというか。
        ループの中に書くスタイルがしっくりこなくてやめてしまった。
        結局ルーティングは自作した。

設計思想
    DDD
        ドメイン駆動設計。リポジトリの名前の通り、これの勉強がメインテーマ。
    レイヤードアーキテクチャ
        UI層からInfra層に向かうように交通整理

ぶち当たった問題
    ・ソースが自動で反映されない！
        →GuardとGuard-pumaをInstallした上でRack::Reloader,0をconfig.ruに追加。
        ここに辿り着くまでに１時間くらいかかった。ネイティブRuby開発の記事が少なすぎる！！おこ
    ・MySQLに繋がらない！
        →（Puma caught this error: Can't connect to local server through socket '/var/run/mysqld/mysqld.s ock' (2) (Mysql2::Error::ConnectionError)）
        →だいぶ詰まった。体感で２時間くらい。
        →my.cnfに[client]socket=/var/run/mysqld/mysqld.sockを追加したら動くようになったがこれは正しいのだろうか。
    ・Response返すときにJsonにできなかったり返せなかったり。
        →#<NoMethodError: undefined method `to_i' for {"Content-Type"=>"application/json"}:Hash>　など
        →俺が悪い。Rubyの言語仕様がよくわかっていない。ちゃんと勉強しよう！
    ・エラーハンドリング！エラーを５００番で返す！
        面白くない！GPTがMiddlewareでなんとかしろと言うので誤魔化した。
        本来はRackのMiddlewareなどを使うべきなのだろうなと。
        Railsの教材とかでRackのMiddlewareに触れているものもある模様。パーフェクトRailsとか。
        一応以下パーフェクトRailsのリンク(Amazon)。俺は読んでない。
        https://amzn.asia/d/g75EL43

参考にしたもの
    Rackについて
        ・https://gihyo.jp/dev/serial/01/ruby/0025
            Rackとは何か全３回。Rackが誕生した背景からミドルウェアについてまで
        ・https://blog.akanumahiroaki.com/entry/2019/04/06/235500
            Rackをシンプルに動かしてみる。
        ・https://qiita.com/ta1m1kam/items/0a2658776d3dffa1cc86
            RubyでWebフレームワークを自作する。
