# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 10. Финальный Capstone-проект — Сквозной ETL/ELT-конвейер фарм-аналитики
# Задача 40 (Модуль 10, Задача 4, Финал курса): Этап 4 ETL — Финализация BI-витрины
# Стандарт: julia-analytics (Cols regex, Int32/Float32 downcasting, select! All(), describe audit)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

stage3_analytics_cube = DataFrame(
    district_name = ["СЗФО", "СФО", "ЦФО"],
    category = ["Антибиотики", "Антикоагулянты", "Антибиотики"],
    tx_count = [2, 1, 1],
    total_packs = [2150, 800, 500],
    total_net_amount = [727562.5, 336000.0, 95000.0],
    total_gross_profit = [276062.5, 128000.0, 40000.0],
    weighted_margin_pct = [37.9, 38.1, 42.1]
)

final_bi_executive_mart = @chain stage3_analytics_cube begin 
    transform!(Cols(r"^total_(net|gross)") .=> (x -> round.(x ./ 1_000_000.0, digits = 3)), renamecols = false)
    rename!(:total_net_amount => :net_sales_mln, :total_gross_profit => :gross_profit_mln)
    transform!(
        Cols([:tx_count, :total_packs]) .=> (x -> Int32.(x)),
        Cols(col -> eltype(stage3_analytics_cube[!, col]) <: AbstractFloat) .=> (x -> Float32.(x)),
        renamecols = false
    )
    select!(:district_name, :category, :net_sales_mln, :gross_profit_mln, :weighted_margin_pct, All())
end

println("Финальная витрина BI Executive Mart:")
println(final_bi_executive_mart)

println("\nПаспорт качества витрины:")
println(describe(final_bi_executive_mart, :nmissing, :eltype))
