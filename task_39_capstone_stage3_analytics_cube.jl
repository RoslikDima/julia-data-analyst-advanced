# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 10. Финальный Capstone-проект — Сквозной ETL/ELT-конвейер фарм-аналитики
# Задача 39 (Модуль 10, Задача 3): Этап 3 ETL — Сборка аналитического куба по округам и категориям
# Стандарт: julia-analytics (composite groupby, nrow, dynamic .=> naming, weighted margin)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

stage2_enriched_shipments = DataFrame(
    tx_id = ["TX-101", "TX-102", "TX-105", "TX-106"],
    drug_id = [101, 102, 103, 102],
    region_code = ["MSK", "SPB", "NSK", "SPB"],
    packs = [500, 1200, 800, 950],
    base_price = [200.0, 350.0, 420.0, 350.0],
    discount_pct = [5.0, 0.0, 0.0, 7.5],
    net_amount = [95000.0, 420000.0, 336000.0, 307562.5],
    drug_name = ["Цефтриаксон", "Амоксиклав", "Гепарин", "Амоксиклав"],
    category = ["Антибиотики", "Антибиотики", "Антикоагулянты", "Антибиотики"],
    unit_cost = [110.0, 210.0, 260.0, 210.0],
    district_name = ["ЦФО", "СЗФО", "СФО", "СЗФО"],
    gross_profit = [40000.0, 168000.0, 128000.0, 108062.5],
    margin_pct = [42.1, 40.0, 38.1, 35.1]
)

stage3_analytics_cube = @chain stage2_enriched_shipments begin 
    groupby([:district_name, :category])
    combine(
        nrow => :tx_count,
        [:packs, :net_amount, :gross_profit] .=> sum .=> (name -> string("total_", name))
    )
    transform!(
        [:total_gross_profit, :total_net_amount] => ((gp, net) -> round.((gp ./ net) .* 100.0, digits = 1)) => :weighted_margin_pct
    )
    sort(:total_net_amount, rev = true)
end

println("Этап 3 ETL завершен. Аналитический куб по округам и категориям:")
println(stage3_analytics_cube)
