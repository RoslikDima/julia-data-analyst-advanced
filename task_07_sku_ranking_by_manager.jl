# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 2. Сложные цепочки агрегаций и мульти-метрики
# Задача 07 (Модуль 2, Задача 3): Внутригрупповой рейтинг препаратов по выручке менеджеров
# Стандарт: julia-analytics (sort with order, grouped eachindex window rank, is_top1 flag)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

sku_sales = DataFrame(
    manager = ["Иванов", "Иванов", "Петров", "Иванов", "Петров", "Петров", "Иванов", "Петров"],
    drug_name = ["Амоксиклав", "Гепарин", "Амоксиклав", "Амоксиклав", "Цефтриаксон", "Гепарин", "Цефтриаксон", "Цефтриаксон"],
    packs = [400, 150, 600, 350, 1200, 80, 500, 450],
    price = [550.0, 120.0, 530.0, 560.0, 210.0, 125.0, 220.0, 215.0]
)

sku_ranking = @chain sku_sales begin 
    transform([:packs, :price] => ByRow(*) => :revenue)
    groupby([:manager, :drug_name])
    combine(:revenue => sum => :drug_revenue)
    sort([:manager, order(:drug_revenue, rev = true)])
    groupby(:manager)
    transform(:drug_revenue => eachindex => :rank)
    transform(:rank => ByRow(r -> r == 1) => :is_top1)
end

println("Рейтинг препаратов по менеджерам отдела продаж:")
println(sku_ranking)
