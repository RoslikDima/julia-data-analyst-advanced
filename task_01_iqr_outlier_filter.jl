# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 1. Векторная алгебра, статистика и фильтрация выбросов
# Задача 01 (Модуль 1, Задача 1): Робастная фильтрация аномалий методом IQR
# Стандарт: julia-analytics (Tukey's IQR fences, ByRow outlier flag, subset(!))
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain, Statistics

batch_production = DataFrame(
    batch_id = [101, 102, 103, 104, 105, 106, 107, 108, 109, 110],
    drug_name = fill("Гепарин", 10),
    volume_liters = [120.5, 118.0, 122.3, 15.0, 119.4, 121.0, 117.8, 450.0, 120.0, 119.9]
)

# Вычисление робастных статистик по вектору
q1 = quantile(batch_production.volume_liters, 0.25)
q3 = quantile(batch_production.volume_liters, 0.75)
iqr = q3 - q1

lower_bound = q1 - 1.5 * iqr
upper_bound = q3 + 1.5 * iqr

# Пайплайн очистки данных
clean_production = @chain batch_production begin
    transform(
        :volume_liters => ByRow(v -> v < lower_bound || v > upper_bound) => :is_outlier
    )
    subset(:is_outlier => ByRow(!))
    sort(:volume_liters)
end

println("Очищенный реестр партий (фильтрация IQR):")
println(clean_production)
