# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 5. Оконные функции, скользящие агрегации и ранжирование
# Задача 17 (Модуль 5, Задача 1): Помесячный анализ динамики отгрузок (MoM Growth)
# Стандарт: julia-analytics (chronological sort, grouped lag, dynamic growth calculation)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain, ShiftedArrays

brand_monthly_sales = DataFrame(
    drug_name = ["Цефтриаксон", "Амоксиклав", "Цефтриаксон", "Амоксиклав", "Цефтриаксон", "Амоксиклав"],
    month_num = [2, 1, 1, 3, 3, 2],
    packs = [850, 1200, 800, 1400, 920, 1350]
)

monthly_growth_analysis = @chain brand_monthly_sales begin 
    sort([:drug_name, :month_num])
    groupby(:drug_name)
    transform(
        :packs => lag => :prev_packs,
        :packs => (p -> p .- lag(p)) => :diff_packs,
        :packs => (p -> round.(((p .- lag(p)) ./ lag(p)) .* 100, digits = 1)) => :mom_pct
    )
end

println("Анализ помесячной динамики отгрузок препаратов (MoM):")
println(monthly_growth_analysis)
