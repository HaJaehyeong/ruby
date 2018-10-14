class VendingMachine
    # Constructor
    def initialize(drink)
        @drink = drink
        @coin_10 = 0
        @coin_50 = 0
        @coin_100 = 0
        @coin_500 = 0
        @coin_1000 = 0
        @coins = 0
        @sales = 0
    end

    # コインを入れたら実行
    def insertCoin(coin)
        # 入れたコイン+1
        case coin
        when "10"
            @coin_10 += 1
        when "50"
            @coin_50 += 1
        when "100"
            @coin_100 += 1
        when "500"
            @coin_500 += 1
        when "1000"
            @coin_1000 += 1
        when "Y"                # 購入する
            return 0
        when "N"                # 修了する
            return 1
        end

        coinsCalculation()      # 関数呼出し   
        return 2
    end

    # 投入金額加算
    def coinsCalculation
        @coins = @coin_10*10 + @coin_50*50 + @coin_100*100 + @coin_500*500 + @coin_1000*1000
    end

    # これまで投入した金額加算
    def prtCoin
        puts("釣り銭 : " + @coins.to_s)
    end
    # これまでの売り上げ
    def prtSales
        puts("売り上げ : " + @sales.to_s)
    end
    
    # Drink Info 出力
    def prtDrinkInfo
        puts("", "================================Drink Info=================================")
        for i in @drink
            # 投入金額、在庫の点で、製品が購入できるかどうかを確認
            i.changeBuyCheck(@coins)

            if i.getBuyCheck()
                buy = "購入可能"
            else 
                buy = "購入不可"
            end
                
            # Print Drink Info
            if i.getDrinkName.length < 3
                puts(i.getDrinkId.to_s + ". " + i.getDrinkName() + "\t\t\t値段:" + i.getDrinkPrice().to_s + "\t\t在庫:"+i.getDrinkStock().to_s + "\t\t" +buy)
            else
                puts(i.getDrinkId.to_s + ". " + i.getDrinkName() + "\t\t値段:" + i.getDrinkPrice().to_s + "\t\t在庫:"+i.getDrinkStock().to_s + "\t\t" +buy)
            end
        end
        
    end

    # 購入する時
    def buy
        while true
            if @coins == 0 or @coins < 100
                return false
            end
            puts("番号を入力してください。払い戻し:N")
            
            value = gets.chomp()    # drinkIdをもらう
            if value == "N"
                puts()              # 余白
                prtCoin()           # 出力の関数呼出し   
                prtSales()          # 出力の関数呼出し
                return false
            end

            # -投入金額 , +売り上げ (在庫があるとき、金額があるとき)
            for i in @drink
                if value == i.getDrinkId().to_s and @coins >= i.getDrinkPrice() and i.getDrinkStock() != 0 
                    i.buyDrink()
                    @coins -= i.getDrinkPrice()
                    @sales += i.getDrinkPrice()
                end
            end

            prtDrinkInfo()      # 出力の関数呼出し
            prtCoin()           # 出力の関数呼出し   
            prtSales()          # 出力の関数呼出し
        end
    end

end

class Drink
    # Constructor, 基本情報を入れる
    def initialize(id, name, price, stock)
        @drink_id = id
        @drink_name = name
        @drink_price = price
        @drink_stock = stock
        @buyCheck = false           # 購入できるかどうかを確認
    end
    
    def getDrinkId
        return @drink_id
    end
    def getDrinkName
        return @drink_name
    end
    def getDrinkPrice
        return @drink_price
    end
    def getDrinkStock
        return @drink_stock
    end
    def getBuyCheck
        return @buyCheck
    end
    def buyDrink                    # -在庫
        if @drink_stock != 0
            @drink_stock -= 1
        end
    end
    
    def changeBuyCheck(price)      # 購入できるかどうか
        if @drink_price <= price and @drink_stock != 0
            @buyCheck = true
        else
            @buyCheck = false
        end
    end

end

# Main Start
# 製品生産
drink = [
    Drink.new(1, "コーラ", 120, 5), 
    Drink.new(2, "レッドブル", 200, 5), 
    Drink.new(3, "水", 100, 5)]

# 自販機オブジェクト
VD = VendingMachine.new(drink)
VD.prtDrinkInfo()

while true
    puts("insert coin please!!")
    inCoin = gets.chomp()               # 投入金額をもらう
    if VD.insertCoin(inCoin) == 2       # 投入するとき
        VD.prtDrinkInfo()
        VD.prtCoin()
        puts("============================購入:Y, 払い戻し:N=============================")
    elsif VD.insertCoin(inCoin) == 1    # 払い戻すとき, N
        puts()
        VD.prtCoin()
        break
    elsif VD.insertCoin(inCoin) == 0    # 購入するとき, Y
        if VD.buy()
        else
            break
        end
    end
end

puts("**************修了**************")