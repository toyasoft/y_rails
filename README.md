# テスト用Ruby on Rails & GraphQL API

Ruby on RailsとGrapqhQLで構築したAPIテスト。  
データベースはMysqlを使用。  
テストコードはRspecを使用。  

VSCodeのdev containerを使用して構築しているので、VSCodeにてDockerを立ち上げ下記のコマンドで起動可能

```
bin/rails s -p 3000 -b '0.0.0.0'
```