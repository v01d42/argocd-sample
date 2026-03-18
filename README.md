# ArgoCD Sample Project

このプロジェクトは、ArgoCDのApplicationSetを使用したデプロイメントサンプルです。
Kindクラスター上でArgoCDをセットアップし、ArgoCDでサンプルアプリケーションとしてPrometheusとGrafanaをdeployしています。

## プロジェクト構成

```
.
├── charts/              # Helmチャート
│   ├── argocd/         # ArgoCDのインストール用チャート
│   ├── prometheus/     # Prometheusのインストール用チャート
│   ├── grafana/        # Grafanaのインストール用チャート
│   └── argo-app/       # Argo ApplicationSet用チャート
├── kind-config.yaml    # Kindクラスター設定
└── cluster-setup.sh    # クラスターセットアップスクリプト
```

## 前提条件

- Docker
- Kind (オプション)
- kubectl
- Helm

## セットアップ手順

1. Kindクラスターの作成（kind環境のみ）
```bash
./cluster-setup.sh
```

2. ArgoCDのインストール
```bash
helm install argocd charts/argocd --create-namespace -n argocd
```

4. ArgoCD Applicationのデプロイ
これにより`/appsets`配下にあるApplicationSet全てがデプロイされます。
```bash
kubectl apply -f root-argocd-app.yaml
```

## ArgoCDの挙動確認
ArgoCDでレポジトリの変更を検知してCDする挙動は、このレポジトリをForkすることで確認できます。

1. GitHubでこのリポジトリをFork

2. `root-argocd-app.yaml`及び`appsets/monitor-appset.yaml`の`repoURL`を先程Forkした自身のGithub Repo URLに変更
```bash
repoURL: https://github.com/{your-username}/argocd-sample.git
```

3. ArgoCDのインストール
```bash
helm install argocd charts/argocd --create-namaspace -n argocd
```

4. ArgoCD Applicationのデプロイ
```bash
kubectl apply -f root-argocd-app.yaml
```

5. Forkしたリポジトリで変更を加えて`main`にPushすると、ArgoCDが自動的に変更を検知してデプロイします
   - `charts/monitoring-svc/values/monitor-value.yaml`の値を変更して確かめましょう
   - 変更をプッシュ後、ArgoCDのUIで同期状態を確認できます

## アクセス情報
- ArgoCD UI: http://localhost:30080
- Grafana: http://localhost:31000

Grafanaのusernameは`admin`、passwordも`admin`です。
ArgoCDのusernameは`admin`、passwordは以下のコマンドから確認してください。
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## 注意事項

- このプロジェクトは検証環境での使用を想定しています。本番環境に使わないようにお願いします
- ポート番号は必要に応じて`kind-config.yaml`で変更可能です
