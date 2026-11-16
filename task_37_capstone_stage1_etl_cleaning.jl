# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 10. Финальный Capstone-проект — Сквозной ETL/ELT-конвейер фарм-аналитики
# Задача 37 (Модуль 10, Задача 1): Этап 1 ETL — Очистка, коалесценция и фиксация схемы
# Стандарт: julia-analytics (dropmissing!, broadcasted coalesce., disallowmissing!, SIMD net_amount)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

raw_erp_shipments = DataFrame(
    tx_id = ["TX-101", "TX-102", "TX-103", "TX-104", "TX-105", "TX-106"],
    drug_id = [101, 102, missing, 101, 103, 102],
    region_code = ["MSK", "SPB", "EKB", "MSK", "NSK", "SPB"],
    packs = [500, 1200, 300, missing, 800, 950],
    base_price = [200.0, 350.0, 150.0, 200.0, 420.0, 350.0],
    discount_pct = [5.0, missing, 0.0, 10.0, missing, 7.5]
)

stage1_clean_shipments = @chain raw_erp_shipments begin 
    dropmissing!([:drug_id, :packs, :base_price])
    transform!(:discount_pct => (d -> coalesce.(d, 0.0)) => :discount_pct)
    disallowmissing!([:drug_id, :packs, :base_price, :discount_pct])
    transform!(
        [:packs, :base_price, :discount_pct] => ((pk, pr, disc) -> round.(pk .* pr .* (1.0 .- disc ./ 100.0), digits = 2)) => :net_amount
    )
end

println("Этап 1 ETL завершен. Очищенный реестр отгрузок:")
println(stage1_clean_shipments)
