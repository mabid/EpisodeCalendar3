ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /<(input)[^>]+type=[""](radio|checkbox|hidden)/
    "<span class=\"special_field_with_errors\">#{html_tag}</span>".html_safe
  else
    "<span class=\"field_with_errors\">#{html_tag}</span>".html_safe
  end
end