# パスりふぁ
乗車駅・降車駅から
- 定期乗車券のねだん
- 定期乗車券の払い戻し金額
  - 区間変更にも対応

を調べることができます

## 注意事項
- 「社-J-社」のために2区間になっている定期券の場合は、全て足し合わせたものを入力してください
    （例：七里--[東武野田線]--大宮--[JR埼京線]--渋谷--[東急東横線]--菊名（社） であって、渋谷もしくは大宮で分割した2区間定期の場合は「七里〜菊名」）
- 上記以外の2区間定期や一部会社線で行っている並走区間の2区間定期（例：だぶるーと（西武））などには対応しません
- このアプリは駅すぱあとのAPIを用いていますが、回数制限があるため、アクセス制限は適宜行ってください
- 計算された払い戻し額は、所定の払い戻し手数料を控除した状態のものです
- 7日以内の払い戻しについては、(使用日数 * 往復普通運賃 + 払い戻し手数料)を差し引く方式による計算を強制しています

## 環境
- Ruby 2.7.1
- Rails 6.1.13
- Vue 2.6.12

## 環境構築
- 以下の内容で、.envファイルを作成してください
    - 駅すぱあとのAPIキーは各自用意してください（Amazonでも買えます）
    - OIDCは、いたずら防止のために用意しています、多分Googleでも動くので、もし個人で試したければ、各種IdPを使用してください
    - SERVER HOSTは、schemeを含んでください（e.g. `http://localhost:3000` ）
        - OIDCのredirect_uriを作成するために使用します
        - redirect_uriは `${SERVER_HOST}/auth/callback` となります
    
```dotenv
EKISPERT_API_KEY=
EKISPERT_API_BASEURL=
OIDC_CONFIGURATION_URL=
OIDC_CLIENT_ID=
OIDC_CLIENT_SECRET=
SERVER_HOST=
DATABASE_HOST=
DATABASE_USER=
DATABASE_PASSWORD=
RAILS_ENV=
RAILS_SERVE_STATIC_FILES=
```
- `docker-compose up`で起動します
- Railsなので、`docker-compose exec app rails db:setup` を使用してください