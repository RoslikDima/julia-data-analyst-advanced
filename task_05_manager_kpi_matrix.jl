# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 2. Сложные цепочки агрегаций и мульти-метрики
# Задача 05 (Модуль 2, Задача 1): Сводная матрица квартальных KPI региональных менеджеров
# Стандарт: julia-analytics (groupby, combine multi-column vectors, lambda unique, sort)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

pharma_sales_log = DataFrame(
    deal_id = [1, 2, 3, 4, 5, 6, 7, 8],
    manager = ["Волков", "Морозова", "Волков", "Зайцев", "Морозова", "Волков", "Зайцев", "Морозова"],
    client_name = ["Аптека 36.6", "ГКБ 1", "Ригла", "ГКБ 52", "Аптека 36.6", "Аптека 36.6", "ГКБ 52", "Планета Здоровья"],
    packs = [400, 1200, 650, 2500, 300, 900, 1100, 800],
    price_per_pack = [320.0, 540.0, 310.0, 610.0, 330.0, 315.0, 590.0, 340.0]
)

result = @chain pharma_sales_log begin
    groupby(:manager)
    combine(
        [:packs, :price_per_pack] => ((ps, pp) -> round(Int, sum(ps .* pp))) => :total_revenue,
        :packs => sum => :total_packs,
        :client_name => (c -> length(unique(c))) => :unique_clients,
        [:packs, :price_per_pack] => ((ps, pp) -> round(sum(ps .* pp) / length(ps), digits = 1)) => :avg_deal_revenue
    )
    sort(:total_revenue, rev = true)
end

println("Сводная витрина квартальных KPI менеджеров:")
println(result)
