# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 5. Оконные функции, скользящие агрегации и ранжирование
# Задача 20 (Модуль 5, Задача 4): Анализ регулярности закупок аптечных сетей через lead
# Стандарт: julia-analytics (chronological sort, grouped lead, gap calculation, churn flag)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain, ShiftedArrays

pharmacy_orders = DataFrame(
    pharmacy_chain = ["36.6", "Ригла", "36.6", "Ригла", "36.6", "Ригла"],
    month_num = [1, 2, 4, 1, 2, 5],
    order_id = [101, 102, 103, 104, 105, 106]
)

retention_gap_analysis = @chain pharmacy_orders begin 
    sort([:pharmacy_chain, :month_num])
    groupby(:pharmacy_chain)
    transform(:month_num => ShiftedArrays.lead => :next_order_month)
    transform(
        [:next_order_month, :month_num] => ByRow((nxt, cur) -> ismissing(nxt) ? missing : nxt - cur) => :month_gap
    )
    transform(
        :month_gap => ByRow(gap -> ismissing(gap) || gap > 1) => :is_churn_alert
    )
end

println("Анализ регулярности заказов аптечных сетей (Lead Gap Analysis):")
println(retention_gap_analysis)
