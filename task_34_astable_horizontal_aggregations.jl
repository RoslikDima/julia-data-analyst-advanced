# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 9. Продвинутый метапрограмминг столбцов (Cols, All, Between, Not)
# Задача 34 (Модуль 9, Задача 2): Горизонтальная агрегация квартальных KPI филиалов
# Стандарт: julia-analytics (AsTable dynamic selector, ByRow sum/mean/maximum)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain, Statistics

clean_quarterly_mln = DataFrame(
    branch = ["Москва", "Санкт-Петербург", "Екатеринбург", "Новосибирск"],
    drug_name = ["Цефтриаксон", "Амоксиклав", "Гепарин", "Омепразол"],
    jan_mln = [12.5, 0.0, 8.4, 4.15],
    feb_mln = [14.2, 9.8, 0.0, 4.6],
    mar_mln = [15.1, 11.3, 9.1, 0.0]
)

branch_q1_kpi = @chain clean_quarterly_mln begin 
    transform!(
        AsTable(Cols(r"_mln$")) => ByRow(sum) => :q1_total_mln,
        AsTable(Cols(r"_mln$")) => ByRow(r -> round(mean(r), digits = 2)) => :avg_month_mln,
        AsTable(Cols(r"_mln$")) => ByRow(maximum) => :peak_month_mln
    )
    sort(:q1_total_mln, rev = true)
end

println("Сводный рейтинг филиалов по квартальным KPI:")
println(branch_q1_kpi)
