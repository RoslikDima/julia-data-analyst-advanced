# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 4. Решейпинг данных (stack, unstack) и подготовка матриц отчетов
# Задача 13 (Модуль 4, Задача 1): Нормализация квартального отчета из Wide в Long
# Стандарт: julia-analytics (stack unpivot, string parsing, sorting)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

distributor_wide_sales = DataFrame(
    distributor = ["Протек", "Протек", "Катрен", "Катрен"],
    drug_name = ["Амоксиклав", "Цефтриаксон", "Амоксиклав", "Цефтриаксон"],
    m01 = [1200, 850, 950, 600],
    m02 = [1400, 900, 1100, 620],
    m03 = [1350, 950, 1050, 700]
)

distributor_long_sales = @chain distributor_wide_sales begin 
    stack(
        [:m01, :m02, :m03], 
        [:distributor, :drug_name],
        variable_name = :month,
        value_name = :packs
    )
    transform(
        :month => ByRow(m -> parse(Int, replace(String(m), "m" => ""))) => :month_num
    )
    sort([:distributor, :drug_name, :month_num])
end

println("Нормализованные продажи дистрибьюторов (Long format):")
println(distributor_long_sales)
