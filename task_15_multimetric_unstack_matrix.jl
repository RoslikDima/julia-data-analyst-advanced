# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 4. Решейпинг данных (stack, unstack) и подготовка матриц отчетов
# Задача 15 (Модуль 4, Задача 3): Мульти-метрическая матрица отгрузок дистрибьюторам
# Стандарт: julia-analytics (2-step stack/unstack, multi-input ByRow string naming)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

distributor_dual_metrics = DataFrame(
    distributor = ["Протек", "Протек", "Катрен", "Катрен"],
    drug_name = ["Амоксиклав", "Цефтриаксон", "Амоксиклав", "Цефтриаксон"],
    packs = [1200, 850, 950, 600],
    revenue = [540000.0, 612000.0, 427500.0, 432000.0]
)

distributor_metrics_matrix = @chain distributor_dual_metrics begin 
    stack(
        [:packs, :revenue],
        [:distributor, :drug_name],
        variable_name = :metric,
        value_name = :value
    )
    transform([:drug_name, :metric] => ByRow((d, m) -> string(d, "_", m)) => :col_name)
    unstack(
        :distributor,
        :col_name,
        :value,
        fill = 0.0
    )
    sort(:distributor)
end

println("Мульти-метрическая сводная матрица отгрузок:")
println(distributor_metrics_matrix)
