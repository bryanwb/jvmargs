

def get_total_ram_kb
  require 'ohai'
  ohai = Ohai::System.new
  ohai.require_plugin "linux::memory"
  total_ram = ohai["memory"]["total"].sub(/kB/,'')
end

