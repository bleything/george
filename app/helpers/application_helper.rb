# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
end

class TabularFormBuilder < ActionView::Helpers::FormBuilder
  (field_helpers - %w(check_box radiobutton hidden_field)).each do |selector|
    src = <<-END_SRC
      def #{selector}(field, options = {})
        @template.content_tag("tr",
          @template.content_tag("td", field.to_s.humanize, :class => 'label') +
          @template.content_tag("td", super, :class => 'field'))
      end
    END_SRC
    class_eval src, __FILE__, __LINE__
  end
end

def tabular_form_for(name, object = nil, options = nil, &proc)
  concat("<table>", proc.binding)
  form_for(name,
           object,
           (options || {}).merge(:builder => TabularFormBuilder),
           &proc
          )
  concat("</table>", proc.binding)
end