# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 10. Финальный Capstone-проект — Сквозной ETL/ELT-конвейер фарм-аналитики
# Задача 38 (Модуль 10, Задача 2): Этап 2 ETL — Обогащение справочниками и расчет маржи
# Стандарт: julia-analytics (leftjoin matchmissing=:error, disallowmissing!, sequential transform!)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

stage1_clean_shipments = DataFrame(
    tx_id = ["TX-101", "TX-102", "TX-105", "TX-106"],
    drug_id = [101, 102, 103, 102],
    region_code = ["MSK", "SPB", "NSK", "SPB"],
    packs = [500, 1200, 800, 950],
    base_price = [200.0, 350.0, 420.0, 350.0],
    discount_pct = [5.0, 0.0, 0.0, 7.5],
    net_amount = [95000.0, 420000.0, 336000.0, 307562.5]
)

dim_drugs = DataFrame(
    drug_id = [101, 102, 103],
    drug_name = ["Цефтриаксон", "Амоксиклав", "Гепарин"],
    category = ["Антибиотики", "Антибиотики", "Антикоагулянты"],
    unit_cost = [110.0, 210.0, 260.0]
)

dim_regions = DataFrame(
    region_code = ["MSK", "SPB", "NSK", "EKB"],
    district_name = ["ЦФО", "СЗФО", "СФО", "УФО"]
)

stage2_enriched_shipments = @chain stage1_clean_shipments begin 
    leftjoin(dim_drugs, on = :drug_id, matchmissing = :error)
    leftjoin(dim_regions, on = :region_code, matchmissing = :error)
    disallowmissing!([:drug_name, :category, :unit_cost, :district_name])
    transform!(
        [:net_amount, :packs, :unit_cost] => ((net, pk, cost) -> round.(net .- (pk .* cost), digits = 2)) => :gross_profit
    )
    transform!(
        [:gross_profit, :net_amount] => ((gp, net) -> round.((gp ./ net) .* 100.0, digits = 1)) => :margin_pct
    )
end

println("Этап 2 ETL завершен. Обогащенная витрина отгрузок:")
println(stage2_enriched_shipments)
