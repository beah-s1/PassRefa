<template>
  <v-app>
    <v-app-bar
        app
        dark
        color="blue"
    >
      <v-app-bar-title>パスりふぁ</v-app-bar-title>
    </v-app-bar>
    <v-main>
      <v-container>
        <div class="my-1">
          <v-form>
          <v-row>
            <v-col>
              <v-select
                  label="乗車駅選択"
                  :items="startStation.availableStations"
                  v-model="startStation.stationCode"
              >
              </v-select>
            </v-col>
            <v-col>
              <v-text-field
                  v-model="startStation.name"
                  label="乗車駅検索"
              >
                <template v-slot:append-outer>
                  <v-btn
                      color="primary"
                      v-on:click="getStation(true)"
                  >検索</v-btn>
                </template>
              </v-text-field>
            </v-col>
          </v-row>

          <v-row>
            <v-col>
              <v-select
                  label="降車駅選択"
                  :items="endStation.availableStations"
                  v-model="endStation.stationCode"
              ></v-select>
            </v-col>
            <v-col>
              <v-text-field
                  v-model="endStation.name"
                  label="降車駅検索"
              >
                <template v-slot:append-outer>
                  <v-btn
                      color="primary"
                      v-on:click="getStation(false)"
                  >検索</v-btn>
                </template>
              </v-text-field>
            </v-col>
          </v-row>
          <v-btn
              color="green"
              dark
              v-on:click="searchRoute()"
          >経路を検索</v-btn>
        </v-form>
        </div>
        <v-divider></v-divider>
        <div class="my-1">
          <v-form>
            <v-select
                label="経路"
                :items="routes"
                v-model="passInfo.route.value"
            ></v-select>
            <v-select
                label="定期券の種類"
                :items="passTypes"
                v-model="passInfo.type"
            ></v-select>
            <v-btn
                color="green"
                dark
                v-on:click="getPassPrice()"
            >定期代を計算</v-btn>
          </v-form>
        </div>
        <v-divider></v-divider>
        <div class="my-1">
          <v-form>
            <v-row>
              <v-col>
                <v-text-field
                    label="片道運賃"
                    v-model="passPrice.oneWay"
                    disabled></v-text-field>
              </v-col>
              <v-col>
                <v-text-field
                    label="1ヶ月定期"
                    v-model="passPrice.oneMonth"
                    disabled
                ></v-text-field>
              </v-col>
              <v-col>
                <v-text-field
                    label="3ヶ月定期"
                    v-model="passPrice.threeMonth"
                    disabled
                ></v-text-field>
              </v-col>
              <v-col>
                <v-text-field
                    label="6ヶ月定期"
                    v-model="passPrice.sixMonth"
                    disabled
                ></v-text-field>
              </v-col>
            </v-row>
          </v-form>
        </div>
        <v-divider></v-divider>
        <div class="my-1">
          <v-form>
            <v-select
                label="定期券の有効期間"
                :items="availablePassValid"
                v-model="passInfo.valid"
            ></v-select>
            <v-row>
              <v-col>
                <v-text-field
                    label="定期券の利用開始日"
                    type="date"
                    v-model="passInfo.startDate"
                ></v-text-field>
              </v-col>
              <v-col>
                <v-text-field
                    label="定期券の払い戻し日"
                    type="date"
                    v-model="passInfo.refundDate"
                ></v-text-field>
              </v-col>
              <v-col>
                <v-switch
                    label="区間変更（旬割）"
                    v-model="isRouteChange"
                ></v-switch>
              </v-col>
            </v-row>
            <v-text-field
              label="払い戻し額"
              v-model="passInfo.refundPrice"
              disabled
            ></v-text-field>
            <v-btn
                color="green"
                dark
                v-model="isRouteChange"
                v-on:click="getRefundPrice()"
            >払い戻し額を計算</v-btn>
          </v-form>
        </div>
        <v-divider></v-divider>
        <div class="my-1">
          <h2>システムの利用方法</h2>
          このアプリは、定期券代を計算したり、払い戻し額を計算したりすることができます。

          <h3>駅名入力</h3>
          ・「乗車駅検索」「降車駅検索」に、駅名を入力し、「検索」をクリック<br>
          ・「乗車駅選択」「降車駅選択」でそれぞれ、該当する駅を選択<br>

          <h3>定期券代計算</h3>
          ・駅名を入力する<br>
          ・「経路を検索」をクリック<br>
          ・経路を選ぶ<br>
          ・「定期券の種類」を選ぶ<br>
          ・「定期代を計算」をクリック<br>

          <h3>払い戻し計算</h3>
          ・定期券代まで計算する<br>
          ・「定期券の有効期間」を選択する<br>
          ・「定期券の利用開始日」と「定期券の払い戻し日」を入力する（どちらも今日の日付になっているため、必要に応じて変更してください）<br>
          ・区間変更の場合は「区間変更（旬割）」をオンにする<br>
          ・「払い戻し額を計算」をクリック<br>

          <h3>注意事項</h3>
          ・「社-J-社」のために2区間になっている定期券の場合は、全て足し合わせたものを入力してください<br>
          　（例：七里--[東武野田線]--大宮--[JR埼京線]--渋谷--[東急東横線]--菊名（社） であって、渋谷もしくは大宮で分割した2区間定期の場合は「七里〜菊名」）<br>
          ・上記以外の2区間定期や一部会社線で行っている並走区間の2区間定期（例：だぶるーと（西武））などには対応しません<br>
          ・このアプリは駅すぱあとのAPIを用いていますが、回数制限があるため、過度なアクセスはお止めください<br>
          ・計算された払い戻し額は、所定の払い戻し手数料を控除した状態のものです<br>
          ・7日以内の払い戻しについては、(使用日数 * 往復普通運賃 + 払い戻し手数料)を差し引く方式による計算を強制しています
        </div>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import axios from 'axios'
