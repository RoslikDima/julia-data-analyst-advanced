# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 9. Продвинутый метапрограмминг столбцов (Cols, All, Between, Not)
# Задача 33 (Модуль 9, Задача 1): Пакетная очистка и масштабирование квартальной выручки
# Стандарт: julia-analytics (Cols regex selector, Between range, renamecols=false, disallowmissing!)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

branch_quarterly_sales = DataFrame(
    branch = ["Москва", "Санкт-Петербург", "Екатеринбург", "Новосибирск"],
    drug_name = ["Цефтриаксон", "Амоксиклав", "Гепарин", "Омепразол"],
    jan_rub = [12_500_000.0, missing, 8_400_000.0, 4_150_000.0],
    feb_rub = [14_200_000.0, 9_800_000.0, missing, 4_600_000.0],
    mar_rub = [15_100_000.0, 11_300_000.0, 9_100_000.0, missing]
)

clean_quarterly_mln = @chain branch_quarterly_sales begin 
    transform!(Cols(r"_rub$") .=> (x -> coalesce.(x, 0.0)), renamecols = false)
    disallowmissing!(Cols(r"_rub$"))
    transform!(Between(:jan_rub, :mar_rub) .=> (x -> round.(x ./ 1_000_000.0, digits = 2)), renamecols = false)
    rename!(:jan_rub => :jan_mln, :feb_rub => :feb_mln, :mar_rub => :mar_mln)
end

println("Квартальная выручка филиалов в млн руб.:")
println(clean_quarterly_mln)
