# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 7. Оптимизация памяти, профилирование и бенчмаркинг конвейеров
# Задача 25 (Модуль 7, Задача 1): Сравнительный бенчмаркинг transform vs transform!
# Стандарт: julia-analytics (BenchmarkTools @btime, in-place mutation transform!)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain, BenchmarkTools

n = 100_000
sales_large = DataFrame(
    drug_id = rand(1:50, n),
    packs = rand(10:500, n),
    price = rand(150.0:10.0:1200.0, n)
)

@btime transform($sales_large, [:packs, :price] => ByRow(*) => :revenue)
@btime transform!(d, [:packs, :price] => ByRow(*) => :revenue) setup = (d = copy($sales_large)) evals = 1

@chain sales_large begin 
    transform!([:packs, :price] => ByRow(*) => :revenue)
    transform!(:revenue => ByRow(r -> r * 0.10) => :vat_amount)
end

println("Первые 5 строк модифицированной на месте таблицы sales_large:")
println(first(sales_large, 5))
