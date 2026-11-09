# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 3. Реляционные операции (Joins) и валидация связей
# Задача 11 (Модуль 3, Задача 3): План-факт анализ по составному ключу с coalesce
# Стандарт: julia-analytics (composite leftjoin, coalesce missing handling, ByRow flags)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

regional_actual_sales = DataFrame(
    manager = ["Смирнов", "Смирнов", "Ковалева", "Ковалева", "Васильев"],
    region = ["Северо-Запад", "Центр", "Юг", "Поволжье", "Центр"],
    actual_packs = [1200, 450, 850, 380, 920]
)

regional_targets = DataFrame(
    manager = ["Смирнов", "Смирнов", "Ковалева", "Васильев"],
    region = ["Северо-Запад", "Центр", "Юг", "Центр"],
    target_packs = [1000, 500, 800, 1100]
)

plan_fact_analysis = @chain regional_actual_sales begin 
    leftjoin(regional_targets, on = [:manager, :region])
    transform(:target_packs => ByRow(t -> coalesce(t, 500)) => :target_packs)
    transform(
        [:actual_packs, :target_packs] => ByRow(-) => :diff_packs,
        [:actual_packs, :target_packs] => ByRow((a, t) -> round((a / t) * 100, digits = 1)) => :plan_pct,
        [:actual_packs, :target_packs] => ByRow(>=) => :is_target_completed
    )
    sort([:manager, order(:actual_packs, rev = true)])
end

println("План-факт анализ региональных продаж:")
println(plan_fact_analysis)
