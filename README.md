# cloudformation
Railsアプリを起動するインフラ環境を構築する
# 構成図
![CFn-ALB-Architecture drawio](https://user-images.githubusercontent.com/51527106/153614931-5d807c6b-cb80-4f10-a58f-ece4e4b44732.svg)
# 使用するリソース
- VPC
- ALB
- EC2
- RDS
# 方針
リソースの依存関係に基づき、テンプレートを分割
1. ネットワーク: VPC, Subnet, InternetGateway, RoutingTable
1. セキュリティグループ: SecurityGroup
1. サーバー: ALB, EC2
1. データベース: RDS
# デプロイ
## 環境
macOS Monterey Version 12.2.1
## AWS CLIのインストール
参考：https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2-mac.html
AWSの公式サイトからOSに応じてCLIのインストーラーをダウンロードし、インストーラーを起動する。
バージョン確認コマンドでインストールされたか確認する。

```bash
$ aws --version
```
## CLIの設定
- マネジメントコンソールのIAMページに移動し、Userを作成する。
- ユーザー作成時に`プログラムによるアクセス`を有効化する。
- ユーザーを作成し、認証情報を控えておく。
- 以下のコマンドでCLIの設定を行う。

```bash
$ aws configure
# ターミナル上で情報を入力する
AWS Access Key ID : {your_access_key}
AWS Secret Access Key : {your_secret_access_key}
Default region name : {your_region} # ex. ap-northeast-1
Default output format : json
```

## CLIによるCloudFormationの基本操作

```bash
# ローカルファイルからスタックを作成
$ aws cloudformation create-stack --stack-name {stack_name} --template-body file://{template_name}.yml
# パラメーターを指定してスタックを作成
$ aws cloudformation create-stack --stack-name server --template-body file://{template_name}.yml \
--parameters ParameterKey={Parameter},ParameterValue=${KeyValue}
# 作成したスタックの削除
$ aws cloudformation delete-stack --stack-name {stack_name}
# スタックの作成が完了するまで待機する
$ aws cloudformation wait stack-create-complete --stack-name {stack_name}
# スタックの削除が完了するまで待機する
$ aws cloudformation wait stack-delete-complete --stack-name {stack_name}
# 作成したスタックの一覧を取得
$ aws cloudformation describe-stacks
```
## bashスクリプトによる、複数スタックの一括作成
以下のコマンドで、ネットワーク、セキュリティグループ、ロードバランサー／インスタンス、データベースの順でスタックを作成する。
パラメーターの内容をまとめた`.env`ファイルを事前に作成し、`.env`ファイルの中身を引数としてbashスクリプトに渡す。

```text:.env
KeyPairName=myKey
MyDBName=myDB
MyDBUserName=root
MyDBPassword=mySecretPwd
```

```bash
$ export $(cat .env | grep -v ^# | xargs); bash create-stacks.sh
```
依存関係のあるリソース作成が完了する前に、次のリソース作成が始まるとエラーになってしまうため、スタックの作成完了まで待機させている。

## 作成したスタックの削除
以下のコマンドで全てのスタックを削除できる。
```bash
$ bash delete-stacks.sh
```