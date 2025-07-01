;; extends
(uri_autolink) @markup.autolink

(inline_link
    (link_text) @markup.link.text
    (link_destination) @markup.link.destination)

(full_reference_link
  (link_text) @markup.link.text
  (link_label) @markup.link.label) @markup.reference.link

(image
  (image_description) @markup.link.text
  (link_destination) @markup.autolink @markup.link.destination
) @markup.image
