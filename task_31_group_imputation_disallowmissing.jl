# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 8. Продвинутая аналитика пропусков (missing), коалесценция и импутация данных
# Задача 31 (Модуль 8, Задача 3): Восстановление пропущенных цен внутри групп (Group Imputation)
# Стандарт: julia-analytics (groupby transform! coalesce., mean skipmissing, disallowmissing!)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain, Statistics

regional_price_gaps = DataFrame(
    region = ["Центр", "Юг", "Сибирь", "Центр", "Юг", "Сибирь"],
    drug_name = ["Цефтриаксон", "Цефтриаксон", "Цефтриаксон", "Амоксиклав", "Амоксиклав", "Амоксиклав"],
    packs = [1000, 1500, 800, 2000, 1200, 900],
    price_rub = [180.0, missing, 200.0, 310.0, 330.0, missing]
)

imputed_sales_report = @chain regional_price_gaps begin 
    groupby(:drug_name)
    transform!(:price_rub => (p -> coalesce.(p, mean(skipmissing(p)))) => :price_rub)
    disallowmissing!(:price_rub)   
    transform!(
        [:packs, :price_rub] => ((pk, pr) -> pk .* pr) => :revenue_rub
    )
    sort(:revenue_rub, rev = true)
end

println("Витрина продаж после групповой импутации пропущенных цен:")
println(imputed_sales_report)
