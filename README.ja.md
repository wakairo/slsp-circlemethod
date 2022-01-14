# SLSP::CircleMethod

[![Ruby](https://github.com/wakairo/slsp-circlemethod/actions/workflows/main.yml/badge.svg)](https://github.com/wakairo/slsp-circlemethod/actions/workflows/main.yml)

SLSP:: CircleMethodは、スポーツスケジューリング問題におけるcircle methodを用いたメソッドを提供します。

## インストール

このgemを利用するアプリケーションのGemfileに以下の行を追加して下さい。

```ruby
gem 'slsp-circlemethod'
```

そして、以下のコマンドを実行して下さい。

    $ bundle install

もし以上のようにGemfileを利用しないのであれば、以下のコマンドでインストールして下さい。

    $ gem install slsp-circlemethod

## 利用方法

### each()

SLSP::CircleMethod.each()は、Circle methodを利用することで、同時に行われる試合の集まり、つまり、ラウンドを考慮した上で、nチームの対戦スケジュールを計算します。

コード例:
```ruby
teams = %w(A B C D  E F G H)
enum = SLSP::CircleMethod.each_with_fair_break(teams.size)
enum.each_slice(teams.size/2).each_with_index do |x, i|
    puts "Round #{i}: " + x.map{|p,q| "#{teams[p]} vs #{teams[q]}"}.join(", ")
end
```

出力:
```
Round 0: A vs H, G vs B, C vs F, E vs D
Round 1: B vs H, A vs C, D vs G, F vs E
Round 2: H vs C, B vs D, E vs A, G vs F
Round 3: D vs H, C vs E, F vs B, A vs G
Round 4: H vs E, D vs F, G vs C, B vs A
Round 5: F vs H, E vs G, A vs D, C vs B
Round 6: H vs G, F vs A, B vs E, D vs C
```


### each_with_fair_break()

SLSP::CircleMethod.each_with_fair_break()は、さらにブレイクを考慮した上で、対戦スケジュールを計算します。
スポーツスケジューリング問題では、ブレイクは「2回連続したホーム・ゲームまたはアウェイ・ゲーム」のことを意味します。
以下の例では、AとB、D、Fの4チームが「hh」（2回連続したホーム・ゲーム）を持ち、CとE、G、Hの4チームが「aa」（2回連続したアウェイ・ゲーム）を持ちます。
したがって、各チームが平等にブレイクを1つずつ持ちます。

コード例:
```ruby
teams = %w(A B C D  E F G H)
puts "Team   : " + teams.join(" ")
enum = SLSP::CircleMethod.each_with_fair_break(teams.size)
enum.each_slice(teams.size/2).each_with_index do |round, i|
    a = []
    round.each do |home, away|
        a[home] = "h"
        a[away] = "a"
    end
    puts "Round #{i}: " + a.join(" ")
end
```

出力:
```
Team   : A B C D E F G H
Round 0: h a h a h a h a
Round 1: h h a h a h a a
Round 2: a h a a h a h h
Round 3: h a h h a h a a
Round 4: a h a h a a h h
Round 5: h a h a h h a a
Round 6: a h a h a h a h
```


## 開発

このレポジトリをチェックアウトした後に、まず`bin/setup`を実行して下さい。そして次にテストを走らせるために`rake test`を実行して下さい。

このgemをローカル環境にインストールするには、`bundle exec rake install`を実行して下さい。新たなバージョンをリリースするには、`version.rb`内のバージョン番号を更新してから、`bundle exec rake release`を実行して下さい。このコマンドは、新バージョンに対するgitタグを生成し、このタグとgitコミットをpushし、`.gem`ファイルを[rubygems.org](https://rubygems.org)へpushします。

## 開発への参加

バグレポートとプルリクエストはGitHubへお寄せ下さい。
https://github.com/wakairo/slsp-circlemethod

## ライセンス

このgemは[MIT License](https://opensource.org/licenses/MIT)の下で、オープンソースのライブラリとしてご利用可能です。
