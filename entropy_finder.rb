#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def examine_file(file)
  found = false
  row = 0
  File.open(file) do |handle|
    handle.each_line do |full_line|
      row += 1
      begin
        full_line.split.each do |word|
          value = entropy(word)
          next unless value > @options[:threshold]

          unless found
            found = true
            print("#{file}\n")
          end
          print("  Line:#{row} (#{value.round(1)}) '#{word.length > 72 ? "#{word[0, 72]}..." : word}'\n")
        end
      rescue ArgumentError
        next
      end
    end
  end
end

def entropy(word)
  tally = {}
  size = word.length
  accumulator = 0
  word.split('') do |char|
    tally[char] = 0 unless tally.key?(char)
    tally[char] += 1
  end
  tally.each_value do |c|
    frequency = c.to_f / size
    accumulator += -(frequency * Math.log2(frequency))
  end
  accumulator
end

def handle_input(file)
  if File.directory?(file)
    expand_dir(file)
  elsif File.exist?(file)
    filter_file(file)
  else
    print("#{file} is not a file or directory, skipping!\n")
  end
end

def filter_file(file)
  if @options[:include_files]
    matched = false
    @options[:include_files].each do |include|
      matched = true if file.end_with?(include)
    end
    return unless matched
  end

  @options[:exclude_files]&.each do |exclude|
    return if file.end_with?(exclude)
  end
  examine_file(file)
end

def expand_dir(dir)
  @options[:exclude_dirs]&.each do |exclude|
    return if /\b#{exclude}\b/.match?(dir)
  end
  contents = Dir.glob(File.join(dir, '*'))
  contents.each do |file|
    handle_input(file)
  end
end

DEFAULT_THRESHOLD = 4.2
@options = {
  threshold: DEFAULT_THRESHOLD
}

OptionParser.new do |opt|
  opt.banner = 'Usage: find_entropy.rb [options] [<files and/or directories>]'
  opt.on('-t VALUE',
         '--threshold VALUE',
         "Set the entropy threshold to report on (default: #{DEFAULT_THRESHOLD})",
         Float) do |t|
    @options[:threshold] = t.to_f
  end
  opt.on('-i VALUE',
         '--include VALUE',
         'Scan only files matching the value or values, e.g. ".cs" or ".rb,.json"') do |i|
    @options[:include] = i
  end
  opt.on('-e VALUE',
         '--exclude VALUE',
         'Do not scan files matching extension e.g. ".css" or ".yml,.html"') do |e|
    @options[:exclude] = e
  end
  opt.on('-x VALUE',
         '--exclude_dir VALUE',
         'Do not scan files within matching directories e.g. "bin" or "obj,cache"') do |x|
    @options[:exclude_dir] = x
  end
end.parse!

file_list = ARGV

if file_list.empty?
  print("Usage: ./find_entropy.rb -h\n")
  print("\tPlease specify at least one file or directory to scan.\n")
else
  @options[:include_files] = @options[:include].split(',') if @options[:include]
  @options[:exclude_files] = @options[:exclude].split(',') if @options[:exclude]
  @options[:exclude_dirs] = @options[:exclude_dir].split(',') if @options[:exclude_dir]
  file_list.each do |file|
    handle_input(file)
  end
end
