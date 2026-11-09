# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 4. Решейпинг данных (stack, unstack) и подготовка матриц отчетов
# Задача 14 (Модуль 4, Задача 2): Построение кросс-таблицы (Pivot Matrix) каналов сбыта
# Стандарт: julia-analytics (pre-aggregation, unstack fill=0, ByRow(+) row total)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

raw_sales = DataFrame(
    client_segment = ["Госпитальный", "Розница", "Госпитальный", "Розница", "Госпитальный", "Аптечные сети"],
    drug_name = ["Цефтриаксон", "Амоксиклав", "Цефтриаксон", "Цефтриаксон", "Гепарин", "Амоксиклав"],
    packs = [5000, 1200, 3000, 800, 1500, 2400]
)

sales_pivot_matrix = @chain raw_sales begin 
    groupby([:client_segment, :drug_name])
    combine(:packs => sum => :total_packs)
    unstack(
        :client_segment,
        :drug_name,
        :total_packs,
        fill = 0
    )
    transform(
        [:Амоксиклав, :Гепарин, :Цефтриаксон] => ByRow(+) => :total_segment_packs
    )
    sort(:total_segment_packs, rev = true)
end

println("Сводная матрица поставок по каналам сбыта:")
println(sales_pivot_matrix)
