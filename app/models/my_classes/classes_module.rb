module MyClasses::ClassesModule
  extend self

  def initialize(uid)
    @uid = uid
  end

  def current_term
    @current_term ||= Berkeley::Terms.fetch.current
  end

  def current_term?(term_yr, term_cd)
    current_term.year == term_yr.to_i && current_term.code == term_cd
  end

  def course_site_entry(campus_courses, course_site)
    # My Classes only includes course sites for current terms.
    if (term_yr = course_site[:term_yr]) && (term_cd = course_site[:term_cd]) && current_term?(term_yr, term_cd)
      linked_campus = []
      if (sections = course_site[:sections])
        candidate_ccns = sections.collect {|s| s[:ccn].to_i}
        campus_courses.each do |campus|
          if campus[:term_yr] == term_yr && campus[:term_cd]
            if campus[:sections].index {|s| candidate_ccns.include?(s[:ccn].to_i)}.present?
              linked_campus << {id: campus[:listings].first[:id]}
            end
          end
        end
      end
      course_site.slice(:emitter, :id, :name, :shortDescription, :site_url).merge(
        {
          siteType: 'course',
          term_cd: term_cd,
          term_yr: term_yr,
          courses: linked_campus.uniq
        }
      )
    else
      nil
    end
  end

end
