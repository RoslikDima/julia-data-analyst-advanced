# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 9. Продвинутый метапрограмминг столбцов (Cols, All, Between, Not)
# Задача 36 (Модуль 9, Задача 4): Комплексная реструктуризация витрины (All() + AsTable)
# Стандарт: julia-analytics (AsTable Cols regex, SIMD percentage share, select! All() ordering)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

district_dynamic_summary = DataFrame(
    district = ["ЦФО", "СЗФО", "УФО"],
    sum_jan_mln = [20.8, 16.2, 4.2],
    sum_feb_mln = [23.4, 17.6, 4.6],
    sum_mar_mln = [25.1, 19.2, 5.0]
)

executive_district_mart = @chain district_dynamic_summary begin 
    transform!(AsTable(Cols(r"^sum_")) => ByRow(sum) => :q1_grand_total)
    transform!([:sum_mar_mln, :q1_grand_total] => ((m, tot) -> round.((m ./ tot) .* 100.0, digits = 1)) => :mar_share_pct)
    select!(:district, :q1_grand_total, :mar_share_pct, All())
end

println("Финальная витрина по федеральным округам:")
println(executive_district_mart)
