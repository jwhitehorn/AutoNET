require 'opencl_ruby_ffi'
require 'narray_ffi'
require 'args_parser'

puts "AutoNET\n\n"

if OpenCL::platforms.length == 0
  puts "ERROR: no OpenCL devices found. Exiting."
  exit 0
end

args = ArgsParser.parse ARGV do
  arg :device, 'OpenCL device', :alias => :d, :default => '0,0'
  arg :ld, 'List OpenCL devices'
  arg :help, 'Show Help', :alias => :h
end

if args.has_option? :help
  STDERR.puts args.help
  exit 1
end

if args.has_option? :ld
  puts "Available OpenCL devices:"
  OpenCL::platforms.each.with_index do |platform, i|
    platform.devices.each.with_index do |device, j|
      puts "#{i},#{j} - #{platform}/#{device}"
    end
  end
  exit 1
end

platform = nil
device = nil
begin
  options = args[:device].split ','
  platform = OpenCL::platforms[options[0].to_i]
  device = platform.devices[options[1].to_i]
rescue
  puts "Unable to locate OpenCL device #{args[:device]}"
end
puts "Utilizing OpenCL device #{args[:device]} - #{platform}/#{device}"

context = OpenCL::create_context(device)
queue = context.create_command_queue(device, :properties => OpenCL::CommandQueue::PROFILING_ENABLE)

prog = context.create_program_with_source( File.open('./opencl/activate_layer.cl').read )
prog.build
