# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 7. Оптимизация памяти, профилирование и бенчмаркинг конвейеров
# Задача 28 (Модуль 7, Задача 4): Финальная компрессия витрины (select! + даункастинг)
# Стандарт: julia-analytics (Base.summarysize, select! in-place, Int16/Float32 downcasting)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

n = 100_000
sales_large = DataFrame(
    drug_id = rand(1:50, n),
    packs = rand(10:500, n),
    price = rand(150.0:10.0:1200.0, n)
)
@chain sales_large begin
    transform!([:packs, :price] => ((p, pr) -> p .* pr) => :revenue)
    transform!([:packs, :revenue] => ((p, r) -> ifelse.(p .> 300, r .* 0.07, 0.0)) => :bonus)
    transform!([:revenue, :bonus] => ((r, b) -> r .- b) => :net_revenue)
end

size_before = Base.summarysize(sales_large)

@chain sales_large begin
    select!([:drug_id, :net_revenue])
    transform!(
        :drug_id => (x -> Int16.(x)) => :drug_id,
        :net_revenue => (x -> Float32.(x)) => :net_revenue
    )
end

size_after = Base.summarysize(sales_large)
saved_pct = round((1 - size_after / size_before) * 100, digits = 1)

println("Сжатие витрины: с $(size_before) до $(size_after) байт (экономия $(saved_pct)%)")
