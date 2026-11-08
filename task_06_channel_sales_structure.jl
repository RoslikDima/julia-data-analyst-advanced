# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 2. Сложные цепочки агрегаций и мульти-метрики
# Задача 06 (Модуль 2, Задача 2): Анализ структуры каналов продаж менеджеров
# Стандарт: julia-analytics (multi-groupby, nested transform share, ByRow core flag)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

channel_sales = DataFrame(
    manager = ["Морозова", "Морозова", "Морозова", "Зайцев", "Зайцев", "Волков", "Волков", "Волков"],
    channel = ["Hospital", "Retail", "Hospital", "Hospital", "Retail", "Retail", "Hospital", "Retail"],
    packs = [500, 200, 800, 1500, 400, 600, 300, 700],
    price = [600.0, 350.0, 580.0, 620.0, 340.0, 320.0, 610.0, 330.0]
)

channel_structure = @chain channel_sales begin 
    transform(
        [:packs, :price] => ByRow(*) => :revenue
    )
    groupby([:manager, :channel])
    combine(
        :revenue => sum => :channel_revenue 
    )
    groupby(:manager)
    transform(
        :channel_revenue => (r -> round.(r ./ sum(r) .* 100, digits = 1)) => :channel_share_pct
    )
    transform(
        :channel_share_pct => ByRow(c -> c >= 60.0) => :is_core_channel 
    )
    sort([:manager, order(:channel_revenue, rev = true)])
end

println("Структура каналов продаж по региональным менеджерам:")
println(channel_structure)
