# Ruby on Rails & GraphQL API

Ruby on Rails6とGrapqhQLで構築したAPI。  
データベースはMysql8を使用。  
テストコードはRspecを使用。  

VSCodeのDev Containerを使用して構築しているので、VSCode Dev ContainerにてDockerを立ち上げ下記のコマンドで起動。

```
bin/rails s -p 3000 -b '0.0.0.0'
```

エンドポイント

```
http://localhost:3000/graphql
```

Graphiql URL

```
http://localhost:3000/graphiql
```