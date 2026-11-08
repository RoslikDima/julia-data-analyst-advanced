# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 1. Векторная алгебра, статистика и фильтрация выбросов
# Задача 04 (Модуль 1, Задача 4): Расчет средневзвешенной цены тендеров (VWAP) и демпинга
# Стандарт: julia-analytics (vector product .*, ByRow closure with scalar benchmark, boolean flag)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

hospital_tenders = DataFrame(
    tender_id = [701, 702, 703, 704, 705, 706],
    manager = ["Смирнов", "Васильев", "Смирнов", "Кузнецова", "Васильев", "Кузнецова"],
    packs_ordered = [500, 10000, 1200, 300, 15000, 2000],
    unit_price = [650.0, 580.0, 620.0, 710.0, 540.0, 600.0]
)

total_revenue = sum(hospital_tenders.packs_ordered .* hospital_tenders.unit_price)
total_packs = sum(hospital_tenders.packs_ordered)
benchmark_price = round(total_revenue / total_packs, digits = 2)

tender_price_analysis = @chain hospital_tenders begin
    transform(
        :unit_price => ByRow(u -> round(((u - benchmark_price) / benchmark_price) * 100, digits = 1)) => :price_delta_pct
    )
    transform(
        :price_delta_pct => ByRow(p -> p < -8.0) => :is_dumping
    )
    sort(:unit_price)
end

println("Средневзвешенная рыночная цена: ", benchmark_price, " руб.")
println(tender_price_analysis)
