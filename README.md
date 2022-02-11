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