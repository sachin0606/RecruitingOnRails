module CandidatesHelper
  def candidates_table(*args)
    candidates = args.first
    opts = args.second || {}

    interview_column_count = 0
    candidates.each { |c| interview_column_count = c.interviews.length if c.interviews.length > interview_column_count }
    code_submission_column_count = 0
    candidates.each { |s| code_submission_column_count = s.code_submissions.length if s.code_submissions.length > code_submission_column_count }

    out = "<table>"
    out += "<tr>"
    out += "<th>Name</th>"
    if opts[:include_code_submissions]
      1.upto(code_submission_column_count) do |i|
        out += "<th>Code Submission #{i}</th>"
      end
    end
    if opts[:include_interviews]
      1.upto(interview_column_count) do |i|
        out += "<th>Interview #{i}</th>"
      end
    end
    if opts[:include_references]
      out += "<th>References?</th>"
    end
    if opts[:include_time_served]
      out += "<th>Service Period</th>"
    end
    out += "</tr>"

    candidates.each do |candidate|
      out += "<tr>"
      out += "<td>"
      out += format_candidate(candidate)
      out += "</td>"
      if opts[:include_code_submissions]
        0.upto(code_submission_column_count-1) do |i|
          out += "<td>"
          out += format_submission(candidate.code_submissions[i])
          out += "</td>"
        end
      end
      if opts[:include_interviews]
        0.upto(interview_column_count-1) do |i|
          out += "<td>"
          out += candidate.interviews[i].nil? ? '&nbsp;' : (link_to approved_span(candidate.interviews[i]), interview_path(candidate.interviews[i]))
          out += "</td>"
        end
      end
      if opts[:include_references]
        out += "<td>"
        out += approved_span(candidate.reference_checks, :text => candidate.reference_checks.length)
        out += "</td>"
      end
      if opts[:include_time_served]
        out += "<td>#{time_since_hire(candidate)}</td>"
      end
      out += "</tr>"
    end
    out += "</table>"
    out.html_safe
  end

  def format_candidate(*args)
    candidate = args.first

    out = color_span candidate.experience_level, "#{candidate.name}"
    out += " (#{time_since_application(candidate)})" if candidate.in_pipeline?

    link_to out, candidate_path(candidate)
  end

  def time_since_application(candidate)
    distance_of_time_in_words_to_now(candidate.application_date)
  end

  def time_since_hire(candidate)
    if candidate.start_date.nil?
      "N/A"
    else
      distance_of_time_in_words_to_now(candidate.start_date)
    end
  end
end
