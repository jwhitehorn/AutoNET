require 'opencl_ruby_ffi'
require 'narray_ffi'

puts "AutoNET"

if OpenCL::platforms.length > 1
  puts "Multiple platforms available, defaulting to the first"
end
platform = OpenCL::platforms.first

if platform.devices.length > 1
  puts "Multiple devices available on the selected platform, default to the first"
  puts platform.devices
end
device = platform.devices.first

context = OpenCL::create_context(device)
queue = context.create_command_queue(device, :properties => OpenCL::CommandQueue::PROFILING_ENABLE)
