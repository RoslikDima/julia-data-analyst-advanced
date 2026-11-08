# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 2. Сложные цепочки агрегаций и мульти-метрики
# Задача 08 (Модуль 2, Задача 4): Кумулятивная выручка (cumsum) и выполнение плана
# Стандарт: julia-analytics (sort timeline, grouped cumsum, ByRow target completion flag)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

weekly_sales = DataFrame(
    manager = ["Сидоров", "Кузнецова", "Сидоров", "Кузнецова", "Сидоров", "Кузнецова", "Сидоров", "Кузнецова"],
    week_num = [1, 1, 2, 2, 3, 3, 4, 4],
    weekly_revenue = [250000.0, 380000.0, 310000.0, 420000.0, 290000.0, 350000.0, 340000.0, 210000.0]
)

target_revenue = 1_000_000.0

cum_sales_analysis = @chain weekly_sales begin
    sort([:manager, :week_num])
    groupby(:manager)
    transform(:weekly_revenue => cumsum => :cum_revenue)
    transform(:cum_revenue => ByRow(c -> round((c / target_revenue) * 100, digits = 1)) => :plan_completion_pct)
    transform(:cum_revenue => ByRow(c -> c >= target_revenue) => :is_plan_reached)
end

println("Кумулятивная динамика выполнения квартального плана:")
println(cum_sales_analysis)
