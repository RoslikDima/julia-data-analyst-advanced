# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 8. Продвинутая аналитика пропусков (missing), коалесценция и импутация данных
# Задача 29 (Модуль 8, Задача 1): Аудит пропусков и расчет чистых продаж дистрибьюторов
# Стандарт: julia-analytics (broadcasted coalesce., skipmissing iterator, count ismissing)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain, Statistics

distributors_report = DataFrame(
    distributor = ["Протек", "Катрен", "Протек", "Пульс", "Катрен", "Пульс", "Протек"],
    drug_name = ["Цефтриаксон", "Амоксиклав", "Гепарин", "Цефтриаксон", "Омепразол", "Гепарин", "Амоксиклав"],
    revenue_rub = [450_000.0, missing, 320_000.0, 510_000.0, 180_000.0, missing, missing],
    logistics_bonus_rub = [15_000.0, missing, missing, 20_000.0, 5_000.0, missing, 10_000.0]
)

distributor_audit_summary = @chain distributors_report begin 
    transform!(
        :logistics_bonus_rub => (b -> coalesce.(b, 0.0)) => :logistics_bonus_rub
    )
    groupby(:distributor)
    combine(
        :revenue_rub => (r -> count(ismissing, r)) => :missing_revenue_rows,
        :revenue_rub => (r -> sum(skipmissing(r))) => :clean_revenue,
        :logistics_bonus_rub => sum => :total_bonus
    )
    transform!(
        [:clean_revenue, :total_bonus] => ((rev, bon) -> rev .+ bon) => :total_payout
    )
    sort(:total_payout, rev = true)
end

println("Аудит пропусков и расчет чистых выплат по дистрибьюторам:")
println(distributor_audit_summary)
