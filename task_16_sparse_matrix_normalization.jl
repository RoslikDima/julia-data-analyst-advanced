# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 4. Решейпинг данных (stack, unstack) и подготовка матриц отчетов
# Задача 16 (Модуль 4, Задача 4): Нормализация разреженной матрицы и расчет рыночных долей
# Стандарт: julia-analytics (stack unpivot, dropmissing, grouped window share transform)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

sparse_regional_matrix = DataFrame(
    region = ["Центр", "Северо-Запад", "Юг", "Сибирь"],
    Амоксиклав = [1400, 950, missing, 600],
    Цефтриаксон = [800, missing, 1200, 450],
    Омепразол = [500, 300, 400, missing]
)

regional_portfolio_shares = @chain sparse_regional_matrix begin 
    stack(
        [:Амоксиклав, :Цефтриаксон, :Омепразол],
        :region,
        variable_name = :drug_name,
        value_name = :packs
    )
    dropmissing(:packs)
    groupby(:region)
    transform(
        :packs => (p -> round.((p ./ sum(p)) .* 100, digits = 1)) => :share_pct
    )
    sort([:region, order(:share_pct, rev = true)])
end

println("Нормализованные продажи и рыночные доли по регионам:")
println(regional_portfolio_shares)
