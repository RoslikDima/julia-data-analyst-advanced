# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 1. Векторная алгебра, статистика и фильтрация выбросов
# Задача 02 (Модуль 1, Задача 2): Модифицированный Z-score на основе MAD
# Стандарт: julia-analytics (median, MAD, ByRow mod_z_score, sort by=abs)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain, Statistics

query_latency = DataFrame(
    query_id = [501, 502, 503, 504, 505, 506, 507, 508],
    report_type = ["P&L", "Balance", "Sales", "Sales", "P&L", "Inventory", "Sales", "Balance"],
    latency_ms = [240.0, 255.0, 248.0, 260.0, 1850.0, 242.0, 250.0, 15.0]
)

# 1. Расчет робастных скаляров
med = median(query_latency.latency_ms)
mad_val = median(abs.(query_latency.latency_ms .- med))

# 2. Вычисление модифицированного Z-score
latency_audit = @chain query_latency begin 
    transform(
        :latency_ms => ByRow(lat -> round(0.6745 * (lat - med) / mad_val, digits = 2)) => :mod_z_score
    )
    transform(
        :mod_z_score => ByRow(z -> abs(z) > 3.5) => :is_anomaly
    )
    sort(:mod_z_score, by = abs, rev = true)
end

println("Аудит латентности запросов (модифицированный Z-score):")
println(latency_audit)
