# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 7. Оптимизация памяти, профилирование и бенчмаркинг конвейеров
# Задача 27 (Модуль 7, Задача 3): Бенчмарк ByRow против SIMD-векторизации (ifelse.)
# Стандарт: julia-analytics (BenchmarkTools @btime, fused broadcasting, in-place transform!)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain, BenchmarkTools

n = 100_000
sales_large = DataFrame(
    drug_id = rand(1:50, n),
    packs = rand(10:500, n),
    price = rand(150.0:10.0:1200.0, n)
)
transform!(sales_large, [:packs, :price] => ((p, pr) -> p .* pr) => :revenue)

# 1. Замеры производительности (ByRow vs SIMD ifelse.)
@btime transform!(d, [:packs, :revenue] => ByRow((p, r) -> p > 300 ? r * 0.07 : 0.0) => :bonus) setup = (d = copy($sales_large)) evals = 1
@btime transform!(d, [:packs, :revenue] => ((p, r) -> ifelse.(p .> 300, r .* 0.07, 0.0)) => :bonus) setup = (d = copy($sales_large)) evals = 1

# 2. Векторное обновление витрины на месте
result = @chain sales_large begin 
    transform!(
        [:packs, :revenue] => ((p, r) -> ifelse.(p .> 300, r .* 0.07, 0.0)) => :bonus
    )
    transform!([:revenue, :bonus] => ((r, b) -> r .- b) => :net_revenue)
    first(5)
end

println("Первые 5 строк витрины после векторного расчета бонусов и чистой выручки:")
println(result)
