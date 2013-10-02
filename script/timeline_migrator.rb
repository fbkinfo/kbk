Document.all.each do |d|
  d.send(:add_timeline_entry)
end