export default {
  mounted() {
    axios.get("/api/ekispert-key").then((response) =>{
      const data = response.data
      this.ekispert_api_key = data['ekispert_api_key']
      this.ekispertBaseUrl = data['ekispert_base_url']
    })
  },
  methods: {
    getStation: function (isStartStation) {
      const stationNameQuery = isStartStation ? this.startStation.name : this.endStation.name

      // APIにリクエストを投げる
      const url = `${this.ekispertBaseUrl}/station?name=${stationNameQuery}&key=${this.ekispert_api_key}`
      axios.get(url).then((response) => {
        const result = response.data['ResultSet']['Point']
        const stationList = result.map((r) => {
          return {
            text: r['Station']['Name'],
            value: r['Station']['code']
          }
        })

        if (isStartStation == true){
          this.startStation.availableStations = stationList
        }else{
          this.endStation.availableStations = stationList
        }
      })
    },
    searchRoute: function (){
      const url = `${this.ekispertBaseUrl}/search/course/plain?key=${this.ekispert_api_key}&from=${this.startStation.stationCode}&to=${this.endStation.stationCode}`
      axios.get(url).then((response) => {
        this.routes = response.data['ResultSet']['Course'].filter((c) => c['Teiki'] != undefined).map((c) => {
          return {
            text: c['Teiki']['DisplayRoute'],
            value: c['SerializeData']
          }
        })
      })
    },
    getPassPrice: function (){
      const url = `${this.ekispertBaseUrl}/search/course/recalculate?teikiKind=${this.passInfo.type}&serializeData=${this.passInfo.route.value}&key=${this.ekispert_api_key}`
      axios.get(url).then((response) => {
        this.passPrice = {
          oneWay: 0,
          round: 0,
          oneMonth: 0,
          threeMonth: 0,
          sixMonth: 0
        }
        this.availablePassValid = []

        const data = response.data
        for (const priceIndex in data['ResultSet']['Course']['Price']){
          const price = data['ResultSet']['Course']['Price'][priceIndex]
          switch (price["kind"]){
            case 'FareSummary':
              this.passPrice.oneWay = parseInt(price["Oneway"]);
              this.passPrice.round = parseInt(price["Round"]);
              break
            case 'Teiki1Summary':
              this.passPrice.oneMonth = parseInt(price["Oneway"]);
              this.availablePassValid.push({text: "1ヶ月", value: 1})
              break
            case 'Teiki3Summary':
              this.passPrice.threeMonth = parseInt(price["Oneway"]);
              this.availablePassValid.push({text: "3ヶ月", value: 3})
              break
            case 'Teiki6Summary':
              this.passPrice.sixMonth = parseInt(price["Oneway"]);
              this.availablePassValid.push({text: "6ヶ月", value: 6})
              break
            default: break
          }
        }
      })
    },
    getRefundPrice: function(){
      const url = `${this.ekispertBaseUrl}/course/repayment?key=${this.ekispert_api_key}&startDate=${this.passInfo.startDate.replaceAll("-", "")}&repaymentDate=${this.passInfo.refundDate.replaceAll("-", "")}&validityPeriod=${this.passInfo.valid}&changeSection=${this.isRouteChange.toString()}&serializeData=${this.passInfo.route.value}`
      axios.get(url).then((response) => {
        const data = response.data
        this.passInfo.refundPrice = data['ResultSet']['RepaymentList']['RepaymentTicket']['repayPriceValue']
      })
    }
  },
  data: function () {
    const date = new Date()

    return {
      ekispert_api_key: "",
      ekispertBaseUrl: "",
      refundTypes: [
        {
          "text": "払い戻し",
          "value": "refund"
        },{
          "text": "区間変更",
          "value": "route_change"
        }
      ],
      passTypes: [
        {
          text: "通勤定期券",
          value: "bussiness"
        },{
          text: "通学定期券（中学校）",
          value: "juniorHighSchool"
        },{
          text: "通学定期券（高校・高等専門学校1〜3年）",
          value: "highSchool"
        },{
          text: "通学定期券（大学・短大・高等専門学校4年〜）",
          value: "university"
        }
      ],
      selectedType: "",
      startStation: {
        availableStations: [
        ],
        name: "",
        stationCode: ""
      },
      endStation: {
        availableStations: [
        ],
        name: "",
        stationCode: ""
      },
      routes: [],
      passInfo: {
        type: "",
        route: {
          text: "",
          value: ""
        },
        startDate: `${date.getFullYear()}-${("0"+date.getMonth()).slice(-2)}-${("0"+date.getDate()).slice(-2)}`,
        refundDate: `${date.getFullYear()}-${("0"+date.getMonth()).slice(-2)}-${("0"+date.getDate()).slice(-2)}`,
        valid: 0,
        refundPrice: ""
      },
      passPrice: {
        oneWay: 0,
        round: 0,
        oneMonth: 0,
        threeMonth: 0,
        sixMonth: 0
      },
      availablePassValid: [],
      isRouteChange: false
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
