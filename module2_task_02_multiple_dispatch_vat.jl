# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Блок 2. Функциональное программирование и метапрограммирование столбцов в Julia
# Задача 2: Множественная диспетчеризация (Multiple Dispatch) — calc_vat_amount
# Стандарт: julia-analytics (Float64 vs AbstractVector{Float64}, broadcasted .*, keyword defaults)
# ==============================================================================

# Авторское решение (Dima Roslik):

# Метод 1 (скалярный — для одиночного значения Float64)
function calc_vat_amount(
    amount::Float64;
    vat_rate::Float64 = 0.10,
    digits::Int = 2
)
    vat = round(amount * vat_rate, digits = digits)
    return vat
end

# Метод 2 (векторный — для списка значений AbstractVector{Float64})
function calc_vat_amount(
    amounts::AbstractVector{Float64};
    vat_rate::Float64 = 0.10,
    digits::Int = 2
)
    vats = round.(amounts .* vat_rate, digits = digits)
    return vats
end

println("Скалярный расчет НДС (10% от 500.0): ", calc_vat_amount(500.0))
println("Векторный расчет НДС (20% от [500.0, 1200.0]): ", calc_vat_amount([500.0, 1200.0], vat_rate = 0.20))
