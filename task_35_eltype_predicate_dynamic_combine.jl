# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 9. Продвинутый метапрограмминг столбцов (Cols, All, Between, Not)
# Задача 35 (Модуль 9, Задача 3): Динамическая групповая агрегация и предикат типов
# Стандарт: julia-analytics (eltype predicate selector, dynamic string naming in combine)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

federal_district_sales = DataFrame(
    district = ["ЦФО", "ЦФО", "СЗФО", "СЗФО", "УФО"],
    drug_name = ["Цефтриаксон", "Амоксиклав", "Цефтриаксон", "Гепарин", "Омепразол"],
    pharmacies_cnt = [420, 380, 290, 310, 215],
    jan_mln = [12.54, 8.32, 9.81, 6.44, 4.18],
    feb_mln = [14.21, 9.15, 10.45, 7.12, 4.63],
    mar_mln = [15.12, 10.04, 11.33, 7.89, 5.05]
)

district_dynamic_summary = @chain federal_district_sales begin 
    transform!(
        Cols(col -> eltype(federal_district_sales[!, col]) <: AbstractFloat) .=> (x -> round.(x, digits = 1)),
        renamecols = false
    )
    groupby(:district)
    combine(
        Cols(r"_mln$") .=> sum .=> (name -> string("sum_", name))
    )
    sort(:sum_mar_mln, rev = true)
end

println("Сводная динамическая агрегация по федеральным округам:")
println(district_dynamic_summary)
