# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 5. Оконные функции, скользящие агрегации и ранжирование
# Задача 19 (Модуль 5, Задача 3): Внутригрупповое ранжирование менеджеров и фильтрация ТОП-N
# Стандарт: julia-analytics (ordered grouped transform, range indexing, subset filtering)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

sales_rep_performance = DataFrame(
    division = ["Розница", "Госпитальный", "Розница", "Госпитальный", "Розница", "Госпитальный", "Розница"],
    manager = ["Иванов", "Петрова", "Сидоров", "Смирнов", "Кузнецова", "Васильев", "Попов"],
    revenue_mln = [4.2, 8.5, 3.8, 9.1, 5.0, 7.4, 2.9]
)

top_managers_by_division = @chain sales_rep_performance begin 
    sort([:division, order(:revenue_mln, rev = true)])
    groupby(:division)
    transform(:revenue_mln => (r -> 1:length(r)) => :rank_in_div)
    subset(:rank_in_div => ByRow(r -> r <= 2))
end

println("ТОП-2 менеджеров по продажам в каждом дивизионе:")
println(top_managers_by_division)
