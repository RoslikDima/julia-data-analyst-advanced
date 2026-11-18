# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Блок 2. Функциональное программирование и метапрограммирование столбцов в Julia
# Задача 1: Мутирующая функция стандартизации и сжатия денежных столбцов (normalize_rub_cols!)
# Стандарт: julia-analytics (::AbstractDataFrame, keyword defaults, Cols(pattern) .=>, Float32)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

function normalize_rub_cols!(
    df::AbstractDataFrame;
    pattern::Regex = r"_rub$",
    divisor::Float64 = 1_000_000.0,
    digits::Int = 2
)
    @chain df begin
        transform!(Cols(pattern) .=> (x -> coalesce.(x, 0.0)), renamecols = false)
        disallowmissing!(Cols(pattern))
        transform!(
            Cols(pattern) .=> (x -> Float32.(round.(x ./ divisor, digits = digits))),
            renamecols = false
        )
    end
    return df
end

q1_financials = DataFrame(
    region = ["ЦФО", "СЗФО", "УФО", "СФО"],
    sales_rub = [15_450_000.0, 9_820_000.0, 6_110_000.0, missing],
    cost_rub = [9_120_000.0, 5_940_000.0, missing, 3_400_000.0],
    packs = [4500, 2900, 1800, 1500]
)

normalize_rub_cols!(q1_financials)

println("Стандартизированная таблица (млн руб., Float32):")
println(q1_financials)
println("\nАудит типов:")
println(describe(q1_financials, :nmissing, :eltype))
