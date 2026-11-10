# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 5. Оконные функции, скользящие агрегации и ранжирование
# Задача 18 (Модуль 5, Задача 2): Нарастающий итог (cumsum) и выполнение годовой квоты (YTD)
# Стандарт: julia-analytics (chronological sort, grouped cumsum, quota progress)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

manager_quarterly_sales = DataFrame(
    manager = ["Смирнов", "Ковалева", "Смирнов", "Ковалева", "Смирнов", "Ковалева", "Смирнов", "Ковалева"],
    quarter = [2, 1, 1, 3, 4, 2, 3, 4],
    packs = [1200, 1100, 1500, 1400, 1100, 1300, 1300, 1500]
)

ytd_quota_analysis = @chain manager_quarterly_sales begin 
    sort([:manager, :quarter])
    groupby(:manager)
    transform(:packs => cumsum => :ytd_packs)
    transform(
        :ytd_packs => ByRow(y -> round((y / 5000) * 100, digits = 1)) => :quota_pct,
        :ytd_packs => ByRow(y -> y >= 5000) => :is_quota_reached
    )
end

println("Анализ накопительного YTD и выполнения годовой квоты менеджерами:")
println(ytd_quota_analysis)
