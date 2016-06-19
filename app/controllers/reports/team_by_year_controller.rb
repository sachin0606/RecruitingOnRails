class Reports::TeamByYearController < ApplicationController
  def index
  end

  def run
    candidates = Candidate.by_status_code('FIRED')
    candidates << Candidate.by_status_code('HIRED')
    candidates << Candidate.by_status_code('QUIT')
    candidates.flatten!

    period_info = Reports::PeriodInfo.new
    period_info.add_candidates(candidates)

    @table = Reports::ReportTable.new("Team By Year")

    @table.header = ["Year", "Hired", "Here", "Left", "Net","Cum", "Sad TO", "Med TO", "Hap TO", "Vol. TO", "Tot. TO", "AVG", "Med"]

    period_info.year_info_map.values.sort{|a,b| a.year <=> b.year}.each do |year_info|

      year = year_info.year
      hired = year_info.started_in_year.size

      row = Array.new
      row << year
      row << hired
      row << year_info.still_here.size
      row << year_info.left_in_year.size
      row << period_info.net_gain(year)
      row << period_info.size(year)
      row << period_info.sad_turnover(year).round(2)
      row << period_info.med_turnover(year).round(2)
      row << period_info.happy_turnover(year).round(2)
      row << period_info.voluntary_turnover(year).round(2)
      row << period_info.turnover(year).round(2)
      row << period_info.average_tenure(year).round(2)
      row << period_info.median_tenure(year).round(2)

      @table.rows << row
    end

  end
end