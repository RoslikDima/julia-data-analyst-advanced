# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 6. Продвинутая трансформация текста, дат и категориальных признаков
# Задача 22 (Модуль 6, Задача 2): Стандартизация категориальных справочников и факторизация
# Стандарт: julia-analytics (vectorized string clean, broadcasted categorical, group aggregation)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, CategoricalArrays, Chain

messy_channel_sales = DataFrame(
    region = ["Центр", "Центр", "Юг", "Юг", "Центр"],
    sales_channel = ["  госпитальный ", "ГОСПИТАЛЬНЫЙ", "розница  ", "  Розница", "госпитальный"],
    packs = [1200, 1800, 900, 1100, 1500]
)

channel_category_summary = @chain messy_channel_sales begin 
    transform(:sales_channel => (s -> lowercase.(strip.(s))) => :clean_channel)
    transform([:region, :clean_channel] .=> categorical .=> [:region, :clean_channel])
    groupby([:region, :clean_channel])
    combine(:packs => sum => :total_packs)
    sort(:total_packs, rev = true)
end

println("Итоги продаж по стандартизированным каналам сбыта:")
println(channel_category_summary)
