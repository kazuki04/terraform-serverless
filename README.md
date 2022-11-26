# 概要
AmplifyとAPI Gatewayを使った簡単なサーバレスアプリケーション構築をするためのリポジトリ。インフラリソースはTerraformを使って作成する。

# 環境構築
## Amplify環境の構築

1. 以下コマンドでアプリケーションの初期化を行う。
    ```
    amplify init
    ```

2. 複数の項目に関して質問されるため、以下の選択肢を選ぶ。
    ```
    ? Initialize the project with the above configuration? No
    ? Enter a name for the environment dev
    ? Choose your default editor: Visual Studio Code
    ? Choose the type of app that you're building javascript
    Please tell us about your project
    ? What javascript framework are you using react
    ? Source Directory Path:  src
    ? Distribution Directory Path: out
    ? Build Command:  npm run-script build
    ? Start Command: npm run-script start
    Using default provider  awscloudformation
    ? Select the authentication method you want to use: AWS profile
    ```

    Next.jsでSSRでのデプロイは行わないため、「Distribution Directory Path」の選択肢は「out」と入力する。

    ※ もしもSSGとSSRのハイブリッドアプリケーションをデプロイする場合、「Distribution Directory Path」の選択肢は「.next」と入力する。そして、Amplifyのコンソール画面から設定・デプロイを行う。(参考: [Feature branch deployments and team workflows](https://docs.aws.amazon.com/amplify/latest/userguide/multi-environments.html#standard))

2. 以下コマンドを入力し、Hostingの設定を行う。
    ```
    amplify add hosting
    ```

    以下のように質問されるため、「Manual Deployment」を選択する。
    ```
    ? Select the plugin module to execute: Hosting with Amplify Console (Managed hosting with custom domains, Continuous deployment)
    ? Choose a type: Manual Deployment
    ```

    以下コマンドを入力し、フロントエンドアプリケーションをデプロイする。
    ```
    amplify publish
    ```
## インフラリソースの作成

1. infrastructureディレクトリ配下にtfvarsファイルを配置する。
2. infrastructureディレクトリにおいて、terraform plan & applyでリソースを作成する

# アーキテクチャ図
## システム全体図

### AWS Cognito
ユーザー管理にCognitoを使用する。ユーザーはCognitoに対してリクエストを行い、JWTトークンを受け取る。

### Amazon API Gateway
API Gatewayへのアクセスコントロールには、CognitoユーザープールをAuthorizerとして使用する。API Gatewayへのリクエスト時にCognitoから受け取ったJWTを送信し、JWTの有効性をチェックする。

### AWS Amplify
フロントエンドアプリケーションのホスティング・デプロイにはAWS Amplifyを使用する。

### AWS Lambda
Lambdaを使用して、Amazon DynamoDBに保存されたデータを送受信する。Amazon DynamoDBに保存されたデータの操作にはboto3を使用する。

### Amazon DynamoDB
データの格納場所にはAmazon DynamoDBを使用する。
